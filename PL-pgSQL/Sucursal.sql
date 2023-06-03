/* Funciones y procedimientos de registro, modificación y consulta de los registros de las sucursales.
Las sucursales pueden ser registradas por un gerente y modificadas por un gerente o un administrador.
La información registrada de las sucursales puede ser consultada por cualquier rol en la BD.*/

-- La aplicación muestra a los clientes toda la información de las sucursales como primera vista después de iniciar sesión.
-- La función retorna toda la información de una sucursal, con sus tarifas y el horario del día en que se consulta.
CREATE OR REPLACE FUNCTION PARQUEADERO.MOSTRAR_SUCURSALES_FU()
RETURNS JSON
LANGUAGE PLPGSQL
PARALLEL RESTRICTED
AS $$
DECLARE
    -- Declaración de variables locales
    RESULTADO_L JSON;
    DIA_ACTUAL_L VARCHAR;
    TIMESTAMP_LOCAL_T TIMESTAMP;
BEGIN
    -- Selecciona la hora local en Colombia
    SELECT CURRENT_TIMESTAMP AT TIME ZONE 'America/Bogota' INTO TIMESTAMP_LOCAL_T;

    -- Selecciona el día de la semana en que se consulta la función.
    SELECT PARQUEADERO.OBTENER_DIA_FECHA_FU((SELECT DATE(TIMESTAMP_LOCAL_T))) INTO DIA_ACTUAL_L;

    RAISE NOTICE 'DÍA EXTRAÍDO: %',DIA_ACTUAL_L;

    -- Inserta en un JSON el resultado de la consulta
    SELECT JSON_AGG(ROW_TO_JSON(T)) INTO RESULTADO_L 
    FROM(
        -- Consulta que devuelve la información de todas las sucursales
        SELECT S.TIPO_SUCURSAL AS "Tipo parqueadero",
            S.NOMBRE_SUCURSAL AS "Nombre parqueadero",
            C.NOMBRE_CIUDAD AS "Ciudad",
            D.NOMBRE_DIRECCION || ', ' || D.EDIFICIO_DIRECCION AS "Dirección",
            COUNT(DISTINCT SP.K_SLOT_PARQUEADERO) - COUNT(DISTINCT R.K_RESERVA) AS "Disponibilidad",
            CASE 
                WHEN HS.HORA_ABIERTO_SUCURSAL IS NULL AND HS.ES_HORARIO_COMPLETO THEN 'Horario 24 horas'
                WHEN HS.HORA_ABIERTO_SUCURSAL IS NULL AND HS.ES_CERRADO_COMPLETO THEN 'Sucursal cerrada'
                WHEN HS.HORA_ABIERTO_SUCURSAL IS NOT NULL THEN HS.HORA_ABIERTO_SUCURSAL::VARCHAR
            END AS "Hora abierto",
            CASE 
                WHEN HS.HORA_CERRADO_SUCURSAL IS NULL AND HS.ES_HORARIO_COMPLETO THEN 'Horario 24 horas'
                WHEN HS.HORA_CERRADO_SUCURSAL IS NULL AND HS.ES_CERRADO_COMPLETO THEN 'Sucursal cerrada'
                WHEN HS.HORA_CERRADO_SUCURSAL IS NOT NULL THEN HS.HORA_CERRADO_SUCURSAL::VARCHAR
            END AS "Hora cerrado",
            CASE
                WHEN TM.VALOR_MINUTO_SUV != 0 THEN TM.VALOR_MINUTO_SUV::VARCHAR
                WHEN TM.VALOR_MINUTO_SUV = 0 THEN 'No aplica'
            END AS "Tarifa SUV",
            CASE
                WHEN TM.VALOR_MINUTO_AUTO != 0 THEN TM.VALOR_MINUTO_AUTO::VARCHAR
                WHEN TM.VALOR_MINUTO_AUTO = 0 THEN 'No aplica'
            END AS "Tarifa automóvil",
            CASE
                WHEN TM.VALOR_MINUTO_MOTO != 0 THEN TM.VALOR_MINUTO_MOTO::VARCHAR
                WHEN TM.VALOR_MINUTO_MOTO = 0 THEN 'No aplica'
            END AS "Tarifa motocicleta",
            CASE
                WHEN TM.ADICION_PARQ_CUBIERTO != 0 THEN TM.ADICION_PARQ_CUBIERTO::VARCHAR
                WHEN TM.ADICION_PARQ_CUBIERTO = 0 THEN 'Sin incremento'
            END AS "Incremento parq. cubierto"
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
            AND DS.K_DIA_SEMANA = DIA_ACTUAL_L
        GROUP BY S.TIPO_SUCURSAL,
            S.NOMBRE_SUCURSAL,
            C.NOMBRE_CIUDAD,
            D.NOMBRE_DIRECCION || ', ' || D.EDIFICIO_DIRECCION,
            HS.HORA_ABIERTO_SUCURSAL,
            HS.HORA_CERRADO_SUCURSAL,
            HS.ES_HORARIO_COMPLETO,
            HS.ES_CERRADO_COMPLETO,
            TM.VALOR_MINUTO_SUV,
            TM.VALOR_MINUTO_AUTO,
            TM.VALOR_MINUTO_MOTO,
            TM.ADICION_PARQ_CUBIERTO
    ) T;
    
    -- Devuelve un JSON con la información de la consulta
    RETURN RESULTADO_L;
END;
$$;

COMMENT ON FUNCTION PARQUEADERO.MOSTRAR_SUCURSALES_FU IS E'Función que muestra la información básica de todas las sucursales.';

ALTER FUNCTION PARQUEADERO.MOSTRAR_SUCURSALES_FU OWNER TO PARKUD_DB_ADMIN;


-- Los administradores y gerentes deben poder modificar los parámetros de las sucursales.
-- El siguiente procedimiento permite modificar las tarifas una sucursal.
CREATE OR REPLACE PROCEDURE PARQUEADERO.MODIFICAR_TARIFA_SUCURSAL_PR(
    IN NOMBRE_SUCURSAL_P PARQUEADERO.SUCURSAL.NOMBRE_SUCURSAL%TYPE,
    IN CIUDAD_P PARQUEADERO.CIUDAD.NOMBRE_CIUDAD%TYPE,
    IN TIPO_SUCURSAL_P PARQUEADERO.SUCURSAL.TIPO_SUCURSAL%TYPE,
    IN DIRECCION_SUCURSAL_P PARQUEADERO.DIRECCION.NOMBRE_DIRECCION%TYPE,
    IN TIPO_TARIFA_P VARCHAR,
    IN VALOR_TARIFA_P NUMERIC(5,1)
)
LANGUAGE PLPGSQL
AS $$
DECLARE 
    -- Declaración de variables locales
    K_SUCURSAL_L PARQUEADERO.SUCURSAL.K_SUCURSAL%TYPE;
    TARIFA_SUV_L PARQUEADERO.TARIFA_MINUTO.VALOR_MINUTO_SUV%TYPE;
    TARIFA_AUTO_L PARQUEADERO.TARIFA_MINUTO.VALOR_MINUTO_AUTO%TYPE;
    TARIFA_MOTO_L PARQUEADERO.TARIFA_MINUTO.VALOR_MINUTO_MOTO%TYPE;
    INCREMENTO_PARQ_CUBIERTO_L PARQUEADERO.TARIFA_MINUTO.ADICION_PARQ_CUBIERTO%TYPE;
    -- Códigos de error
    CODIGO_ERROR_L TEXT;
    RESUMEN_ERROR_L TEXT;
    MENSAJE_ERROR_L TEXT;
BEGIN
    -- Selecciona la PK de la sucursal a modificar
    SELECT S.K_SUCURSAL INTO STRICT K_SUCURSAL_L
    FROM PARQUEADERO.PAIS P 
        INNER JOIN PARQUEADERO.DEPARTAMENTO DP ON P.K_PAIS = DP.K_PAIS
        INNER JOIN PARQUEADERO.CIUDAD C ON DP.K_DEPARTAMENTO = C.K_DEPARTAMENTO
        INNER JOIN PARQUEADERO.DIRECCION D ON C.K_CIUDAD = D.K_CIUDAD
        INNER JOIN PARQUEADERO.SUCURSAL S ON D.K_DIRECCION = S.K_DIRECCION    
    WHERE S.NOMBRE_SUCURSAL = NOMBRE_SUCURSAL_P
        AND S.TIPO_SUCURSAL = TIPO_SUCURSAL_P
        AND C.NOMBRE_CIUDAD = CIUDAD_P
        AND D.NOMBRE_DIRECCION = DIRECCION_SUCURSAL_P;

    -- Selecciona las tarifas actuales
    SELECT TM.VALOR_MINUTO_SUV,
        TM.VALOR_MINUTO_AUTO,
        TM.VALOR_MINUTO_MOTO,
        TM.ADICION_PARQ_CUBIERTO INTO STRICT TARIFA_SUV_L,
        TARIFA_AUTO_L,
        TARIFA_MOTO_L,
        INCREMENTO_PARQ_CUBIERTO_L
    FROM PARQUEADERO.SUCURSAL S
        INNER JOIN PARQUEADERO.TARIFA_MINUTO TM ON S.K_SUCURSAL = TM.K_SUCURSAL
    WHERE S.K_SUCURSAL = K_SUCURSAL_L
        AND TM.ESTA_ACTIVA = TRUE;
    
    -- Cambia la tarifa dependiendo del tipo de vehículo ingresado
    CASE TIPO_TARIFA_P
        -- Cuando la modificación es para la tarifa de SUV
        WHEN 'SUV' THEN
            INSERT INTO PARQUEADERO.TARIFA_MINUTO(
                K_SUCURSAL,
                VALOR_MINUTO_SUV,
                VALOR_MINUTO_AUTO,
                VALOR_MINUTO_MOTO,
                ADICION_PARQ_CUBIERTO,
                VALOR_MULTA_CANCELACION,
                FECHA_INICIO_TARIFA,
                ESTA_ACTIVA
            ) VALUES(
                K_SUCURSAL_L,
                VALOR_TARIFA_P,
                TARIFA_AUTO_L,
                TARIFA_MOTO_L,
                INCREMENTO_PARQ_CUBIERTO_L,
                0,
                (SELECT CURRENT_TIMESTAMP AT TIME ZONE 'America/Bogota'),
                TRUE
            );

        -- Cuando la modificación es para la tarifa de automóvil
        WHEN 'Automóvil'THEN
            INSERT INTO PARQUEADERO.TARIFA_MINUTO(
                K_SUCURSAL,
                VALOR_MINUTO_SUV,
                VALOR_MINUTO_AUTO,
                VALOR_MINUTO_MOTO,
                ADICION_PARQ_CUBIERTO,
                VALOR_MULTA_CANCELACION,
                FECHA_INICIO_TARIFA,
                ESTA_ACTIVA
            ) VALUES(
                K_SUCURSAL_L,
                TARIFA_SUV_L,
                VALOR_TARIFA_P,
                TARIFA_MOTO_L,
                INCREMENTO_PARQ_CUBIERTO_L,
                0,
                (SELECT CURRENT_TIMESTAMP AT TIME ZONE 'America/Bogota'),
                TRUE
            );

        -- Cuando la modificación es para la tarifa de moto
        WHEN 'Moto'THEN
            INSERT INTO PARQUEADERO.TARIFA_MINUTO(
                K_SUCURSAL,
                VALOR_MINUTO_SUV,
                VALOR_MINUTO_AUTO,
                VALOR_MINUTO_MOTO,
                ADICION_PARQ_CUBIERTO,
                VALOR_MULTA_CANCELACION,
                FECHA_INICIO_TARIFA,
                ESTA_ACTIVA
            ) VALUES(
                K_SUCURSAL_L,
                TARIFA_SUV_L,
                TARIFA_AUTO_L,
                VALOR_TARIFA_P,
                INCREMENTO_PARQ_CUBIERTO_L,
                0,
                (SELECT CURRENT_TIMESTAMP AT TIME ZONE 'America/Bogota'),
                TRUE
            );
    END CASE;    
EXCEPTION 
    -- Excepciones
    WHEN NO_DATA_FOUND THEN
        RAISE EXCEPTION 'Error al recuperar la clave primaria de la sucursal.';
    WHEN TOO_MANY_ROWS THEN
        RAISE EXCEPTION 'Hay más de una sucursal registrada con esa dirección y ciudad.';
    WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS 
            CODIGO_ERROR_L := RETURNED_SQLSTATE,
            RESUMEN_ERROR_L := MESSAGE_TEXT,
            MENSAJE_ERROR_L := PG_EXCEPTION_CONTEXT;
        RAISE EXCEPTION 'Código de error: % / Resumen del error: % / Mensaje de error: %', CODIGO_ERROR_L, RESUMEN_ERROR_L, MENSAJE_ERROR_L;
END;
$$;

COMMENT ON PROCEDURE PARQUEADERO.MODIFICAR_TARIFA_SUCURSAL_PR IS E'Procedimiento para modificar las tarifas de una sucursal.';

ALTER PROCEDURE PARQUEADERO.MODIFICAR_TARIFA_SUCURSAL_PR OWNER TO PARKUD_DB_ADMIN;

-- Los administradores y gerentes deben poder modificar los parámetros de las sucursales.
-- El siguiente procedimiento permite modificar los horarios de una sucursal.
CREATE OR REPLACE PROCEDURE PARQUEADERO.MODIFICAR_HORARIO_SUCURSAL_PR(
    IN NOMBRE_SUCURSAL_P PARQUEADERO.SUCURSAL.NOMBRE_SUCURSAL%TYPE,
    IN CIUDAD_P PARQUEADERO.CIUDAD.NOMBRE_CIUDAD%TYPE,
    IN TIPO_SUCURSAL_P PARQUEADERO.SUCURSAL.TIPO_SUCURSAL%TYPE,
    IN DIRECCION_SUCURSAL_P PARQUEADERO.DIRECCION.NOMBRE_DIRECCION%TYPE,
    IN DIA_SEMANA_P PARQUEADERO.DIA_SEMANA.K_DIA_SEMANA%TYPE,
    IN HORA_ABIERTO_P PARQUEADERO.HORARIO_SUCURSAL.HORA_ABIERTO_SUCURSAL%TYPE,
    IN HORA_CERRADO_P PARQUEADERO.HORARIO_SUCURSAL.HORA_CERRADO_SUCURSAL%TYPE,
    IN ES_HORARIO_COMPLETO_P PARQUEADERO.HORARIO_SUCURSAL.ES_HORARIO_COMPLETO%TYPE,
    IN ES_CERRADO_COMPLETO_P PARQUEADERO.HORARIO_SUCURSAL.ES_CERRADO_COMPLETO%TYPE
)
LANGUAGE PLPGSQL
AS $$
DECLARE 
    -- Declaración de variables locales
    K_SUCURSAL_L PARQUEADERO.SUCURSAL.K_SUCURSAL%TYPE;
    -- Códigos de error
    CODIGO_ERROR_L TEXT;
    RESUMEN_ERROR_L TEXT;
    MENSAJE_ERROR_L TEXT;
BEGIN
    -- Selecciona la PK de la sucursal a modificar
    SELECT S.K_SUCURSAL INTO STRICT K_SUCURSAL_L
    FROM PARQUEADERO.PAIS P 
        INNER JOIN PARQUEADERO.DEPARTAMENTO DP ON P.K_PAIS = DP.K_PAIS
        INNER JOIN PARQUEADERO.CIUDAD C ON DP.K_DEPARTAMENTO = C.K_DEPARTAMENTO
        INNER JOIN PARQUEADERO.DIRECCION D ON C.K_CIUDAD = D.K_CIUDAD
        INNER JOIN PARQUEADERO.SUCURSAL S ON D.K_DIRECCION = S.K_DIRECCION    
    WHERE S.NOMBRE_SUCURSAL = NOMBRE_SUCURSAL_P
        AND S.TIPO_SUCURSAL = TIPO_SUCURSAL_P
        AND C.NOMBRE_CIUDAD = CIUDAD_P
        AND D.NOMBRE_DIRECCION = DIRECCION_SUCURSAL_P;

    -- Actualiza los nuevos valores de apertura y cerrado
    UPDATE PARQUEADERO.HORARIO_SUCURSAL 
    SET HORA_ABIERTO_SUCURSAL = HORA_ABIERTO_P,
        HORA_CERRADO_SUCURSAL = HORA_CERRADO_P,
        ES_HORARIO_COMPLETO = ES_HORARIO_COMPLETO_P,
        ES_CERRADO_COMPLETO = ES_CERRADO_COMPLETO_P
    WHERE K_SUCURSAL = K_SUCURSAL_L
        AND K_DIA_SEMANA = DIA_SEMANA_P;

    RAISE NOTICE 'HICE UN UPDATE';
    
EXCEPTION 
    -- Excepciones
    WHEN NO_DATA_FOUND THEN
        RAISE EXCEPTION 'Error al recuperar la clave primaria de la sucursal.';
    WHEN TOO_MANY_ROWS THEN
        RAISE EXCEPTION 'Hay más de una sucursal registrada con esa dirección y ciudad.';
    WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS 
            CODIGO_ERROR_L := RETURNED_SQLSTATE,
            RESUMEN_ERROR_L := MESSAGE_TEXT,
            MENSAJE_ERROR_L := PG_EXCEPTION_CONTEXT;
        RAISE EXCEPTION 'Código de error: % / Resumen del error: % / Mensaje de error: %', CODIGO_ERROR_L, RESUMEN_ERROR_L, MENSAJE_ERROR_L;
END;
$$;

COMMENT ON PROCEDURE PARQUEADERO.MODIFICAR_HORARIO_SUCURSAL_PR IS E'Procedimiento para modificar el horario de una sucursal.';

ALTER PROCEDURE PARQUEADERO.MODIFICAR_HORARIO_SUCURSAL_PR OWNER TO PARKUD_DB_ADMIN;