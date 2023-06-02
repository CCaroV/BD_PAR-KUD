/* Funciones y procedimientos para hacer una reserva.
La reserva se hace en cinco pasos de forma secuencial.
Los procedimientos y funciones requeridos se muestran en ese orden.*/

-- 1. El cliente selecciona el tipo de vehículo. La función retorna los vehículos del cliente registrados de ese tipo.
CREATE OR REPLACE FUNCTION PARQUEADERO.MOSTRAR_VEHICULOS_RESERVA_FU(
    IN TIPO_VEHICULO_P PARQUEADERO.VEHICULO.TIPO_VEHICULO%TYPE
)
RETURNS JSON
LANGUAGE PLPGSQL
PARALLEL RESTRICTED
AS $$
DECLARE
    -- Declaración de variables locales
    RESULTADO_L JSON;
    K_CLIENTE_L PARQUEADERO.CLIENTE.K_CLIENTE%TYPE;
    -- Códigos de error
    CODIGO_ERROR_L TEXT;
    RESUMEN_ERROR_L TEXT;
    MENSAJE_ERROR_L TEXT;
BEGIN
    -- Recupera la clave primaria del cliente conectado a la BD
    K_CLIENTE_L := PARQUEADERO.RECUPERAR_LLAVE_CLIENTE_FU();

    -- Inserta en un JSON el resultado de la consukta
    SELECT JSON_AGG(ROW_TO_JSON(T)) INTO RESULTADO_L 
    -- Consulta que devuelve los vehículos de un cliente filtrado por el tipo de vehículo
    FROM(
        SELECT K_MARCA_VEHICULO ||' - '|| PLACA_VEHICULO "Vehículo"
        FROM PARQUEADERO.CLIENTE C
            INNER JOIN PARQUEADERO.VEHICULO V ON C.K_CLIENTE = V.K_CLIENTE
        WHERE V.TIPO_VEHICULO = TIPO_VEHICULO_P 
            AND C.K_CLIENTE = K_CLIENTE_L
    ) T;

    -- Devuelve el JSON con la información de la consulta
    RETURN RESULTADO_L;
EXCEPTION
    -- Excepciones
    WHEN UNDEFINED_TABLE THEN
        RAISE EXCEPTION 'Error en la recuperación de la PK del usuario.';
    WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS 
            CODIGO_ERROR_L := RETURNED_SQLSTATE,
            RESUMEN_ERROR_L := MESSAGE_TEXT,
            MENSAJE_ERROR_L := PG_EXCEPTION_CONTEXT;
        RETURN (SELECT CONCAT(CODIGO_ERROR_L, ' ', RESUMEN_ERROR_L, ' ',MENSAJE_ERROR_L) AS JSON);
END;
$$;

COMMENT ON FUNCTION PARQUEADERO.MOSTRAR_VEHICULOS_RESERVA_FU IS E'Función que devuelve los vehículos de un cliente según el tipo de vehículo.';

ALTER FUNCTION PARQUEADERO.MOSTRAR_VEHICULOS_RESERVA_FU OWNER TO PARKUD_DB_ADMIN;

-- 2. El cliente escoge la ciudad y sucursal en la que desea reservar. También escoge si el parqueadero debe o no ser cubierto.
-- La función retorna la ciudad y sucursal que que se corresponda con esos valores, verificando que haya disponibilidad.
CREATE OR REPLACE FUNCTION PARQUEADERO.MOSTRAR_INFO_BASICA_SUCURSAL_FU(
    IN TIPO_VEHICULO_P PARQUEADERO.VEHICULO.TIPO_VEHICULO%TYPE,
    IN CIUDAD_P PARQUEADERO.CIUDAD.NOMBRE_CIUDAD%TYPE DEFAULT NULL,
    IN ES_PARQ_CUBIERTO_P PARQUEADERO.SLOT_PARQUEADERO.ES_CUBIERTO%TYPE DEFAULT NULL,
    IN NOMBRE_SUCURSAL_P PARQUEADERO.SUCURSAL.NOMBRE_SUCURSAL%TYPE DEFAULT NULL
)
RETURNS JSON
LANGUAGE PLPGSQL
PARALLEL RESTRICTED
AS $$
DECLARE
    -- Declaración de variables locales
    RESULTADO_L JSON;
BEGIN
    -- Inserta en un JSON el resultado de la consukta
    SELECT JSON_AGG(ROW_TO_JSON(T)) INTO RESULTADO_L 
    FROM(
        -- Consulta que devuelve la información de la sucursal dados los parámetros
        SELECT DISTINCT C.NOMBRE_CIUDAD "Ciudad",
            S.TIPO_SUCURSAL "Tipo sucursal",
            S.NOMBRE_SUCURSAL "Nombre sucursal"
        FROM PARQUEADERO.PAIS P 
            INNER JOIN PARQUEADERO.DEPARTAMENTO DP ON P.K_PAIS = DP.K_PAIS
            INNER JOIN PARQUEADERO.CIUDAD C ON DP.K_DEPARTAMENTO = C.K_DEPARTAMENTO
            INNER JOIN PARQUEADERO.DIRECCION D ON C.K_CIUDAD = D.K_CIUDAD
            INNER JOIN PARQUEADERO.SUCURSAL S ON D.K_DIRECCION = S.K_DIRECCION
            INNER JOIN PARQUEADERO.TARIFA_MINUTO TM ON S.K_SUCURSAL = TM.K_SUCURSAL
            INNER JOIN PARQUEADERO.SLOT_PARQUEADERO SP ON S.K_SUCURSAL = SP.K_SUCURSAL
            INNER JOIN PARQUEADERO.HORARIO_SUCURSAL HS ON S.K_SUCURSAL = HS.K_SUCURSAL
            INNER JOIN PARQUEADERO.DIA_SEMANA DS ON HS.K_DIA_SEMANA = DS.K_DIA_SEMANA
            LEFT JOIN (
                SELECT K_SLOT_PARQUEADERO,
                    K_SUCURSAL,
                    K_RESERVA
                FROM PARQUEADERO.RESERVA
                WHERE ESTA_ACTIVA = TRUE
            ) R ON SP.K_SLOT_PARQUEADERO = R.K_SLOT_PARQUEADERO
            AND SP.K_SUCURSAL = R.K_SUCURSAL
            AND S.K_SUCURSAL = R.K_SUCURSAL
        WHERE TM.ESTA_ACTIVA = TRUE
            AND SP.TIPO_PARQUEADERO = TIPO_VEHICULO_P
            AND (CIUDAD_P IS NULL OR C.NOMBRE_CIUDAD = CIUDAD_P)
            AND (ES_PARQ_CUBIERTO_P IS NULL OR SP.ES_CUBIERTO = ES_PARQ_CUBIERTO_P)
            AND (NOMBRE_SUCURSAL_P IS NULL OR S.NOMBRE_SUCURSAL = NOMBRE_SUCURSAL_P)
        GROUP BY "Ciudad",
            "Tipo sucursal",
            "Nombre sucursal"
        HAVING (COUNT(DISTINCT SP.K_SLOT_PARQUEADERO) - COUNT(DISTINCT R.K_RESERVA)) > 0
    ) T;

    -- Devuelve el JSON con la información de la consulta
    RETURN RESULTADO_L;
END;
$$;

COMMENT ON FUNCTION PARQUEADERO.MOSTRAR_INFO_BASICA_SUCURSAL_FU IS E'Función que retorna información básica de sucursales dado unos parámetros de entrada.';

ALTER FUNCTION PARQUEADERO.MOSTRAR_INFO_BASICA_SUCURSAL_FU OWNER TO PARKUD_DB_ADMIN ;

-- 3. El usuario selecciona la sucursal en la que desea reservar, la función recibe estos parámetros.
-- La función vuelve a verificar que la sucursal escogida tenga cupos disponibles.
-- La función devuelve mayor información de la sucursal como su dirección y tarifa con recargos incluidos,
-- esto con el fin de que el cliente esté seguro de escoger la sucursal correcta para su reserva.
CREATE OR REPLACE FUNCTION PARQUEADERO.MOSTRAR_INFO_SUCURSAL_RESERVA_FU(
    IN CIUDAD_P PARQUEADERO.CIUDAD.NOMBRE_CIUDAD%TYPE,
    IN ES_PARQ_CUBIERTO_P PARQUEADERO.SLOT_PARQUEADERO.ES_CUBIERTO%TYPE,
    IN TIPO_PARQUEADERO_P PARQUEADERO.SLOT_PARQUEADERO.TIPO_PARQUEADERO%TYPE,
    IN NOMBRE_SUCURSAL_P PARQUEADERO.SUCURSAL.NOMBRE_SUCURSAL%TYPE
)
RETURNS JSON
LANGUAGE PLPGSQL
PARALLEL RESTRICTED
AS $$
DECLARE
    -- Declaración de variables locales
    RESULTADO_L JSON;
BEGIN
    -- Inserta en un JSON el resultado de la consukta
    SELECT JSON_AGG(ROW_TO_JSON(T)) INTO RESULTADO_L 
    FROM(
        -- Consulta que devuelve la información de la sucursal dados los parámetros
        SELECT DISTINCT C.NOMBRE_CIUDAD "Ciudad",
            S.NOMBRE_SUCURSAL "Nombre sucursal",
            D.NOMBRE_DIRECCION "Dirección",
            CASE 
                WHEN TIPO_PARQUEADERO_P = 'SUV' THEN (TM.VALOR_MINUTO_SUV + TM.ADICION_PARQ_CUBIERTO)
                WHEN TIPO_PARQUEADERO_P = 'Automóvil' THEN (TM.VALOR_MINUTO_AUTO + TM.ADICION_PARQ_CUBIERTO)
                WHEN TIPO_PARQUEADERO_P = 'Moto' THEN (TM.VALOR_MINUTO_MOTO + TM.ADICION_PARQ_CUBIERTO)
            END AS "Tarifa minuto"
        FROM PARQUEADERO.PAIS P 
            INNER JOIN PARQUEADERO.DEPARTAMENTO DP ON P.K_PAIS = DP.K_PAIS
            INNER JOIN PARQUEADERO.CIUDAD C ON DP.K_DEPARTAMENTO = C.K_DEPARTAMENTO
            INNER JOIN PARQUEADERO.DIRECCION D ON C.K_CIUDAD = D.K_CIUDAD
            INNER JOIN PARQUEADERO.SUCURSAL S ON D.K_DIRECCION = S.K_DIRECCION
            INNER JOIN PARQUEADERO.TARIFA_MINUTO TM ON S.K_SUCURSAL = TM.K_SUCURSAL
            INNER JOIN PARQUEADERO.SLOT_PARQUEADERO SP ON S.K_SUCURSAL = SP.K_SUCURSAL
            INNER JOIN PARQUEADERO.HORARIO_SUCURSAL HS ON S.K_SUCURSAL = HS.K_SUCURSAL
            INNER JOIN PARQUEADERO.DIA_SEMANA DS ON HS.K_DIA_SEMANA = DS.K_DIA_SEMANA
            LEFT JOIN (
                SELECT K_SLOT_PARQUEADERO,
                    K_SUCURSAL,
                    K_RESERVA
                FROM PARQUEADERO.RESERVA
                WHERE ESTA_ACTIVA = TRUE
            ) R ON SP.K_SLOT_PARQUEADERO = R.K_SLOT_PARQUEADERO
            AND SP.K_SUCURSAL = R.K_SUCURSAL
            AND S.K_SUCURSAL = R.K_SUCURSAL
        WHERE TM.ESTA_ACTIVA = TRUE
            AND SP.TIPO_PARQUEADERO = TIPO_PARQUEADERO_P
            AND C.NOMBRE_CIUDAD = CIUDAD_P
            AND SP.ES_CUBIERTO = ES_PARQ_CUBIERTO_P
            AND S.NOMBRE_SUCURSAL = NOMBRE_SUCURSAL_P
        GROUP BY "Ciudad",
            "Nombre sucursal",
            "Dirección",
            "Tarifa minuto"
        HAVING (COUNT(DISTINCT SP.K_SLOT_PARQUEADERO) - COUNT(DISTINCT R.K_RESERVA)) > 0
    ) T;

    -- Devuelve un JSON con la información de la consulta
    RETURN RESULTADO_L;
END;
$$;

COMMENT ON FUNCTION PARQUEADERO.MOSTRAR_INFO_SUCURSAL_RESERVA_FU IS E'Función que muestra la información de la sucursal en el último paso de reserva en la aplicación.';

ALTER FUNCTION PARQUEADERO.MOSTRAR_INFO_SUCURSAL_RESERVA_FU OWNER TO PARKUD_DB_ADMIN;

-- 4. Una vez seleccionada la sucursal, el cliente debe seleccionar un método de pago. 
-- La función devuelve la información básica de sus métodos de pago registrados.
CREATE OR REPLACE FUNCTION PARQUEADERO.MOSTRAR_METODOS_PAGO_FU()
RETURNS JSON
LANGUAGE PLPGSQL
PARALLEL RESTRICTED
AS $$
DECLARE 
    -- Declaración de variables locales
    RESULTADO_L JSON;
    K_CLIENTE_L PARQUEADERO.CLIENTE.K_CLIENTE%TYPE;
    -- Códigos de error
    CODIGO_ERROR_L TEXT;
    RESUMEN_ERROR_L TEXT;
    MENSAJE_ERROR_L TEXT;
BEGIN
    -- Recupera la clave primaria del cliente conectado a la BD
    K_CLIENTE_L := PARQUEADERO.RECUPERAR_LLAVE_CLIENTE_FU();

    -- Inserta en un JSON el resultado de la consukta
    SELECT JSON_AGG(ROW_TO_JSON(T)) INTO RESULTADO_L 
    -- Consulta que devuelve la información de pago del cliente
    FROM(
        SELECT PARQUEADERO.PGP_SYM_DECRYPT(T.TIPO_TARJETA, 'AES_KEY')  "Tipo tarjeta",
            PARQUEADERO.PGP_SYM_DECRYPT(T.ULTIMOS_CUATRO_DIGITOS, 'AES_KEY') "Últimos 4 dígitos",
            PARQUEADERO.PGP_SYM_DECRYPT(T.NOMBRE_DUENIO_TARJETA, 'AES_KEY') "Nombre",
            PARQUEADERO.PGP_SYM_DECRYPT(T.APELLIDO_DUENIO_TARJETA, 'AES_KEY') "Apellido"
        FROM PARQUEADERO.CLIENTE C
            INNER JOIN PARQUEADERO.TARJETA_PAGO T ON C.K_CLIENTE = T.K_CLIENTE
        WHERE C.K_CLIENTE = K_CLIENTE_L
    ) T;

    -- Devuelve un JSON con la información de la consulta
    RETURN RESULTADO_L;
EXCEPTION
    -- Excepciones
    WHEN UNDEFINED_TABLE THEN
        RAISE EXCEPTION 'Error en la recuperación de la PK del usuario.';
    WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS 
            CODIGO_ERROR_L = RETURNED_SQLSTATE,
            RESUMEN_ERROR_L = MESSAGE_TEXT,
            MENSAJE_ERROR_L = PG_EXCEPTION_CONTEXT;
        RETURN CONCAT(CODIGO_ERROR_L, ' ', RESUMEN_ERROR_L, ' ',MENSAJE_ERROR_L);
END;
$$;

COMMENT ON FUNCTION PARQUEADERO.MOSTRAR_METODOS_PAGO_FU IS E'Función que retorna la información de los métodos de pago de un cliente para pagar una reserva.';

ALTER FUNCTION PARQUEADERO.MOSTRAR_METODOS_PAGO_FU OWNER TO PARKUD_DB_ADMIN;

-- 5. Una vez seleccionada el vehículo, sucursal y método de pago, se hace la reserva en la BD.
CREATE OR REPLACE PROCEDURE PARQUEADERO.CREAR_RESERVA_PR(
    IN TIPO_VEHICULO_P PARQUEADERO.VEHICULO.TIPO_VEHICULO%TYPE,
    IN MARCA_PLACA_VEHICULO_P VARCHAR,
    IN ES_PARQ_CUBIERTO_P PARQUEADERO.SLOT_PARQUEADERO.ES_CUBIERTO%TYPE,
    IN CIUDAD_P PARQUEADERO.CIUDAD.NOMBRE_CIUDAD%TYPE,
    IN NOMBRE_SUCURSAL_P PARQUEADERO.SUCURSAL.NOMBRE_SUCURSAL%TYPE,
    IN DIRECCION_SUCURSAL_P PARQUEADERO.DIRECCION.NOMBRE_DIRECCION%TYPE,
    IN FECHA_RESERVA_P DATE,
    IN HORA_RESERVA_P TIME,
    IN ULTIMOS_CUATRO_DIGITOS_P VARCHAR(4),
    IN TIPO_TARJETA_P VARCHAR,
    IN NOMBRE_DUENIO_TARJETA_P VARCHAR,
    IN APELLIDO_DUENIO_TARJETA_P VARCHAR,
    IN PUNTOS_USADOS_P PARQUEADERO.RESERVA.PUNTOS_USADOS%TYPE DEFAULT 0,
    INOUT CODIGO_ERROR_P TEXT DEFAULT NULL,
    INOUT RESUMEN_ERROR_P TEXT DEFAULT NULL,
    INOUT MENSAJE_ERROR_P TEXT DEFAULT NULL
)
LANGUAGE PLPGSQL
AS $$
DECLARE
    -- Declaración de variables locales
    PLACA_VEHICULO_L PARQUEADERO.VEHICULO.PLACA_VEHICULO%TYPE;
    K_CLIENTE_L PARQUEADERO.CLIENTE.K_CLIENTE%TYPE;
    K_SUCURSAL_L PARQUEADERO.SUCURSAL.K_SUCURSAL%TYPE;
    K_SLOT_PARQUEADERO_L PARQUEADERO.SLOT_PARQUEADERO.K_SLOT_PARQUEADERO%TYPE;
    K_TARJETA_PAGO_L PARQUEADERO.TARJETA_PAGO.K_TARJETA_PAGO%TYPE;
    K_FIDELIZACION_L PARQUEADERO.FIDELIZACION_CLIENTE.K_FIDELIZACION%TYPE := NULL;
    DIA_RESERVA_L PARQUEADERO.DIA_SEMANA.K_DIA_SEMANA%TYPE;
    FECHA_INICIO_RESERVA_L PARQUEADERO.RESERVA.FECHA_RESERVA%TYPE := FECHA_RESERVA_P + HORA_RESERVA_P;
    K_RESERVA_L PARQUEADERO.RESERVA.K_RESERVA%TYPE;
BEGIN
    -- Selecciona la clave primaria del cliente conectado a la BD
    K_CLIENTE_L := PARQUEADERO.RECUPERAR_LLAVE_CLIENTE_FU();

    -- Selecciona el día de la semana en que se hará la reserva
    SELECT PARQUEADERO.OBTENER_DIA_FECHA_FU(FECHA_RESERVA_P) INTO DIA_RESERVA_L;

    -- Selecciona la placa del vehículo
    SELECT TRIM(REGEXP_REPLACE(MARCA_PLACA_VEHICULO_P, '^.* ', '')) INTO PLACA_VEHICULO_L;
    
    -- Selecciona la PK de la sucursal y el slot de parqueadero a utilizar.
    SELECT S.K_SUCURSAL,
        SP.K_SLOT_PARQUEADERO INTO K_SUCURSAL_L,
        K_SLOT_PARQUEADERO_L
    FROM PARQUEADERO.PAIS P
        INNER JOIN PARQUEADERO.DEPARTAMENTO DP ON P.K_PAIS = DP.K_PAIS
        INNER JOIN PARQUEADERO.CIUDAD C ON DP.K_DEPARTAMENTO = C.K_DEPARTAMENTO
        INNER JOIN PARQUEADERO.DIRECCION D ON C.K_CIUDAD = D.K_CIUDAD
        INNER JOIN PARQUEADERO.SUCURSAL S ON D.K_DIRECCION = S.K_DIRECCION
        INNER JOIN PARQUEADERO.TARIFA_MINUTO TM ON S.K_SUCURSAL = TM.K_SUCURSAL
        INNER JOIN PARQUEADERO.SLOT_PARQUEADERO SP ON S.K_SUCURSAL = SP.K_SUCURSAL
        INNER JOIN PARQUEADERO.HORARIO_SUCURSAL HS ON S.K_SUCURSAL = HS.K_SUCURSAL
        INNER JOIN PARQUEADERO.DIA_SEMANA DS ON HS.K_DIA_SEMANA = DS.K_DIA_SEMANA
        LEFT JOIN (
            SELECT K_SLOT_PARQUEADERO,
                K_SUCURSAL,
                K_RESERVA
            FROM PARQUEADERO.RESERVA
            WHERE ESTA_ACTIVA = TRUE
        ) R ON SP.K_SLOT_PARQUEADERO = R.K_SLOT_PARQUEADERO
        AND SP.K_SUCURSAL = R.K_SUCURSAL
        AND S.K_SUCURSAL = R.K_SUCURSAL
    WHERE TM.ESTA_ACTIVA = TRUE
        AND C.NOMBRE_CIUDAD = CIUDAD_P
        AND D.NOMBRE_DIRECCION = DIRECCION_SUCURSAL_P
        AND S.NOMBRE_SUCURSAL = NOMBRE_SUCURSAL_P
        AND SP.TIPO_PARQUEADERO = TIPO_VEHICULO_P
        AND DS.K_DIA_SEMANA = DIA_RESERVA_L
        AND (NOT HS.ES_CERRADO_COMPLETO OR HS.ES_HORARIO_COMPLETO)
        AND (HS.HORA_ABIERTO_SUCURSAL IS NULL OR HS.HORA_ABIERTO_SUCURSAL < HORA_RESERVA_P)
        AND (HS.HORA_CERRADO_SUCURSAL IS NULL OR HS.HORA_CERRADO_SUCURSAL > HORA_RESERVA_P)
    GROUP BY S.K_SUCURSAL,
        SP.K_SLOT_PARQUEADERO
    HAVING (COUNT(DISTINCT SP.K_SLOT_PARQUEADERO) - COUNT(DISTINCT R.K_RESERVA)) > 0
    ORDER BY SP.K_SLOT_PARQUEADERO
    LIMIT 1;
    
    -- Selecciona la PK de la tarjeta que va a usar para pagar
    SELECT T.K_TARJETA_PAGO INTO STRICT K_TARJETA_PAGO_L
    FROM PARQUEADERO.CLIENTE C 
        INNER JOIN PARQUEADERO.TARJETA_PAGO T ON C.K_CLIENTE = T.K_CLIENTE
    WHERE C.K_CLIENTE = K_CLIENTE_L
        AND PARQUEADERO.PGP_SYM_DECRYPT(T.NOMBRE_DUENIO_TARJETA, 'AES_KEY') = NOMBRE_DUENIO_TARJETA_P
        AND PARQUEADERO.PGP_SYM_DECRYPT(T.APELLIDO_DUENIO_TARJETA, 'AES_KEY') = APELLIDO_DUENIO_TARJETA_P
        AND PARQUEADERO.PGP_SYM_DECRYPT(T.ULTIMOS_CUATRO_DIGITOS, 'AES_KEY') = ULTIMOS_CUATRO_DIGITOS_P
        AND PARQUEADERO.PGP_SYM_DECRYPT(T.TIPO_TARJETA, 'AES_KEY') = TIPO_TARJETA_P;
    
    -- Si hay puntos usados recupera la PK de fidelización del cliente
    IF PUNTOS_USADOS_P IS NOT NULL AND PUNTOS_USADOS_P > 0 THEN
        SELECT F.K_FIDELIZACION INTO STRICT K_FIDELIZACION_L
        FROM PARQUEADERO.CLIENTE C
            INNER JOIN PARQUEADERO.FIDELIZACION_CLIENTE F ON C.K_CLIENTE = F.K_CLIENTE
        WHERE F.K_CLIENTE = K_CLIENTE_L
            AND F.FECHA_FIN_PUNTAJE IS NULL
            AND F.ES_ACTUAL = TRUE;
    END IF;

    -- Inserta los valores de la reserva
    INSERT INTO PARQUEADERO.RESERVA (
        K_CLIENTE,
        K_PROMOCION,
        K_FIDELIZACION,
        K_SUCURSAL,
        K_SLOT_PARQUEADERO,
        K_TARJETA_PAGO,
        FECHA_RESERVA,
        FECHA_INICIO_RESERVA,
        PUNTOS_USADOS,
        ESTA_ACTIVA,
        PLACA_VEHICULO
    ) VALUES (
        K_CLIENTE_L,
        NULL,
        K_FIDELIZACION_L,
        K_SUCURSAL_L,
        K_SLOT_PARQUEADERO_L,
        K_TARJETA_PAGO_L,
        (SELECT CURRENT_TIMESTAMP AT TIME ZONE 'America/Bogota'),
        FECHA_INICIO_RESERVA_L,
        PUNTOS_USADOS_P,
        TRUE,
        PLACA_VEHICULO_L
    );
EXCEPTION
    -- Excepciones
    WHEN NO_DATA_FOUND THEN
        ROLLBACK;
        RAISE EXCEPTION 'Método de pago no encontrado.';
    WHEN TOO_MANY_ROWS THEN
        ROLLBACK;
        RAISE EXCEPTION 'Se encontró más de un método de pago para la información ingresada.';
    WHEN OTHERS THEN
        ROLLBACK;
        GET STACKED DIAGNOSTICS 
            CODIGO_ERROR_P := RETURNED_SQLSTATE,
            RESUMEN_ERROR_P := MESSAGE_TEXT,
            MENSAJE_ERROR_P := PG_EXCEPTION_CONTEXT;
END;
$$;

COMMENT ON PROCEDURE PARQUEADERO.CREAR_RESERVA_PR IS E'Procedimiento para hacer una reserva.';

ALTER PROCEDURE PARQUEADERO.CREAR_RESERVA_PR OWNER TO PARKUD_DB_ADMIN;