/* Existen algunas funciones y procedimientos que son utilizadas por otras transacciones en la BD.
Estas funciones son utilizadas para hacer alguna transacción específica y hacen parte de transacciones más grandes en otras funciones.*/

-- Función que crea una cadena de carácteres aleatoria dado un tamaño.
CREATE OR REPLACE FUNCTION PARQUEADERO.CLAVE_ALEATORIA_FU(
    IN TAMANIO_P INTEGER DEFAULT 10)
RETURNS TEXT
LANGUAGE PLPGSQL
PARALLEL UNSAFE
AS $$
DECLARE
    -- Declaración de variables locales
    CHARS TEXT[] := '{0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z}';
    RESULT TEXT := '';
    I INTEGER := 0;
BEGIN
    -- Si el número ingresado es menor que cero, se cambia su signo
    IF TAMANIO_P < 0 THEN
        TAMANIO_P := TAMANIO_P * -1;
    END IF;

    -- Genera la clave aleatoria
    FOR I IN 1..TAMANIO_P LOOP
        RESULT := RESULT || CHARS[1 + RANDOM() * (ARRAY_LENGTH(CHARS, 1) - 1)];
    END LOOP;

    -- Devuelve la clave generada
    RETURN RESULT;
END;
$$;

COMMENT ON FUNCTION PARQUEADERO.CLAVE_ALEATORIA_FU IS E'Función que crea una cadena de carácteres aleatoria dado un tamaño.';

ALTER FUNCTION PARQUEADERO.CLAVE_ALEATORIA_FU OWNER TO PARKUD_DB_ADMIN;


-- Función que devuelve el día de la semana con su respectivo nombre dada una fecha.
CREATE OR REPLACE FUNCTION PARQUEADERO.OBTENER_DIA_FECHA_FU(
    IN FECHA_P DATE)
RETURNS VARCHAR
LANGUAGE PLPGSQL
STABLE
PARALLEL SAFE
AS $$
DECLARE
    -- Declaración de variables locales
    NUM_DIA_SEMANA_L INTEGER;
BEGIN
    -- Devuelve el día de la semana dependiendo de la fecha de entrada
    SELECT
        EXTRACT(DOW FROM DATE(FECHA_P)) INTO NUM_DIA_SEMANA_L;
    IF NUM_DIA_SEMANA_L = 0 THEN
        RETURN 'Domingo';
    ELSIF NUM_DIA_SEMANA_L = 1 THEN
        RETURN 'Lunes';
    ELSIF NUM_DIA_SEMANA_L = 2 THEN
        RETURN 'Martes';
    ELSIF NUM_DIA_SEMANA_L = 3 THEN
        RETURN 'Miércoles';
    ELSIF NUM_DIA_SEMANA_L = 4 THEN
        RETURN 'Jueves';
    ELSIF NUM_DIA_SEMANA_L = 5 THEN
        RETURN 'Viernes';
    ELSIF NUM_DIA_SEMANA_L = 6 THEN
        RETURN 'Sábado';
    ELSE
        RETURN NULL;
    END IF;
END;
$$;

COMMENT ON FUNCTION PARQUEADERO.OBTENER_DIA_FECHA_FU IS E'Función que devuelve el día de la semana con su respectivo nombre dada una fecha.';

ALTER FUNCTION PARQUEADERO.OBTENER_DIA_FECHA_FU OWNER TO PARKUD_DB_ADMIN;


-- Procedimiento que crea una tabla temporal para ingresar la clave primaria del usuario conectado.
CREATE OR REPLACE PROCEDURE PARQUEADERO.CREAR_TABLA_TEMP_USUARIO_PR()
LANGUAGE PLPGSQL
AS $$
BEGIN
    -- Crea la tabla temporal
    CREATE TEMPORARY TABLE PG_TEMP.PK_USUARIO(
        K_USUARIO_G INTEGER PRIMARY KEY
    );
END;
$$;

COMMENT ON PROCEDURE PARQUEADERO.CREAR_TABLA_TEMP_USUARIO_PR IS E'Procedimiento que crea una tabla temporal para ingresar la clave primaria del usuario conectado.';

ALTER PROCEDURE PARQUEADERO.CREAR_TABLA_TEMP_USUARIO_PR OWNER TO PARKUD_DB_ADMIN;


-- Procedimiento para insertar la llave primaria de un cliente conectado en la BD en la tabla temporal de llave primaria.
CREATE OR REPLACE PROCEDURE PARQUEADERO.INSERTAR_LLAVE_CLIENTE_PR(
    INOUT CODIGO_ERROR_P TEXT DEFAULT NULL,
    INOUT RESUMEN_ERROR_P TEXT DEFAULT NULL,
    INOUT MENSAJE_ERROR_P TEXT DEFAULT NULL
)
LANGUAGE PLPGSQL
AS $$
DECLARE
    -- Declaración de variables locales
    K_CLIENTE_L PARQUEADERO.CLIENTE.K_CLIENTE%TYPE;
BEGIN
    -- Recupera la clave primaria del cliente conectado a la BD
    SELECT K_CLIENTE INTO STRICT K_CLIENTE_L
    FROM PARQUEADERO.CLIENTE
    WHERE PARQUEADERO.PGP_SYM_DECRYPT(CORREO_CLIENTE, 'AES_KEY') = CURRENT_USER;

    -- Crea la tabla temporal del cliente
    CALL PARQUEADERO.CREAR_TABLA_TEMP_USUARIO_PR();

    -- Inserta la clave primaria en la tabla temporal del cliente
    INSERT INTO PG_TEMP.PK_USUARIO VALUES(K_CLIENTE_L);
EXCEPTION
    -- Excepciones
    WHEN NO_DATA_FOUND THEN
        RAISE EXCEPTION 'El usuario actual no tiene ningún rol en la aplicación.';
    WHEN TOO_MANY_ROWS THEN
        RAISE EXCEPTION 'Hay inconsistencias en la BD: hay un correo repetido.';
    WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS 
            CODIGO_ERROR_P = RETURNED_SQLSTATE,
            RESUMEN_ERROR_P = MESSAGE_TEXT,
            MENSAJE_ERROR_P = PG_EXCEPTION_CONTEXT;
END;
$$;

COMMENT ON PROCEDURE PARQUEADERO.INSERTAR_LLAVE_CLIENTE_PR IS E'Procedimiento para insertar la llave primaria de un cliente conectado en la BD en la tabla temporal de llave primaria.';

ALTER PROCEDURE PARQUEADERO.INSERTAR_LLAVE_CLIENTE_PR OWNER TO PARKUD_DB_ADMIN;


-- Procedimiento para insertar la llave primaria de un empleado conectado en la BD en la tabla temporal de llave primaria.
CREATE OR REPLACE PROCEDURE PARQUEADERO.INSERTAR_LLAVE_EMPLEADO_PR(
    INOUT CODIGO_ERROR_P TEXT DEFAULT NULL,
    INOUT RESUMEN_ERROR_P TEXT DEFAULT NULL,
    INOUT MENSAJE_ERROR_P TEXT DEFAULT NULL
)
LANGUAGE PLPGSQL
AS $$
DECLARE
    -- Declaración de variables locales
    K_EMPLEADO_L PARQUEADERO.EMPLEADO.K_EMPLEADO%TYPE;
BEGIN
    -- Recupera la clave primaria del empleado conectado a la BD
    SELECT K_EMPLEADO INTO STRICT K_EMPLEADO_L
    FROM PARQUEADERO.EMPLEADO
    WHERE PARQUEADERO.PGP_SYM_DECRYPT(CORREO_EMPLEADO, 'AES_KEY') = CURRENT_USER;

    -- Crea la tabla temporal del empleado
    CALL PARQUEADERO.CREAR_TABLA_TEMP_USUARIO_PR();

    -- Inserta la clave primaria en la tabla temporal del empleado
    INSERT INTO PG_TEMP.PK_USUARIO VALUES(K_EMPLEADO_L);
EXCEPTION
    -- Excepciones
    WHEN NO_DATA_FOUND THEN
        RAISE EXCEPTION 'El usuario actual no tiene ningún rol en la aplicación.';
    WHEN TOO_MANY_ROWS THEN
        RAISE EXCEPTION 'Hay inconsistencias en la BD: hay un correo repetido.';
    WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS 
            CODIGO_ERROR_P = RETURNED_SQLSTATE,
            RESUMEN_ERROR_P = MESSAGE_TEXT,
            MENSAJE_ERROR_P = PG_EXCEPTION_CONTEXT;
END;
$$;

COMMENT ON PROCEDURE PARQUEADERO.INSERTAR_LLAVE_EMPLEADO_PR IS E'Procedimiento para insertar la llave primaria de un empleado conectado en la BD en la tabla temporal de llave primaria.';

ALTER PROCEDURE PARQUEADERO.INSERTAR_LLAVE_EMPLEADO_PR OWNER TO PARKUD_DB_ADMIN;

CREATE OR REPLACE FUNCTION PARQUEADERO.RETORNAR_LLAVE_TEMPORAL_FU()
RETURNS INTEGER
LANGUAGE PLPGSQL
PARALLEL RESTRICTED
AS $$
DECLARE
    -- Declaración de variables locales
    K_USUARIO_L INTEGER;
    -- Códigos de error
    CODIGO_ERROR_L TEXT;
    RESUMEN_ERROR_L TEXT;
    MENSAJE_ERROR_L TEXT;
BEGIN
    -- Selecciona la clave primaria del usuario conectado
    SELECT K_USUARIO_G INTO STRICT K_USUARIO_L
    FROM PG_TEMP.PK_USUARIO;

    -- Retorna la clave primaria
    RETURN K_USUARIO_L;
EXCEPTION
    -- Excepciones
    WHEN NO_DATA_FOUND THEN
        RAISE EXCEPTION 'El usuario actual no tiene ningún rol en la aplicación.';
    WHEN TOO_MANY_ROWS THEN
        RAISE EXCEPTION 'Hay inconsistencias en la BD: hay un correo repetido.';
    WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS 
            CODIGO_ERROR_L = RETURNED_SQLSTATE,
            RESUMEN_ERROR_L = MESSAGE_TEXT,
            MENSAJE_ERROR_L = PG_EXCEPTION_CONTEXT;
        RETURN CONCAT(CODIGO_ERROR_L, ' ', RESUMEN_ERROR_L, ' ',MENSAJE_ERROR_L);
END;
$$;

COMMENT ON FUNCTION PARQUEADERO.RETORNAR_LLAVE_TEMPORAL_FU IS E'Función que retorna la clave primaria del usuario conectado a la BD.';

ALTER FUNCTION PARQUEADERO.RETORNAR_LLAVE_TEMPORAL_FU OWNER TO PARKUD_DB_ADMIN;