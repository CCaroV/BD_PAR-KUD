-- Trigger de auditoría de vehículos
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

ALTER FUNCTION AUDITORIA.AUDIT_VEHICULO_TR() OWNER TO PARKUD_DB_ADMIN ;

CREATE OR REPLACE TRIGGER AUDIT_VEHICULO_TR
    AFTER INSERT OR UPDATE OR DELETE ON PARQUEADERO.VEHICULO
    FOR EACH ROW
    EXECUTE FUNCTION AUDITORIA.AUDIT_VEHICULO_TR();

-- Trigger que verifica que la tabla de auditoría de usuarios tenga una llave foránea de empleado o cliente (excluyentes).
CREATE OR REPLACE FUNCTION AUDITORIA.VERIFICAR_AUDIT_USUARIO_TR()
RETURNS TRIGGER
LANGUAGE PLPGSQL
AS $$
BEGIN
    -- Si no hay ninguna llave foránea no se está auditando a nadie.
    -- Si hay dos llaves foráneas se está auditando a un empleado y a un cliente a la vez.
    IF NEW.K_EMPLEADO IS NULL AND NEW.K_CLIENTE IS NULL THEN
        RAISE EXCEPTION 'No se ha ingresado la llave foránea de ningún usuario.';
    ELSIF NEW.K_EMPLEADO IS NOT NULL AND NEW.K_CLIENTE IS NOT NULL THEN
        RAISE EXCEPTION 'Se está tratano de auditar a un cliente y un empleado a la vez.';
    END IF;
END;
$$;

COMMENT ON FUNCTION AUDITORIA.VERIFICAR_AUDIT_USUARIO_TR IS E'Trigger que verifica que la tabla de auditoría de usuarios tenga una llave foránea de empleado o cliente (excluyentes).';

ALTER FUNCTION AUDITORIA.VERIFICAR_AUDIT_USUARIO_TR() OWNER TO PARKUD_DB_ADMIN ;

CREATE OR REPLACE TRIGGER VERIFICAR_AUDIT_USUARIO_TR
    BEFORE INSERT OR UPDATE ON AUDITORIA.AUDIT_USUARIO
    FOR EACH ROW
    EXECUTE FUNCTION AUDITORIA.VERIFICAR_AUDIT_USUARIO_TR();

-- Trigger que verifica que el nombre de una sucursal no se repita en una ciudad.
CREATE OR REPLACE FUNCTION PARQUEADERO.VERIFICAR_NOMBRE_SUCURSAL_TR()
RETURNS TRIGGER
LANGUAGE PLPGSQL
AS $$
DECLARE
    -- Declaración de variables locales
    K_CIUDAD_L PARQUEADERO.CIUDAD.K_CIUDAD%TYPE;
BEGIN
    -- Inserta la PK de la ciudad en la variable
    SELECT C.K_CIUDAD INTO STRICT K_CIUDAD_L
    FROM PARQUEADERO.PAIS P
        INNER JOIN PARQUEADERO.DEPARTAMENTO DP ON P.K_PAIS = DP.K_PAIS
        INNER JOIN PARQUEADERO.CIUDAD C ON DP.K_DEPARTAMENTO = C.K_DEPARTAMENTO
        INNER JOIN PARQUEADERO.DIRECCION D ON C.K_CIUDAD = D.K_CIUDAD
    WHERE D.K_DIRECCION = NEW.K_DIRECCION;

    -- Verifica que el nombre de la sucursal no se repita en la misma ciudad
    IF EXISTS (
        SELECT 1
        FROM PARQUEADERO.SUCURSAL
        WHERE NOMBRE_SUCURSAL = NEW.NOMBRE_SUCURSAL
          AND K_DIRECCION IN (
              SELECT K_DIRECCION
              FROM PARQUEADERO.DIRECCION
              WHERE K_CIUDAD = K_CIUDAD_L
          )
          AND K_SUCURSAL <> NEW.K_SUCURSAL -- Excluir el registro actual en caso de actualización
    ) THEN
        -- Lanza una excepción indicando que el nombre de la sucursal no es único en relación con la ciudad
        RAISE EXCEPTION 'Ya existe una sucursal con el mismo nombre en la misma ciudad.';
    END IF;

    RETURN NEW;
END;
$$;

COMMENT ON FUNCTION PARQUEADERO.VERIFICAR_NOMBRE_SUCURSAL_TR IS E'Trigger que verifica que el nombre de una sucursal no se repita en una ciudad.';

ALTER FUNCTION PARQUEADERO.VERIFICAR_NOMBRE_SUCURSAL_TR() OWNER TO PARKUD_DB_ADMIN ;

CREATE OR REPLACE TRIGGER VERIFICAR_NOMBRE_SUCURSAL_TR
    BEFORE INSERT OR UPDATE ON PARQUEADERO.SUCURSAL
    FOR EACH ROW
    EXECUTE FUNCTION PARQUEADERO.VERIFICAR_NOMBRE_SUCURSAL_TR();