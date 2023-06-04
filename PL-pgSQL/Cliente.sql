/* Funciones y procedimientos para mostrar, modificar o eliminar los registros de vehículos y métodos de pago de un cliente.
Los clientes registrados deben poder ver la información que tienen registrada en la aplicación y modificarla o eliminarla.*/

-- El cliente puede tener varios vehículos registrados en la BD.
-- La función devuelve todos los vehículos registrados del cliente.
CREATE OR REPLACE FUNCTION PARQUEADERO.MOSTRAR_VEHICULOS_CLIENTE_FU()
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
    -- Habilita la concurrencia de las tablas pero solo permite que puedan ser proyectadas
    LOCK TABLE PARQUEADERO.MARCA_VEHICULO IN ACCESS SHARE MODE;

    -- Habilita la concurrencia de las tablas mientras que no exista ninguna modificación en curso
    LOCK TABLE PARQUEADERO.CLIENTE IN SHARE UPDATE EXCLUSIVE MODE;
    LOCK TABLE PARQUEADERO.VEHICULO IN SHARE UPDATE EXCLUSIVE MODE;

    -- Recupera la clave primaria del cliente conectado a la BD
    K_CLIENTE_L := PARQUEADERO.RECUPERAR_LLAVE_CLIENTE_FU();

    -- Inserta en un JSON el resultado de la consulta
    SELECT JSON_AGG(ROW_TO_JSON(T)) INTO RESULTADO_L 
    FROM(
        -- Consulta que devuelve la información de todas las sucursales
        SELECT V.PLACA_VEHICULO "Placa",
            V.NOMBRE1_PROPIETARIO || ' ' || COALESCE(V.NOMBRE2_PROPIETARIO, '') || ' ' || V.APELLIDO1_PROPIETARIO || ' ' || COALESCE(V.APELLIDO2_PROPIETARIO, '') "Nombre propietario",
            V.TIPO_VEHICULO "Tipo vehículo",
            V.COLOR_VEHICULO "Color",
            V.K_MARCA_VEHICULO "Marca"
        FROM PARQUEADERO.CLIENTE C
            INNER JOIN PARQUEADERO.VEHICULO V ON C.K_CLIENTE = V.K_CLIENTE
            INNER JOIN PARQUEADERO.MARCA_VEHICULO MV ON V.K_MARCA_VEHICULO = MV.K_MARCA_VEHICULO
        WHERE C.K_CLIENTE = K_CLIENTE_L
        FOR UPDATE OF V, C
    ) T;

    -- Devuelve un JSON con la información de la consulta
    RETURN RESULTADO_L;
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

COMMENT ON FUNCTION PARQUEADERO.MOSTRAR_VEHICULOS_CLIENTE_FU IS E'Función para mostrar los vehículos que un cliente tiene registrados.';

ALTER FUNCTION PARQUEADERO.MOSTRAR_VEHICULOS_CLIENTE_FU OWNER TO PARKUD_DB_ADMIN;


-- El cliente requiere ver un registro de las reservas que ha hecho.
-- La función devuelve todas las reservas hechas por un usuario.
CREATE OR REPLACE FUNCTION PARQUEADERO.MOSTRAR_RESERVAS_CLIENTE_FU()
RETURNS JSON
LANGUAGE PLPGSQL
PARALLEL RESTRICTED
AS $$
DECLARE
    -- Declaración de variables locales
    K_CLIENTE_L PARQUEADERO.CLIENTE.K_CLIENTE%TYPE;
    RESULTADO_L JSON;
    -- Códigos de error
    CODIGO_ERROR_L TEXT;
    RESUMEN_ERROR_L TEXT;
    MENSAJE_ERROR_L TEXT;
BEGIN
    -- Habilita la concurrencia de las tablas pero solo permite que puedan ser proyectadas
    LOCK PARQUEADERO.PAIS IN ACCESS SHARE MODE;
    LOCK PARQUEADERO.CIUDAD IN ACCESS SHARE MODE;
    LOCK PARQUEADERO.DIRECCION IN ACCESS SHARE MODE;
    LOCK PARQUEADERO.SUCURSAL IN ACCESS SHARE MODE;
    LOCK PARQUEADERO.TARIFA_MINUTO IN ACCESS SHARE MODE;
    LOCK PARQUEADERO.HORARIO_SUCURSAL IN ACCESS SHARE MODE;
    LOCK PARQUEADERO.SLOT_PARQUEADERO IN ACCESS SHARE MODE;
    LOCK PARQUEADERO.DIA_SEMANA IN ACCESS SHARE MODE;

    -- Habilita la concurrencia de las tablas mientras que no exista ninguna modificación en curso
    LOCK PARQUEADERO.RESERVA IN SHARE UPDATE EXCLUSIVE MODE;

    -- Recupera la clave primaria del cliente conectado a la BD
    K_CLIENTE_L := PARQUEADERO.RECUPERAR_LLAVE_CLIENTE_FU();

    -- Inserta en un JSON el resultado de la consulta
    SELECT JSON_AGG(ROW_TO_JSON(T)) INTO RESULTADO_L 
    FROM(
        -- Consulta que devuelve la información básica de una reserva
        SELECT C.NOMBRE_CIUDAD "Ciudad",
            S.NOMBRE_SUCURSAL "Nombre sucursal",
            D.NOMBRE_DIRECCION "Dirección",
            SP.K_SLOT_PARQUEADERO "Slot",
            R.FECHA_INICIO_RESERVA "Fecha reserva",
            R.PLACA_VEHICULO "Placa",
            CASE 
                WHEN R.VALOR_RESERVA IS NULL 
                THEN 'Reserva en curso'
                WHEN R.VALOR_RESERVA IS NOT NULL 
                THEN R.VALOR_RESERVA::VARCHAR
            END AS "Total reserva"
        FROM PARQUEADERO.PAIS P 
            INNER JOIN PARQUEADERO.DEPARTAMENTO DP ON P.K_PAIS = DP.K_PAIS
            INNER JOIN PARQUEADERO.CIUDAD C ON DP.K_DEPARTAMENTO = C.K_DEPARTAMENTO
            INNER JOIN PARQUEADERO.DIRECCION D ON C.K_CIUDAD = D.K_CIUDAD
            INNER JOIN PARQUEADERO.SUCURSAL S ON D.K_DIRECCION = S.K_DIRECCION
            INNER JOIN PARQUEADERO.SLOT_PARQUEADERO SP ON S.K_SUCURSAL = SP.K_SUCURSAL
            INNER JOIN PARQUEADERO.RESERVA R ON SP.K_SUCURSAL = R.K_SUCURSAL
                AND SP.K_SLOT_PARQUEADERO = R.K_SLOT_PARQUEADERO
                AND S.K_SUCURSAL = R.K_SUCURSAL
            INNER JOIN PARQUEADERO.CLIENTE CL ON R.K_CLIENTE = CL.K_CLIENTE
        WHERE CL.K_CLIENTE = K_CLIENTE_L
    ) T;

    -- Devuelve un JSON con la información de la consulta
    RETURN RESULTADO_L;
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

COMMENT ON FUNCTION PARQUEADERO.MOSTRAR_RESERVAS_CLIENTE_FU IS E'Función para mostrar las reservas que un cliente ha hecho.';

ALTER FUNCTION PARQUEADERO.MOSTRAR_RESERVAS_CLIENTE_FU OWNER TO PARKUD_DB_ADMIN;