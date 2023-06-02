/* Funciones y procedimientos necesarios para el inicio de sesión de un usuario*/

-- Es necesario saber el rol del usuario que inicia sesión en la aplicación para saber qué vistas mostrar.
-- La función retorna el rol del usuario que desea conectarse.
CREATE OR REPLACE FUNCTION PARQUEADERO.MOSTRAR_ROL_USUARIO_FU(
    IN NOMBRE_USUARIO_P TEXT
)
RETURNS TEXT
LANGUAGE PLPGSQL
PARALLEL RESTRICTED
AS $$
DECLARE
    -- Declaración de variables
    ROL_USUARIO_L VARCHAR;
    -- Códigos de error
    CODIGO_ERROR_L TEXT;
    RESUMEN_ERROR_L TEXT;
    MENSAJE_ERROR_L TEXT;
BEGIN
    -- Selecciona el rol del nombre de usuario ingresado
    SELECT LOWER(TRIM(G.ROLNAME)) INTO STRICT ROL_USUARIO_L
    FROM PG_ROLES R
        JOIN PG_AUTH_MEMBERS M ON R.OID = M.MEMBER
        JOIN PG_ROLES G ON M.ROLEID = G.OID
    WHERE R.ROLNAME = NOMBRE_USUARIO_P;

    -- Retorna el rol
    RETURN ROL_USUARIO_L;
EXCEPTION
    -- Excepciones
    WHEN NO_DATA_FOUND THEN
        RAISE EXCEPTION 'El usuario no tiene ningún rol asociado en la BD.';
    WHEN TOO_MANY_ROWS THEN
        RAISE EXCEPTION 'Inconsistencias en la BD: Hay más de un rol asociado a este usuario.';
    WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS 
            CODIGO_ERROR_L = RETURNED_SQLSTATE,
            RESUMEN_ERROR_L = MESSAGE_TEXT,
            MENSAJE_ERROR_L = PG_EXCEPTION_CONTEXT;
        RETURN CONCAT(CODIGO_ERROR_L, ' ', RESUMEN_ERROR_L, ' ',MENSAJE_ERROR_L);
END;
$$;

COMMENT ON FUNCTION PARQUEADERO.MOSTRAR_ROL_USUARIO_FU IS E'Función que devuelve el rol asociado a un usuario.';

ALTER FUNCTION PARQUEADERO.MOSTRAR_ROL_USUARIO_FU OWNER TO PARKUD_DB_ADMIN;