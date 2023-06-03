/* Funciones y procedimientos para mostrar, modificar o eliminar los registros de vehículos y métodos de pago de un cliente.
Los clientes registrados deben poder ver la información que tienen registrada en la aplicación y modificarla o eliminarla.*/

-- El cliente puede tener varios vehículos registrados en la BD.
-- La función devuelve todos los vehículos registrados del cliente.
CREATE OR REPLACE FUNCTION PARQUEADERO.MOSTRAR_VEHICULOS_CLIENTE_FU()
RETURNS JSON
LANGUAGE PLPGSQL
PARALLEL UNSAFE
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
    LOCK TABLE PARQUEADERO.MARCA_VEHICULO IN SHARE MODE;

    -- Habilita la concurrencia de las tablas en distintas filas pero solo permite que puedan ser proyectadas
    LOCK TABLE PARQUEADERO.CLIENTE IN ROW SHARE MODE;
    LOCK TABLE PARQUEADERO.VEHICULO IN ROW SHARE MODE;

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
        FOR UPDATE
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

ALTER FUNCTION PARQUEADERO.MOSTRAR_VEHICULOS_CLIENTE_FU() OWNER TO PARKUD_DB_ADMIN;
