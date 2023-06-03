/* Funciones y procedimientos para registrar un cliente, métodos de pago y vehículos.
El cliente hace su registro en la aplicación de forma secuencial en dos pasos.
El registro de vehículos y métodos de pago puede hacerse en cualquier momento después de un registro exitoso.*/

-- 1. El cliente diligencia su información personal y el sistema registra esta información.
-- La función retorna una clave aleatoria y la invalida para forzar el cambio de clave posteriormente.
CREATE OR REPLACE FUNCTION PARQUEADERO.CREAR_CLIENTE_FU(
    IN TIPO_IDENTIFICACION_P PARQUEADERO.CLIENTE.TIPO_IDENTIFICACION_CLIENTE%TYPE,
    IN NUMERO_IDENTIFICACION_P PARQUEADERO.CLIENTE.NUMERO_IDENTIFICACION_CLIENTE%TYPE,
    IN NOMBRE1_CLIENTE_P PARQUEADERO.CLIENTE.NOMBRE1_CLIENTE%TYPE,
    IN NOMBRE2_CLIENTE_P PARQUEADERO.CLIENTE.NOMBRE2_CLIENTE%TYPE,
    IN APELLIDO1_CLIENTE_P PARQUEADERO.CLIENTE.APELLIDO1_CLIENTE%TYPE,
    IN APELLIDO2_CLIENTE_P PARQUEADERO.CLIENTE.APELLIDO2_CLIENTE%TYPE,
    IN TELEFONO_CLIENTE_P PARQUEADERO.CLIENTE.TELEFONO_CLIENTE%TYPE,
    IN CORREO_CLIENTE_P VARCHAR
)
RETURNS TEXT
LANGUAGE PLPGSQL
PARALLEL UNSAFE
AS $$
DECLARE
    -- Declaración de variables locales
    CORREO_EXISTE_L BOOLEAN;
    CORREO_ENCRIPTADO_L BYTEA := PARQUEADERO.PGP_SYM_ENCRYPT(CORREO_CLIENTE_P::VARCHAR, 'AES_KEY'::VARCHAR);
    FECHA_CLAVE_L TIMESTAMP := '2000-01-01 00:00';
    CLAVE_ALEATORIA_L TEXT;
    -- Códigos de error
    CODIGO_ERROR_L TEXT;
    RESUMEN_ERROR_L TEXT;
    MENSAJE_ERROR_L TEXT;
BEGIN
    -- Genera una clave aleatoria para el usuario nuevo
    SELECT PARQUEADERO.CLAVE_ALEATORIA_FU(12) INTO CLAVE_ALEATORIA_L;

    -- Crea el usuario en la base de datos con su rol correspondiente
    EXECUTE FORMAT('CREATE ROLE %I WITH LOGIN PASSWORD %L VALID UNTIL %L IN ROLE USER_ROLE', CORREO_CLIENTE_P, CLAVE_ALEATORIA_L, FECHA_CLAVE_L);

    -- Bloquea temporalmente las filas que se van a modificar en la tabla
    LOCK PARQUEADERO.CLIENTE IN ROW EXCLUSIVE MODE;

    -- Inserta los datos del cliente en la tabla Cliente de la BD
    INSERT INTO PARQUEADERO.CLIENTE(
        TIPO_IDENTIFICACION_CLIENTE,
        NUMERO_IDENTIFICACION_CLIENTE,
        NOMBRE1_CLIENTE,
        NOMBRE2_CLIENTE,
        APELLIDO1_CLIENTE,
        APELLIDO2_CLIENTE,
        TELEFONO_CLIENTE,
        CORREO_CLIENTE
    )
    VALUES (
        TIPO_IDENTIFICACION_P,
        NUMERO_IDENTIFICACION_P,
        NOMBRE1_CLIENTE_P,
        NOMBRE2_CLIENTE_P,
        APELLIDO1_CLIENTE_P,
        APELLIDO2_CLIENTE_P,
        TELEFONO_CLIENTE_P,
        CORREO_ENCRIPTADO_L
    );  

    -- Devuelve la clave generada
    RETURN CLAVE_ALEATORIA_L;
EXCEPTION
    -- Excepciones
    WHEN DUPLICATE_OBJECT THEN
        RAISE EXCEPTION 'Este correo ya está registrado en la base de datos.';
    WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS 
            CODIGO_ERROR_L = RETURNED_SQLSTATE,
            RESUMEN_ERROR_L = MESSAGE_TEXT,
            MENSAJE_ERROR_L = PG_EXCEPTION_CONTEXT;
        RETURN CONCAT(CODIGO_ERROR_L, ' ', RESUMEN_ERROR_L, ' ',MENSAJE_ERROR_L);
END;
$$;

COMMENT ON FUNCTION PARQUEADERO.CREAR_CLIENTE_FU IS E'Procedimiento para crear un usuario en la base de datos, asignar una clave aleatoria e invalidar esa clave para así forzar al usuario que la cambie.';

ALTER FUNCTION PARQUEADERO.CREAR_CLIENTE_FU OWNER TO PARKUD_DB_ADMIN;

GRANT EXECUTE ON FUNCTION PARQUEADERO.CREAR_CLIENTE_FU TO MANAGE_ACCOUNT_USER;


-- 2. Una vez creado el usuario el cliente debe hacer un primer cambio de clave.
-- El siguiente procedimiento cambia la clave del usuario.
CREATE OR REPLACE PROCEDURE PARQUEADERO.PRIMER_CAMBIO_CLAVE_PR(
    IN NOMBRE_USUARIO_P TEXT, 
    IN CLAVE_NUEVA_P TEXT
)
LANGUAGE PLPGSQL
AS $$
DECLARE
    -- Declaración de variables locales
    FECHA_VALIDEZ_L CONSTANT DATE := '2050-01-01';
    FECHA_ACTUAL_L PG_USER.VALUNTIL%TYPE;
    -- Códigos de error
    CODIGO_ERROR_L TEXT;
    RESUMEN_ERROR_L TEXT;
    MENSAJE_ERROR_L TEXT;
BEGIN
    -- Toma la fecha de validación de la clave actual del usuario de la BD.
    SELECT VALUNTIL INTO FECHA_ACTUAL_L
    FROM PG_USER
    WHERE VALUNTIL IS NOT NULL 
        AND PG_USER.USENAME = NOMBRE_USUARIO_P;

    -- Si la fecha de validación no ha sido modificada, hace el cambio de clave.
    -- Si la fecha de validación ha sido modificada, este no es el primer cambio de clave del usuario.
    -- IF FECHA_ACTUAL_L::TIMESTAMP != FECHA_VALIDEZ_L::TIMESTAMP THEN
        EXECUTE FORMAT('ALTER USER %I WITH PASSWORD %L ', NOMBRE_USUARIO_P, CLAVE_NUEVA_P);
        EXECUTE FORMAT('ALTER USER %I VALID UNTIL %L', NOMBRE_USUARIO_P, FECHA_VALIDEZ_L);
    -- ELSE 
    --     ROLLBACK;
    --     RAISE EXCEPTION 'El usuario ingresado ya ha hecho su primer cambio de clave.';
    -- END IF;
EXCEPTION
    -- Excepciones
    WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS 
            CODIGO_ERROR_L := RETURNED_SQLSTATE,
            RESUMEN_ERROR_L := MESSAGE_TEXT,
            MENSAJE_ERROR_L := PG_EXCEPTION_CONTEXT;
        RAISE EXCEPTION 'Código de error: % / Resumen del error: % / Mensaje de error: %', CODIGO_ERROR_L, RESUMEN_ERROR_L, MENSAJE_ERROR_L;
END;
$$;

COMMENT ON PROCEDURE PARQUEADERO.PRIMER_CAMBIO_CLAVE_PR IS E'Procedimiento para hacer el primer cambio de clave de un usuario.';

ALTER PROCEDURE PARQUEADERO.PRIMER_CAMBIO_CLAVE_PR OWNER TO PARKUD_DB_ADMIN;

GRANT EXECUTE ON PROCEDURE PARQUEADERO.PRIMER_CAMBIO_CLAVE_PR TO MANAGE_ACCOUNT_USER;


-- Una vez creado el usuario del cliente, este puede insertar un vehículo en la plataforma.
CREATE OR REPLACE PROCEDURE PARQUEADERO.AGREGAR_VEHICULO_PR(
    IN TIPO_VEHICULO_P PARQUEADERO.VEHICULO.TIPO_VEHICULO%TYPE,
    IN PLACA_P PARQUEADERO.VEHICULO.PLACA_VEHICULO%TYPE,
    IN NOMBRE_1_P PARQUEADERO.VEHICULO.NOMBRE1_PROPIETARIO%TYPE,
    IN NOMBRE_2_P PARQUEADERO.VEHICULO.NOMBRE2_PROPIETARIO%TYPE,
    IN APELLIDO_1_P PARQUEADERO.VEHICULO.APELLIDO1_PROPIETARIO%TYPE,
    IN APELLIDO_2_P PARQUEADERO.VEHICULO.APELLIDO2_PROPIETARIO%TYPE,
    IN MARCA_VEHICULO_P PARQUEADERO.VEHICULO.K_MARCA_VEHICULO%TYPE,
    IN COLOR_VEHICULO_P PARQUEADERO.VEHICULO.COLOR_VEHICULO%TYPE
)
LANGUAGE PLPGSQL
AS $$
DECLARE
    -- Declaración de variables locales
    K_CLIENTE_L PARQUEADERO.CLIENTE.K_CLIENTE%TYPE;
    -- Códigos de error
    CODIGO_ERROR_L TEXT;
    RESUMEN_ERROR_L TEXT;
    MENSAJE_ERROR_L TEXT;
BEGIN
    -- Recupera la clave primaria del cliente conectado a la BD
    K_CLIENTE_L := PARQUEADERO.RECUPERAR_LLAVE_CLIENTE_FU();

    -- Bloquea temporalmente las filas que se van a modificar en la tabla
    LOCK PARQUEADERO.VEHICULO IN ROW EXCLUSIVE MODE;
    
    -- Inserta el vehículo en la tabla de vehículos de la BD
    INSERT INTO PARQUEADERO.VEHICULO(
        K_MARCA_VEHICULO,
        K_CLIENTE,
        PLACA_VEHICULO,
        NOMBRE1_PROPIETARIO,
        NOMBRE2_PROPIETARIO,
        APELLIDO1_PROPIETARIO,
        APELLIDO2_PROPIETARIO,
        TIPO_VEHICULO,
        COLOR_VEHICULO
    )
    VALUES (
        MARCA_VEHICULO_P,
        K_CLIENTE_L,
        PLACA_P,
        NOMBRE_1_P,
        NOMBRE_2_P,
        APELLIDO_1_P,
        APELLIDO_2_P,
        TIPO_VEHICULO_P,
        COLOR_VEHICULO_P
    ) ON CONFLICT (K_CLIENTE, PLACA_VEHICULO) DO
    UPDATE SET K_MARCA_VEHICULO = EXCLUDED.K_MARCA_VEHICULO,
        NOMBRE1_PROPIETARIO = EXCLUDED.NOMBRE1_PROPIETARIO,
        NOMBRE2_PROPIETARIO = EXCLUDED.NOMBRE2_PROPIETARIO,
        APELLIDO1_PROPIETARIO = EXCLUDED.APELLIDO1_PROPIETARIO,
        APELLIDO2_PROPIETARIO = EXCLUDED.APELLIDO2_PROPIETARIO,
        TIPO_VEHICULO = EXCLUDED.TIPO_VEHICULO,
        COLOR_VEHICULO = EXCLUDED.COLOR_VEHICULO;
EXCEPTION
    -- Excepciones
    WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS 
            CODIGO_ERROR_L := RETURNED_SQLSTATE,
            RESUMEN_ERROR_L := MESSAGE_TEXT,
            MENSAJE_ERROR_L := PG_EXCEPTION_CONTEXT;
        RAISE EXCEPTION 'Código de error: % / Resumen del error: % / Mensaje de error: %', CODIGO_ERROR_L, RESUMEN_ERROR_L, MENSAJE_ERROR_L;
END;
$$;

COMMENT ON PROCEDURE PARQUEADERO.AGREGAR_VEHICULO_PR IS E'Procedimiento para insertar un vehículo.';

ALTER PROCEDURE PARQUEADERO.AGREGAR_VEHICULO_PR OWNER TO PARKUD_DB_ADMIN;


-- Una vez creado el usuario del cliente, este puede insertar un método de pago en la plataforma.
-- El procedimiento encripta toda la información de la tarjeta para mayor seguridad.
CREATE OR REPLACE PROCEDURE PARQUEADERO.INSERTAR_METODO_PAGO_PR(
    IN NOMBRE_DUENIO_TARJETA_P VARCHAR,
    IN APELLIDO_DUENIO_TARJETA_P VARCHAR,
    IN NUMERO_TARJETA_P VARCHAR,
    IN ULTIMOS_CUATRO_DIGITOS_P VARCHAR,
    IN MES_VENCIMIENTO_P NUMERIC(2),
    IN ANIO_VENCIMIENTO_P NUMERIC(4),
    IN TIPO_TARJETA_P VARCHAR,
    INOUT CODIGO_ERROR_P TEXT DEFAULT NULL,
    INOUT RESUMEN_ERROR_P TEXT DEFAULT NULL,
    INOUT MENSAJE_ERROR_P TEXT DEFAULT NULL
)
LANGUAGE PLPGSQL
AS $$
DECLARE 
    -- Declaración de variables locales
    K_CLIENTE_L PARQUEADERO.CLIENTE.K_CLIENTE%TYPE;
    -- Códigos de error
    CODIGO_ERROR_L TEXT;
    RESUMEN_ERROR_L TEXT;
    MENSAJE_ERROR_L TEXT;
BEGIN
    -- Recupera la clave primaria del cliente conectado a la BD
    K_CLIENTE_L := PARQUEADERO.RECUPERAR_LLAVE_CLIENTE_FU();

    -- Bloquea temporalmente las filas que se van a modificar en la tabla
    LOCK PARQUEADERO.TARJETA_PAGO IN ROW EXCLUSIVE MODE;

    -- Inserta la información de método de pago
    INSERT INTO PARQUEADERO.TARJETA_PAGO (
        K_CLIENTE,
        NOMBRE_DUENIO_TARJETA,
        APELLIDO_DUENIO_TARJETA,
        NUMERO_TARJETA,
        ULTIMOS_CUATRO_DIGITOS,
        MES_VENCIMIENTO,
        ANIO_VENCIMIENTO,
        TIPO_TARJETA
    ) VALUES (
        K_CLIENTE_L,
        (SELECT PARQUEADERO.PGP_SYM_ENCRYPT(NOMBRE_DUENIO_TARJETA_P::VARCHAR, 'AES_KEY'::VARCHAR)),
        (SELECT PARQUEADERO.PGP_SYM_ENCRYPT(APELLIDO_DUENIO_TARJETA_P::VARCHAR, 'AES_KEY'::VARCHAR)),
        (SELECT PARQUEADERO.PGP_SYM_ENCRYPT(NUMERO_TARJETA_P::VARCHAR, 'AES_KEY'::VARCHAR)),
        (SELECT PARQUEADERO.PGP_SYM_ENCRYPT(ULTIMOS_CUATRO_DIGITOS_P::VARCHAR, 'AES_KEY'::VARCHAR)),
        (SELECT PARQUEADERO.PGP_SYM_ENCRYPT(MES_VENCIMIENTO_P::VARCHAR, 'AES_KEY'::VARCHAR)),
        (SELECT PARQUEADERO.PGP_SYM_ENCRYPT(ANIO_VENCIMIENTO_P::VARCHAR, 'AES_KEY'::VARCHAR)),
        (SELECT PARQUEADERO.PGP_SYM_ENCRYPT(TIPO_TARJETA_P::VARCHAR, 'AES_KEY'::VARCHAR))
    );
EXCEPTION
    -- Excepciones
    WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS 
            CODIGO_ERROR_L := RETURNED_SQLSTATE,
            RESUMEN_ERROR_L := MESSAGE_TEXT,
            MENSAJE_ERROR_L := PG_EXCEPTION_CONTEXT;
        RAISE EXCEPTION 'Código de error: % / Resumen del error: % / Mensaje de error: %', CODIGO_ERROR_L, RESUMEN_ERROR_L, MENSAJE_ERROR_L;
END;
$$;

COMMENT ON PROCEDURE PARQUEADERO.AGREGAR_VEHICULO_PR IS E'Procedimiento para insertar un método de pago.';

ALTER PROCEDURE PARQUEADERO.INSERTAR_METODO_PAGO_PR OWNER TO PARKUD_DB_ADMIN;