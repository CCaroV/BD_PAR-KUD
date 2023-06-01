/* Funciones y procedimientos para mostrar, modificar o eliminar los registros de vehículos y métodos de pago de un cliente.
Los clientes registrados deben poder ver la información que tienen registrada en la aplicación y modificarla o eliminarla.*/

-- El cliente puede tener varios vehículos registrados en la BD.
-- La función devuelve todos los vehículos registrados del cliente.
CREATE OR REPLACE FUNCTION PARQUEADERO.MOSTRAR_VEHICULOS_CLIENTE_FU()
RETURNS JSON
LANGUAGE PLPGSQL
AS $$
DECLARE 
    -- Declaración de variables locales
    RESULTADO_L JSON;
    K_CLIENTE_L PARQUEADERO.CLIENTE.K_CLIENTE%TYPE;
BEGIN
    -- Recupera la clave primaria del cliente conectado a la BD
    SELECT K_CLIENTE INTO STRICT K_CLIENTE_L
    FROM PARQUEADERO.CLIENTE
    WHERE PARQUEADERO.PGP_SYM_DECRYPT(CORREO_CLIENTE, 'AES_KEY') = CURRENT_USER;

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
    ) T;

    -- Devuelve un JSON con la información de la consulta
    RETURN RESULTADO_L;
EXCEPTION
    -- Excepciones
    WHEN NO_DATA_FOUND THEN
        ROLLBACK;
        RAISE EXCEPTION 'El usuario actual no está registrado como cliente, %/%', SQLSTATE, SQLERRM;
    WHEN TOO_MANY_ROWS THEN
        ROLLBACK;
        RAISE EXCEPTION 'Hay inconsistencias en la BD, tabla cliente: hay un correo repetido, %/%', SQLSTATE, SQLERRM;
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE EXCEPTION 'MOSTRAR_VEHICULOS_CLIENTE_FU ha ocurrido un error: %/%', SQLSTATE, SQLERRM;
END;
$$;

COMMENT ON FUNCTION PARQUEADERO.MOSTRAR_VEHICULOS_CLIENTE_FU IS E'Función para mostrar los vehículos que un cliente tiene registrados.';

ALTER FUNCTION PARQUEADERO.MOSTRAR_VEHICULOS_CLIENTE_FU() OWNER TO PARKUD_DB_ADMIN;
