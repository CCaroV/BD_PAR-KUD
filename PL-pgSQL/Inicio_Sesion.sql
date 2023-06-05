/* Funciones y procedimientos necesarios para el inicio de sesión de un usuario*/

-- Es necesario saber el rol del usuario que inicia sesión en la aplicación para saber qué vistas mostrar.
-- La función retorna el rol del usuario que desea conectarse.
CREATE OR REPLACE FUNCTION PARQUEADERO.INICIO_SESION_USUARIO_FU()
RETURNS TEXT
LANGUAGE PLPGSQL
PARALLEL UNSAFE
AS $$
DECLARE
    -- Declaración de variables locales
    ROL_USUARIO_L VARCHAR;
    -- Códigos de error
    CODIGO_ERROR_L TEXT;
    RESUMEN_ERROR_L TEXT;
    MENSAJE_ERROR_L TEXT;
BEGIN
    -- Selecciona el rol usuario que intenta hacer la conexión
    SELECT UPPER(TRIM(G.ROLNAME)) INTO STRICT ROL_USUARIO_L
    FROM PG_ROLES R
        JOIN PG_AUTH_MEMBERS M ON R.OID = M.MEMBER
        JOIN PG_ROLES G ON M.ROLEID = G.OID
    WHERE R.ROLNAME = CURRENT_USER;

    -- Hace el registro de auditoría
    CALL AUDITORIA.AUDIT_INGRESO_USUARIO_PR(ROL_USUARIO_L);

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
            CODIGO_ERROR_L := RETURNED_SQLSTATE,
            RESUMEN_ERROR_L := MESSAGE_TEXT,
            MENSAJE_ERROR_L := PG_EXCEPTION_CONTEXT;
        RAISE EXCEPTION 'Código de error: % / Resumen del error: % / Mensaje de error: %', CODIGO_ERROR_L, RESUMEN_ERROR_L, MENSAJE_ERROR_L;
END;
$$;

COMMENT ON FUNCTION PARQUEADERO.INICIO_SESION_USUARIO_FU IS E'Función que devuelve el rol asociado a un usuario.';

ALTER FUNCTION PARQUEADERO.INICIO_SESION_USUARIO_FU OWNER TO PARKUD_DB_ADMIN;


-- Un cliente puede registrarse pero nunca completar el registro.
-- Esto significa que la BD tendrá información no necesaria almacenada.
-- El siguiente procedimiento elimina la info de los usuarios que no completaron el registro.
CREATE OR REPLACE PROCEDURE AUDITORIA.ELIMINAR_USUARIOS_NO_REGISTRADOS_PR()
LANGUAGE PLPGSQL
AS $$
DECLARE
    -- Declaración de variables locales
    NOMBRE_USUARIO_L TEXT;
    USUARIO_REC_L RECORD;
    CURSOR_USUARIO_L CURSOR FOR SELECT USENAME FROM PG_USER WHERE VALUNTIL IS NOT NULL AND VALUNTIL < '2050-01-01';
    -- Códigos de error
    CODIGO_ERROR_L TEXT;
    RESUMEN_ERROR_L TEXT;
    MENSAJE_ERROR_L TEXT;
BEGIN
    -- Ejecuta la sentencia por cada registro encontrado
    FOR USUARIO_REC_L IN CURSOR_USUARIO_L LOOP
        DELETE FROM PARQUEADERO.CLIENTE WHERE CORREO_CLIENTE = PGP_SYM_DECRYPT(USUARIO_REC_L.USENAME, 'AES_KEY');
        EXECUTE FORMAT('DROP USER %I', USUARIO_REC_L.USENAME);
    END LOOP;
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

COMMENT ON PROCEDURE AUDITORIA.ELIMINAR_USUARIOS_NO_REGISTRADOS_PR IS E'Procedimiento que elimina los usuarios que no han completado el registro de la BD.';

ALTER PROCEDURE AUDITORIA.ELIMINAR_USUARIOS_NO_REGISTRADOS_PR OWNER TO PARKUD_DB_ADMIN;