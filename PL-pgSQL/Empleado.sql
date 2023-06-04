/* Funciones y procedimientos relacionadas a la creación de empleados y gestión de los mismos.
Los empleados pueden ser operadores, administradores o súper administradores
La gestión de empleado se corresponde con la asignación de cargos, horarios y la(s) sucursale(s) para las que trabaja. */

CREATE OR REPLACE FUNCTION PARQUEADERO.CREAR_EMPLEADO_FU(
    IN TIPO_IDENTIFICACION_P PARQUEADERO.EMPLEADO.TIPO_IDENTIFICACION_EMPLEADO%TYPE,
    IN NUMERO_IDENTIFICACION_P PARQUEADERO.EMPLEADO.NUMERO_IDENTIFICACION_EMP%TYPE,
    IN NOMBRE1_EMPLEADO_P PARQUEADERO.EMPLEADO.NOMBRE1_EMPLEADO%TYPE,
    IN NOMBRE2_EMPLEADO_P PARQUEADERO.EMPLEADO.NOMBRE2_EMPLEADO%TYPE,
    IN APELLIDO1_EMPLEADO_P PARQUEADERO.EMPLEADO.APELLIDO1_EMPLEADO%TYPE,
    IN APELLIDO2_EMPLEADO_P PARQUEADERO.EMPLEADO.APELLIDO2_EMPLEADO%TYPE,
    IN TELEFONO_EMPLEADO_P PARQUEADERO.EMPLEADO.TELEFONO_EMPLEADO%TYPE,
    IN CORREO_EMPLEADO_P VARCHAR,
    IN CARGO_EMPLEADO_P PARQUEADERO.CARGO.K_NOMBRE_CARGO%TYPE
)
RETURNS TEXT
LANGUAGE PLPGSQL
PARALLEL UNSAFE
AS $$
DECLARE
    -- Declaración de variables locales
    CORREO_ENCRIPTADO_L BYTEA := PARQUEADERO.PGP_SYM_ENCRYPT(CARGO_EMPLEADO_P::VARCHAR, 'AES_KEY'::VARCHAR);
    CLAVE_ALEATORIA_L TEXT;
    ROL_EMPLEADO_L VARCHAR;
    K_EMPLEADO_L PARQUEADERO.EMPLEADO.K_EMPLEADO%TYPE;
    -- Códigos de error
    CODIGO_ERROR_L TEXT;
    RESUMEN_ERROR_L TEXT;
    MENSAJE_ERROR_L TEXT;
BEGIN
    -- Recupera la clave primaria del empleado que está ejecutando la función
    K_EMPLEADO_L := PARQUEADERO.RECUPERAR_LLAVE_EMPLEADO_FU();

    -- Selecciona el rol del empleado está tratando de registrar a otro empleado
    SELECT LOWER(TRIM(G.ROLNAME)) INTO STRICT ROL_EMPLEADO_L
    FROM PG_ROLES R
        JOIN PG_AUTH_MEMBERS M ON R.OID = M.MEMBER
        JOIN PG_ROLES G ON M.ROLEID = G.OID
    WHERE R.ROLNAME = CURRENT_USER;
    
    -- Un administrador no puede ingresar a otro administrador o a un súper administrador
    IF UPPER(TRIM(ROL_EMPLEADO_L)) = 'ADMIN_ROLE' AND (CARGO_EMPLEADO_P = 'Administrador' OR CARGO_EMPLEADO_P = 'Súper Administrador') THEN
        RAISE EXCEPTION 'Un administrador solo puede agregar operadores.';
    -- Un operador no puede ingresar a ningún empleado
    ELSIF UPPER(TRIM(ROL_EMPLEADO_L)) = 'OPERADOR_ROLE' THEN
        RAISE EXCEPTION 'Los operadores no pueden agregar empleados.';
    -- De a momento la función solo contempla inserción de operadores por medio de administradores
    ELSIF UPPER(TRIM(ROL_EMPLEADO_L)) = 'SUPER_ADMIN_ROLE' THEN
        RAISE EXCEPTION 'No.';
    END IF;

    -- Selecciona los roles de la BD en base al cargo ingresado
    IF CARGO_EMPLEADO_P = 'Administrador' THEN 
        ROL_EMPLEADO_L := 'ADMIN_ROLE';
    ELSIF CARGO_EMPLEADO_P = 'Operador' THEN 
        ROL_EMPLEADO_L := 'OPERADOR_ROLE';
    ELSIF CARGO_EMPLEADO_P = 'Súper Administrador' THEN 
        ROL_EMPLEADO_L := 'SUPER_ADMIN_ROLE';
    END IF;

    -- Genera una clave aleatoria para el usuario nuevo
    SELECT PARQUEADERO.CLAVE_ALEATORIA_FU(12) INTO CLAVE_ALEATORIA_L;

    -- Crea el usuario en la base de datos con su rol correspondiente
    EXECUTE FORMAT('CREATE ROLE %I WITH INHERIT LOGIN PASSWORD %L IN ROLE L%', CORREO_EMPLEADO_P, CLAVE_ALEATORIA_L, ROL_EMPLEADO_L);

    -- Si un administrador inserta a un operador
    IF CARGO_EMPLEADO_P = 'Operador' AND UPPER(TRIM(ROL_USUARIO_P)) = 'ADMIN_ROLE' THEN
        CALL PARQUEADERO.INSERTAR_OPERADOR_ADMIN_PR(
            TIPO_IDENTIFICACION_P,
            NUMERO_IDENTIFICACION_P,
            NOMBRE1_EMPLEADO_P,
            NOMBRE2_EMPLEADO_P,
            APELLIDO1_EMPLEADO_P,
            APELLIDO2_EMPLEADO_P,
            TELEFONO_EMPLEADO_P,
            CORREO_ENCRIPTADO_L,
            K_EMPLEADO_L
        );
    END IF;

    RETURN CLAVE_ALEATORIA_L;
EXCEPTION
    -- Excepciones
    WHEN DUPLICATE_OBJECT THEN
        RAISE EXCEPTION 'Este correo ya está registrado en la base de datos.';
    WHEN NO_DATA_FOUND THEN
        RAISE EXCEPTION 'El empleado no tiene ningún rol asociado en la BD.';
    WHEN TOO_MANY_ROWS THEN
        RAISE EXCEPTION 'Inconsistencias en la BD: Hay más de un rol asociado a este empleado.';
    WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS 
            CODIGO_ERROR_L := RETURNED_SQLSTATE,
            RESUMEN_ERROR_L := MESSAGE_TEXT,
            MENSAJE_ERROR_L := PG_EXCEPTION_CONTEXT;
        RAISE EXCEPTION 'Código de error: % / Resumen del error: % / Mensaje de error: %', CODIGO_ERROR_L, RESUMEN_ERROR_L, MENSAJE_ERROR_L;
END;
$$;

COMMENT ON FUNCTION PARQUEADERO.CREAR_EMPLEADO_FU IS E'Función para insertar empleados en el sistema de información.';

ALTER FUNCTION PARQUEADERO.CREAR_EMPLEADO_FU OWNER TO PARKUD_DB_ADMIN;

/* Los administradores solo pueden agregar operadores a la sucursal que administran.
El siguiente procedimiento agrega el operador, asigna su cargo y la sucursal en la que debe trabajar.
La sucursal se selecciona de acuerdo al amdministrador que esté haciendo la inserción.*/
CREATE OR REPLACE PROCEDURE PARQUEADERO.INSERTAR_OPERADOR_ADMIN_PR(
    IN TIPO_IDENTIFICACION_P PARQUEADERO.EMPLEADO.TIPO_IDENTIFICACION_EMPLEADO%TYPE,
    IN NUMERO_IDENTIFICACION_P PARQUEADERO.EMPLEADO.NUMERO_IDENTIFICACION_EMP%TYPE,
    IN NOMBRE1_EMPLEADO_P PARQUEADERO.EMPLEADO.NOMBRE1_EMPLEADO%TYPE,
    IN NOMBRE2_EMPLEADO_P PARQUEADERO.EMPLEADO.NOMBRE2_EMPLEADO%TYPE,
    IN APELLIDO1_EMPLEADO_P PARQUEADERO.EMPLEADO.APELLIDO1_EMPLEADO%TYPE,
    IN APELLIDO2_EMPLEADO_P PARQUEADERO.EMPLEADO.APELLIDO2_EMPLEADO%TYPE,
    IN TELEFONO_EMPLEADO_P PARQUEADERO.EMPLEADO.TELEFONO_EMPLEADO%TYPE,
    IN CORREO_ENCRIPTADO_P VARCHAR,
    IN K_ADMIN_P PARQUEADERO.EMPLEADO.K_EMPLEADO%TYPE
)
LANGUAGE PLPGSQL
AS $$
DECLARE
    -- Declaración de variables locales
    K_EMPLEADO_L PARQUEADERO.EMPLEADO.K_EMPLEADO%TYPE;
    K_SUCURSAL_L PARQUEADERO.SUCURSAL.K_SUCURSAL%TYPE;
    -- Códigos de error
    CODIGO_ERROR_L TEXT;
    RESUMEN_ERROR_L TEXT;
    MENSAJE_ERROR_L TEXT;
BEGIN
    -- Selecciona la sucursal en la que el administrador trabaja
    SELECT K_SUCURSAL INTO STRICT K_SUCURSAL_L
    FROM PARQUEADERO.SUCURSAL S
        INNER JOIN PARQUEADERO.TRABAJA T ON S.K_SUCURSAL = T.K_SUCURSAL
        INNER JOIN PARQUEADERO.EMPLEADO E ON T.K_EMPLEADO = E.K_EMPLEADO
        INNER JOIN PARQUEADERO.EJERCE EJ ON E.K_EMPLEADO = EJ.K_EMPLEADO
        INNER JOIN PARQUEADERO.CARGO C ON EJ.K_NOMBRE_CARGO = C.K_NOMBRE_CARGO
    WHERE E.K_EMPLEADO = K_ADMIN_P
        AND C.K_NOMBRE_CARGO = 'Administrador';

    -- Bloquea temporalmente las filas que se van a modificar en la tabla
    LOCK PARQUEADERO.EMPLEADO IN ROW EXCLUSIVE MODE;
    
    -- Inserta los datos del operador en la tabla empleado de la BD
    INSERT INTO PARQUEADERO.EMPLEADO(
        TIPO_IDENTIFICACION_EMPLEADO,
        NUMERO_IDENTIFICACION_EMP,
        NOMBRE1_EMPLEADO,
        NOMBRE2_EMPLEADO,
        APELLIDO1_EMPLEADO,
        APELLIDO2_EMPLEADO,
        TELEFONO_EMPLEADO,
        CORREO_EMPLEADO
    )
    VALUES (
        TIPO_IDENTIFICACION_P,
        NUMERO_IDENTIFICACION_P,
        NOMBRE1_EMPLEADO_P,
        NOMBRE2_EMPLEADO_P,
        APELLIDO1_EMPLEADO_P,
        APELLIDO2_EMPLEADO_P,
        TELEFONO_EMPLEADO_P,
        CORREO_ENCRIPTADO_P
    ) RETURNING K_EMPLEADO INTO K_EMPLEADO_L;

    -- Bloquea temporalmente las filas que se van a modificar en la tabla
    LOCK PARQUEADERO.EJERCE IN ROW EXCLUSIVE MODE;

    -- Inserta el cargo en la tabla ejerce
    INSERT INTO PARQUEADERO.EJERCE (
        K_EMPLEADO,
        K_NOMBRE_CARGO,
        FECHA_INICIO_CARGO,
        ES_CARGO_ACTIVO
    ) VALUES (
        K_EMPLEADO_L,
        'Operador',
        (SELECT CURRENT_TIMESTAMP AT TIME ZONE 'America/Bogota'),
        TRUE
    );

    -- Bloquea temporalmente las filas que se van a modificar en la tabla
    LOCK PARQUEADERO.TRABAJA IN ROW EXCLUSIVE MODE;

    -- Inserta la sucursal en la que trabajará
    INSERT INTO PARQUEADERO.TRABAJA (
        K_SUCURSAL,
        K_EMPLEADO
    ) VALUES (
        K_SUCURSAL_L,
        K_EMPLEADO_L
    );
EXCEPTION
    -- Excepciones
    WHEN NO_DATA_FOUND THEN
        RAISE EXCEPTION 'El administrador no se encuentra activo en ninguna sucursal.';
    WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS 
            CODIGO_ERROR_L := RETURNED_SQLSTATE,
            RESUMEN_ERROR_L := MESSAGE_TEXT,
            MENSAJE_ERROR_L := PG_EXCEPTION_CONTEXT;
        RAISE EXCEPTION 'Código de error: % / Resumen del error: % / Mensaje de error: %', CODIGO_ERROR_L, RESUMEN_ERROR_L, MENSAJE_ERROR_L;
END;
$$;

COMMENT ON PROCEDURE PARQUEADERO.INSERTAR_OPERADOR_ADMIN_PR IS E'Procedimiento para que un administrador pueda insertar un operador en la sucursal que administra.';

ALTER PROCEDURE PARQUEADERO.INSERTAR_OPERADOR_ADMIN_PR OWNER TO PARKUD_DB_ADMIN;