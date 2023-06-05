/* Funciones, procedimientos y triggers de auditoría en la BD.
El modulo de auditoría se encarga de auditar las transacciones de los usuarios.*/

-- Se requiere auditar las transacciones hechas por usuarios en la tabla Vehículo.
-- El siguiente trigger registra si un vehículo fue insertado, modificado o eliminado de la BD.
CREATE OR REPLACE FUNCTION AUDITORIA.AUDIT_VEHICULO_TR()
RETURNS TRIGGER
LANGUAGE PLPGSQL
PARALLEL UNSAFE
AS $$
DECLARE
    -- Códigos de error
    CODIGO_ERROR_L TEXT;
    RESUMEN_ERROR_L TEXT;
    MENSAJE_ERROR_L TEXT;
BEGIN
    -- Bloquea temporalmente las filas que se van a modificar en la tabla
    LOCK AUDITORIA.AUDIT_VEHICULO IN ROW EXCLUSIVE MODE;

    CASE TG_OP
        -- En caso de que se esté insertando un vehículo
        WHEN 'INSERT' THEN
            INSERT INTO AUDITORIA.AUDIT_VEHICULO (
                K_CLIENTE,
                K_VEHICULO,
                PLACA_VEHICULO,
                FECHA_AUDIT_VEHICULO,
                TIPO_VEHICULO_AUDIT,
                TIPO_TRANSACCION_VEHICULO,
                NOMBRE_USUARIO_VEHICULO
            )
            VALUES (
                NEW.K_CLIENTE,
                NEW.K_VEHICULO,
                NEW.PLACA_VEHICULO,
                (SELECT CURRENT_TIMESTAMP AT TIME ZONE 'America/Bogota'),
                NEW.TIPO_VEHICULO,
                'Agregar',
                (SELECT USER)
            );
        
        -- En caso de que se esté actualizando la información de un vehículo
        WHEN 'UPDATE' THEN
            INSERT INTO AUDITORIA.AUDIT_VEHICULO (
                K_CLIENTE,
                K_VEHICULO,
                PLACA_VEHICULO,
                FECHA_AUDIT_VEHICULO,
                TIPO_VEHICULO_AUDIT,
                TIPO_TRANSACCION_VEHICULO,
                NOMBRE_USUARIO_VEHICULO
            )
            VALUES (
                NEW.K_CLIENTE,
                NEW.K_VEHICULO,
                NEW.PLACA_VEHICULO,
                (SELECT CURRENT_TIMESTAMP AT TIME ZONE 'America/Bogota'),
                NEW.TIPO_VEHICULO,
                'Modificación',
                (SELECT USER)
            );

        -- En caso de que se esté eliminando un vehículo
        WHEN 'DELETE' THEN
            INSERT INTO AUDITORIA.AUDIT_VEHICULO (
                K_CLIENTE,
                K_VEHICULO,
                PLACA_VEHICULO,
                FECHA_AUDIT_VEHICULO,
                TIPO_VEHICULO_AUDIT,
                TIPO_TRANSACCION_VEHICULO,
                NOMBRE_USUARIO_VEHICULO
            )
            VALUES (
                OLD.K_CLIENTE,
                NULL,
                OLD.PLACA_VEHICULO,
                (SELECT CURRENT_TIMESTAMP AT TIME ZONE 'America/Bogota'),
                OLD.TIPO_VEHICULO,
                'Eliminación',
                (SELECT USER)
            );
    END CASE;
    RETURN NEW;
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

COMMENT ON FUNCTION AUDITORIA.AUDIT_VEHICULO_TR IS E'Trigger de auditoría de vehículos.';

ALTER FUNCTION AUDITORIA.AUDIT_VEHICULO_TR OWNER TO PARKUD_DB_ADMIN ;

CREATE OR REPLACE TRIGGER AUDIT_VEHICULO_TR
    AFTER INSERT OR UPDATE OR DELETE ON PARQUEADERO.VEHICULO
    FOR EACH ROW
    EXECUTE FUNCTION AUDITORIA.AUDIT_VEHICULO_TR();

-- Se requiere auditar las reservas realizadas por los usuarios en la aplicación.
-- El siguiente trigger registra cuando una reserva es realiazada.
CREATE OR REPLACE FUNCTION AUDITORIA.AUDIT_RESERVAS()
RETURNS TRIGGER
LANGUAGE PLPGSQL
PARALLEL UNSAFE
AS $$
DECLARE
    -- Códigos de error
    CODIGO_ERROR_L TEXT;
    RESUMEN_ERROR_L TEXT;
    MENSAJE_ERROR_L TEXT;
BEGIN
    -- Bloquea temporalmente las filas que se van a modificar en la tabla
    LOCK AUDITORIA.AUDIT_RESERVA IN ROW EXCLUSIVE MODE;

    CASE TG_OP
        -- En caso de que se esté insertando una reserva
        WHEN 'INSERT' THEN
            INSERT INTO AUDITORIA.AUDIT_RESERVA (
                K_RESERVA,
                K_CLIENTE,
                K_SUCURSAL,
                FECHA_AUDIT_RESERVA,
                CIUDAD_AUDIT_RESERVA,
                SUCURSAL_AUDIT_RESERVA,
                TIPO_VEHICULO_RESERVA,
                TIPO_TRANSACCION_RESERVA,
                NOMBRE_USUARIO_RESERVA
            ) VALUES (
                NEW.K_RESERVA,
                NEW.K_CLIENTE,
                NEW.K_SUCURSAL,
                (SELECT CURRENT_TIMESTAMP AT TIME ZONE 'America/Bogota'),
                (SELECT C.NOMBRE_CIUDAD 
                FROM PARQUEADERO.PAIS P 
                    INNER JOIN PARQUEADERO.DEPARTAMENTO DP ON P.K_PAIS = DP.K_PAIS
                    INNER JOIN PARQUEADERO.CIUDAD C ON DP.K_DEPARTAMENTO = C.K_DEPARTAMENTO
                    INNER JOIN PARQUEADERO.DIRECCION D ON C.K_CIUDAD = D.K_CIUDAD
                    INNER JOIN PARQUEADERO.SUCURSAL S ON D.K_DIRECCION = S.K_DIRECCION
                WHERE K_SUCURSAL = NEW.K_SUCURSAL),
                (SELECT S.NOMBRE_SUCURSAL
                FROM PARQUEADERO.PAIS P 
                    INNER JOIN PARQUEADERO.DEPARTAMENTO DP ON P.K_PAIS = DP.K_PAIS
                    INNER JOIN PARQUEADERO.CIUDAD C ON DP.K_DEPARTAMENTO = C.K_DEPARTAMENTO
                    INNER JOIN PARQUEADERO.DIRECCION D ON C.K_CIUDAD = D.K_CIUDAD
                    INNER JOIN PARQUEADERO.SUCURSAL S ON D.K_DIRECCION = S.K_DIRECCION
                WHERE K_SUCURSAL = NEW.K_SUCURSAL),
                (SELECT V.TIPO_VEHICULO
                FROM PARQUEADERO.CLIENTE C
                    INNER JOIN PARQUEADERO.VEHICULO V ON C.K_CLIENTE = V.K_CLIENTE
                WHERE C.K_CLIENTE = NEW.K_CLIENTE
                    AND NEW.PLACA_VEHICULO = V.PLACA_VEHICULO),
                'Creación',
                (SELECT USER)
            );
        
        -- En caso de que se esté actualizando una reserva
        WHEN 'UPDATE' THEN
            INSERT INTO AUDITORIA.AUDIT_RESERVA (
                K_RESERVA,
                K_CLIENTE,
                K_SUCURSAL,
                FECHA_AUDIT_RESERVA,
                CIUDAD_AUDIT_RESERVA,
                SUCURSAL_AUDIT_RESERVA,
                TIPO_VEHICULO_RESERVA,
                TIPO_TRANSACCION_RESERVA,
                NOMBRE_USUARIO_RESERVA
            ) VALUES (
                NEW.K_RESERVA,
                NEW.K_CLIENTE,
                NEW.K_SUCURSAL,
                (SELECT CURRENT_TIMESTAMP AT TIME ZONE 'America/Bogota'),
                (SELECT C.NOMBRE_CIUDAD 
                FROM PARQUEADERO.PAIS P 
                    INNER JOIN PARQUEADERO.DEPARTAMENTO DP ON P.K_PAIS = DP.K_PAIS
                    INNER JOIN PARQUEADERO.CIUDAD C ON DP.K_DEPARTAMENTO = C.K_DEPARTAMENTO
                    INNER JOIN PARQUEADERO.DIRECCION D ON C.K_CIUDAD = D.K_CIUDAD
                    INNER JOIN PARQUEADERO.SUCURSAL S ON D.K_DIRECCION = S.K_DIRECCION
                WHERE K_SUCURSAL = NEW.K_SUCURSAL),
                (SELECT S.NOMBRE_SUCURSAL
                FROM PARQUEADERO.PAIS P 
                    INNER JOIN PARQUEADERO.DEPARTAMENTO DP ON P.K_PAIS = DP.K_PAIS
                    INNER JOIN PARQUEADERO.CIUDAD C ON DP.K_DEPARTAMENTO = C.K_DEPARTAMENTO
                    INNER JOIN PARQUEADERO.DIRECCION D ON C.K_CIUDAD = D.K_CIUDAD
                    INNER JOIN PARQUEADERO.SUCURSAL S ON D.K_DIRECCION = S.K_DIRECCION
                WHERE K_SUCURSAL = NEW.K_SUCURSAL),
                (SELECT V.TIPO_VEHICULO
                FROM PARQUEADERO.CLIENTE C
                    INNER JOIN PARQUEADERO.VEHICULO V ON C.K_CLIENTE = V.K_CLIENTE
                WHERE C.K_CLIENTE = NEW.K_CLIENTE
                    AND NEW.PLACA_VEHICULO = V.PLACA_VEHICULO),
                'Modificación',
                (SELECT USER)
            );
    END CASE;

    -- Continúa con la transacción.
    RETURN NEW;
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

COMMENT ON FUNCTION AUDITORIA.AUDIT_RESERVAS IS E'Trigger de auditoría de reservas.';

ALTER FUNCTION AUDITORIA.AUDIT_RESERVAS OWNER TO PARKUD_DB_ADMIN ;

CREATE OR REPLACE TRIGGER AUDIT_RESERVAS
    AFTER INSERT OR UPDATE ON PARQUEADERO.RESERVA
    FOR EACH ROW
    EXECUTE FUNCTION AUDITORIA.AUDIT_RESERVAS();

-- Se requiere registrar la dirección IP de los clientes que entran a la aplicación.
-- El siguiente procedimiento audita los inicios de sesión y las direcciones IP de los clientes.
CREATE OR REPLACE PROCEDURE AUDITORIA.AUDIT_INGRESO_USUARIO_PR(
    IN ROL_USUARIO_P TEXT
)
LANGUAGE PLPGSQL
AS $$
DECLARE
    -- Códigos de error
    CODIGO_ERROR_L TEXT;
    RESUMEN_ERROR_L TEXT;
    MENSAJE_ERROR_L TEXT;
BEGIN
    -- Bloquea temporalmente las filas que se van a modificar en la tabla
    LOCK AUDITORIA.AUDIT_USUARIO IN ROW EXCLUSIVE MODE;

    -- Si es un cliente
    IF UPPER(TRIM(ROL_USUARIO_P)) = 'USER_ROLE' THEN
        -- Inserta los valores en la tabla de auditoría
        INSERT INTO AUDITORIA.AUDIT_USUARIO (
            K_EMPLEADO,
            K_CLIENTE,
            NOMBRE_USUARIO,
            DIRECCION_IP,
            FECHA_AUDIT_USUARIO,
            TIPO_TRANSACCION_CLIENTE
        )
        VALUES (
            NULL,
            (SELECT PARQUEADERO.RECUPERAR_LLAVE_CLIENTE_FU()),
            (SELECT USER),
            (SELECT INET_CLIENT_ADDR()),
            (SELECT CURRENT_TIMESTAMP AT TIME ZONE 'America/Bogota'),
            'Ingreso'
        );

    -- Si es un operador, administrador o súper administrador
    ELSIF UPPER(TRIM(ROL_USUARIO_P)) = 'OPERADOR_ROLE'
            OR UPPER(TRIM(ROL_USUARIO_P)) = 'ADMIN_ROLE'
            OR UPPER(TRIM(ROL_USUARIO_P)) = 'SUPER_ADMIN_ROLE' THEN
        
        -- Inserta los valores en la tabla de auditoría
        INSERT INTO AUDITORIA.AUDIT_USUARIO (
            K_EMPLEADO,
            K_CLIENTE,
            NOMBRE_USUARIO,
            DIRECCION_IP,
            FECHA_AUDIT_USUARIO,
            TIPO_TRANSACCION_CLIENTE
        )
        VALUES (
            (SELECT PARQUEADERO.RECUPERAR_LLAVE_EMPLEADO_FU()),
            NULL,
            (SELECT USER),
            (SELECT INET_CLIENT_ADDR()),
            (SELECT CURRENT_TIMESTAMP AT TIME ZONE 'America/Bogota'),
            'Ingreso'
        );
    END IF;
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

COMMENT ON PROCEDURE AUDITORIA.AUDIT_INGRESO_USUARIO_PR IS E'Procedimiento de auditoría para los usuarios que inician sesión en la BD.';

ALTER PROCEDURE AUDITORIA.AUDIT_INGRESO_USUARIO_PR OWNER TO PARKUD_DB_ADMIN;


-- Se requiere registrar los usuarios que se registran en la aplicación.
-- El siguiente trigger audita los registros hechos por clientes nuevos.
CREATE OR REPLACE FUNCTION AUDITORIA.AUDIT_REGISTRO_CLIENTE_TR()
RETURNS TRIGGER
LANGUAGE PLPGSQL
PARALLEL UNSAFE
AS $$
DECLARE
    -- Códigos de error
    CODIGO_ERROR_L TEXT;
    RESUMEN_ERROR_L TEXT;
    MENSAJE_ERROR_L TEXT;
BEGIN
    -- Bloquea temporalmente las filas que se van a modificar en la tabla
    LOCK AUDITORIA.AUDIT_USUARIO IN ROW EXCLUSIVE MODE;

    -- Audita el registro del usuario
    INSERT INTO AUDITORIA.AUDIT_USUARIO (
        K_EMPLEADO,
        K_CLIENTE,
        NOMBRE_USUARIO,
        DIRECCION_IP,
        FECHA_AUDIT_USUARIO,
        TIPO_TRANSACCION_CLIENTE
    )
    VALUES (
        NULL,
        NEW.K_CLIENTE,
        (SELECT PARQUEADERO.PGP_SYM_DECRYPT(NEW.CORREO_CLIENTE, 'AES_KEY')),
        (SELECT INET_CLIENT_ADDR()),
        (SELECT CURRENT_TIMESTAMP AT TIME ZONE 'America/Bogota'),
        'Registro'
    );

    -- Continúa con el INSERT
    RETURN NEW;
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

COMMENT ON FUNCTION AUDITORIA.AUDIT_REGISTRO_CLIENTE_TR IS E'Trigger de auditoría para los clientes que se registran en la aplicación.';

ALTER FUNCTION AUDITORIA.AUDIT_REGISTRO_CLIENTE_TR OWNER TO PARKUD_DB_ADMIN;

CREATE OR REPLACE TRIGGER AUDIT_REGISTRO_CLIENTE_TR
    AFTER INSERT ON PARQUEADERO.CLIENTE
    FOR EACH ROW
    EXECUTE FUNCTION AUDITORIA.AUDIT_REGISTRO_CLIENTE_TR();


-- Los administradores y gerentes requieren ver el flujo transaccional auditado.
-- La siguiente función devuelve todas las transacciones auditadas de la BD.
CREATE OR REPLACE FUNCTION AUDITORIA.MOSTRAR_AUDITORIA_FU()
RETURNS JSON
LANGUAGE PLPGSQL
PARALLEL RESTRICTED
AS $$
DECLARE 
    RESULTADO_L JSON;
BEGIN
    -- Habilita la concurrencia de las tablas pero solo permite que puedan ser proyectadas
    LOCK PARQUEADERO.PAIS IN ACCESS SHARE MODE;
    LOCK PARQUEADERO.CIUDAD IN ACCESS SHARE MODE;
    LOCK PARQUEADERO.DIRECCION IN ACCESS SHARE MODE;
    LOCK PARQUEADERO.SUCURSAL IN ACCESS SHARE MODE;
    LOCK AUDITORIA.AUDIT_RESERVA IN ACCESS SHARE MODE;
    LOCK AUDITORIA.AUDIT_VEHICULO IN ACCESS SHARE MODE;
    LOCK AUDITORIA.AUDIT_USUARIO IN ACCESS SHARE MODE;

    -- Inserta en un JSON el resultado de la consulta
    SELECT JSON_AGG(ROW_TO_JSON(T)) INTO RESULTADO_L
    FROM (
        -- Consulta que devuelve toda la información auditada en la BD
        SELECT AR.NOMBRE_USUARIO_RESERVA "Usuario",
            AR.FECHA_AUDIT_RESERVA::DATE "Fecha",
            TO_CHAR(AR.FECHA_AUDIT_RESERVA:: TIME, 'HH:MI') "Hora",
            'Reserva:' || ' ' || TIPO_TRANSACCION_RESERVA "Transacción",
            C.NOMBRE_CIUDAD "Ciudad",
            S.NOMBRE_SUCURSAL "Sucursal"
        FROM PARQUEADERO.PAIS P 
            INNER JOIN PARQUEADERO.DEPARTAMENTO DP ON P.K_PAIS = DP.K_PAIS
            INNER JOIN PARQUEADERO.CIUDAD C ON DP.K_DEPARTAMENTO = C.K_DEPARTAMENTO
            INNER JOIN PARQUEADERO.DIRECCION D ON C.K_CIUDAD = D.K_CIUDAD
            INNER JOIN PARQUEADERO.SUCURSAL S ON D.K_DIRECCION = S.K_DIRECCION
            INNER JOIN AUDITORIA.AUDIT_RESERVA AR ON S.K_SUCURSAL = AR.K_SUCURSAL
        UNION ALL
        SELECT NOMBRE_USUARIO_VEHICULO "Usuario",
            FECHA_AUDIT_VEHICULO::DATE "Fecha",
            TO_CHAR(FECHA_AUDIT_VEHICULO::TIME, 'HH:MI') "Hora",
            'Vehículo' || ' ' || PLACA_VEHICULO || ': ' || TIPO_TRANSACCION_VEHICULO "Transacción",
            'N/A' "Ciudad",
            'N/A' "Sucursal"
        FROM AUDITORIA.AUDIT_VEHICULO
        UNION ALL
        SELECT NOMBRE_USUARIO "Usuario",
            FECHA_AUDIT_USUARIO::DATE "Fecha",
            TO_CHAR(FECHA_AUDIT_USUARIO::TIME, 'HH:MI') "Hora",
            TIPO_TRANSACCION_CLIENTE || ': ' || DIRECCION_IP "Transacción",
            'N/A' "Ciudad",
            'N/A' "Sucursal"
        FROM AUDITORIA.AUDIT_USUARIO
    ) T;

    RETURN RESULTADO_L;
END;
$$;

COMMENT ON FUNCTION AUDITORIA.MOSTRAR_AUDITORIA_FU IS E'Función que retorna los valores de auditoría';
 
ALTER FUNCTION AUDITORIA.MOSTRAR_AUDITORIA_FU OWNER TO PARKUD_DB_ADMIN;