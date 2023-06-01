/* Funciones, procedimientos y triggers de auditoría en la BD.
El modulo de auditoría se encarga de auditar las transacciones de los usuarios.*/

-- Se requiere auditar las transacciones hechas por usuarios en la tabla Vehículo.
-- El siguiente trigger registra si un vehículo fue insertado, modificado o eliminado de la BD.
CREATE OR REPLACE FUNCTION AUDITORIA.AUDIT_VEHICULO_TR()
RETURNS TRIGGER
LANGUAGE PLPGSQL
AS $$
BEGIN
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
        ROLLBACK;
        RAISE EXCEPTION 'AUDIT_VEHICULO_TR ha ocurrido un error: %/%', SQLSTATE, SQLERRM;
END;
$$;

COMMENT ON FUNCTION AUDITORIA.AUDIT_VEHICULO_TR IS E'Trigger de auditoría de vehículos.';

ALTER FUNCTION AUDITORIA.AUDIT_VEHICULO_TR OWNER TO PARKUD_DB_ADMIN ;

CREATE OR REPLACE TRIGGER AUDIT_VEHICULO_TR
    AFTER INSERT OR UPDATE OR DELETE ON PARQUEADERO.VEHICULO
    FOR EACH ROW
    EXECUTE FUNCTION AUDITORIA.AUDIT_VEHICULO_TR();


-- Se requiere registrar la dirección IP de los clientes que entran a la aplicación.
-- El siguiente procedimiento audita los inicios de sesión y las direcciones IP de los clientes.
CREATE OR REPLACE PROCEDURE AUDITORIA.AUDIT_INGRESO_USUARIO_PR()
LANGUAGE PLPGSQL
AS $$
DECLARE
    -- Declaración de variables locales
    ROL_USUARIO_L VARCHAR;
BEGIN
    -- Selecciona el rol del usuario que ingresó
    SELECT LOWER(TRIM(G.ROLNAME)) INTO STRICT ROL_USUARIO_L
    FROM PG_ROLES R
        JOIN PG_AUTH_MEMBERS M ON R.OID = M.MEMBER
        JOIN PG_ROLES G ON M.ROLEID = G.OID
    WHERE R.ROLNAME = CURRENT_USER;

    -- Si es un cliente
    IF ROL_USUARIO_L = LOWER(TRIM('USER_ROLE')) THEN
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
            (SELECT K_CLIENTE FROM PARQUEADERO.CLIENTE WHERE PARQUEADERO.PGP_SYM_DECRYPT(CORREO_CLIENTE, 'AES_KEY') = CURRENT_USER),
            (SELECT USER),
            (SELECT INET_CLIENT_ADDR()),
            (SELECT CURRENT_TIMESTAMP AT TIME ZONE 'America/Bogota'),
            'Ingreso'
        );
        PERFORM PARQUEADERO.INSERTAR_LLAVE_CLIENTE_PR();

    -- Si es un operador, administrador o súper administrador
    ELSIF ROL_USUARIO_L = LOWER(TRIM('OPERADOR_ROLE'))
            OR ROL_USUARIO_L = LOWER(TRIM('ADMIN_ROLE'))
            OR ROL_USUARIO_L = LOWER(TRIM('SUPER_ADMIN_ROLE')) THEN
        INSERT INTO AUDITORIA.AUDIT_USUARIO (
            K_EMPLEADO,
            K_CLIENTE,
            NOMBRE_USUARIO,
            DIRECCION_IP,
            FECHA_AUDIT_USUARIO,
            TIPO_TRANSACCION_CLIENTE
        )
        VALUES (
            (SELECT K_EMPLEADO FROM PARQUEADERO.EMPLEADO WHERE PARQUEADERO.PGP_SYM_DECRYPT(CORREO_EMPLEADO, 'AES_KEY') = CURRENT_USER),
            NULL,
            (SELECT USER),
            (SELECT INET_CLIENT_ADDR()),
            (SELECT CURRENT_TIMESTAMP AT TIME ZONE 'America/Bogota'),
            'Ingreso'
        );
        PERFORM PARQUEADERO.INSERTAR_LLAVE_EMPLEADO_PR();
    END IF;
EXCEPTION
    -- Excepciones
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE EXCEPTION 'AUDIT_INGRESO_USUARIO_PR ha ocurrido un error: %/%', SQLSTATE, SQLERRM;
END;
$$;

COMMENT ON PROCEDURE AUDITORIA.AUDIT_INGRESO_USUARIO_PR IS E'Procedimiento de auditoría para los usuarios que inician sesión en la BD.';

ALTER PROCEDURE AUDITORIA.AUDIT_INGRESO_USUARIO_PR OWNER TO PARKUD_DB_ADMIN;

-- Se requiere registrar los usuarios que se registran en la aplicación.
-- El siguiente trigger audita los registros hechos por clientes nuevos.
CREATE OR REPLACE FUNCTION AUDITORIA.AUDIT_REGISTRO_CLIENTE_TR()
RETURNS TRIGGER
LANGUAGE PLPGSQL
AS $$
BEGIN
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
        ROLLBACK;
        RAISE EXCEPTION 'AUDIT_REGISTRO_CLIENTE_TR ha ocurrido un error: %/%', SQLSTATE, SQLERRM;
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
AS $$
DECLARE 
    RESULTADO_L JSON;
BEGIN

    SELECT JSON_AGG(ROW_TO_JSON(T)) INTO RESULTADO_L
    FROM (
        SELECT AR.NOMBRE_USUARIO_RESERVA "Usuario",
            AR.FECHA_AUDIT_RESERVA "Fecha",
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
            FECHA_AUDIT_VEHICULO "Fecha",
            'Vehículo' || ' ' || PLACA_VEHICULO || ': ' || TIPO_TRANSACCION_VEHICULO "Transacción",
            'N/A' "Ciudad",
            'N/A' "Sucursal"
        FROM AUDITORIA.AUDIT_VEHICULO
        UNION ALL
        SELECT NOMBRE_USUARIO "Usuario",
            FECHA_AUDIT_USUARIO "Fecha",
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