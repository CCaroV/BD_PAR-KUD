/* Triggers que verifican que los datos de las tablas se correspondan con las reglas de negocio.
Existen algunas reglas de negocio que no pueden ser definidas mediante la cláusula CHECK en la BD.
Estas restricciones pueden ser modeladas mediante triggers.*/

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
    -- Continúa con la inserción o actualización
    RETURN NEW;
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


-- Trigger que verifica que una sucursal solo tenga una tarifa activa.
CREATE OR REPLACE FUNCTION PARQUEADERO.ACTUALIZACION_TARIFA_TR()
RETURNS TRIGGER
LANGUAGE PLPGSQL
AS $$
DECLARE
    -- Declaración de variables locales
    K_TARIFA_MINUTO_L PARQUEADERO.TARIFA_MINUTO.K_TARIFA_MINUTO%TYPE;
    FECHA_INICIO_TARIFA_L PARQUEADERO.TARIFA_MINUTO.FECHA_INICIO_TARIFA%TYPE;
BEGIN
    -- Verifica que la PK de la tarifa anterior exista
    -- Si no existe, esta es la primera tarifa que una sucursal va a insertar
    IF EXISTS (
        SELECT 1
        FROM PARQUEADERO.TARIFA_MINUTO
        WHERE K_SUCURSAL = NEW.K_SUCURSAL
    ) THEN 
        -- Recupera la PK y la fecha de inicio de la última sucursal
        SELECT K_TARIFA_MINUTO,
            FECHA_INICIO_TARIFA INTO STRICT K_TARIFA_MINUTO_L,
            FECHA_INICIO_TARIFA_L
        FROM PARQUEADERO.TARIFA_MINUTO
        WHERE K_SUCURSAL = NEW.K_SUCURSAL
            AND ESTA_ACTIVA = TRUE;

        -- Si han habido cambios recientes en la tarifa
        IF (SELECT CURRENT_TIMESTAMP AT TIME ZONE 'America/Bogota') - FECHA_INICIO_TARIFA_L <= '0 YEARS 0 MONTHS 0 DAYS 0 HOURS 10 MINUTES'::INTERVAL THEN
            -- Actualiza la tarifa actual sin crear una nueva
            UPDATE PARQUEADERO.TARIFA_MINUTO
            SET VALOR_MINUTO_SUV = NEW.VALOR_MINUTO_SUV,
                VALOR_MINUTO_AUTO = NEW.VALOR_MINUTO_AUTO,
                VALOR_MINUTO_MOTO = NEW.VALOR_MINUTO_MOTO,
                ADICION_PARQ_CUBIERTO = NEW.ADICION_PARQ_CUBIERTO,
                VALOR_MULTA_CANCELACION = NEW.VALOR_MULTA_CANCELACION
            WHERE K_TARIFA_MINUTO = K_TARIFA_MINUTO_L;
            
            -- Aborta la inserción ya que no es necesaria
            RETURN NULL;
        ELSE
            -- Actualiza la tarifa antigua, la deja inactiva y crea una nueva tarifa
            UPDATE PARQUEADERO.TARIFA_MINUTO 
            SET FECHA_FIN_TARIFA = (SELECT CURRENT_TIMESTAMP AT TIME ZONE 'America/Bogota'),
                ESTA_ACTIVA = FALSE
            WHERE K_TARIFA_MINUTO = K_TARIFA_MINUTO_L;
        END IF;
    END IF;
    
    -- Continúa con el INSERT
    RETURN NEW;
EXCEPTION 
    -- Excepciones
    WHEN TOO_MANY_ROWS THEN
        ROLLBACK;
        RAISE EXCEPTION 'Inconsistencias en la BD: Hay más de una tarifa activa para la sucursal de PK %, %/%',NEW.K_SUCURSAL, SQLSTATE, SQLERRM;
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE EXCEPTION 'MODIFICAR_TARIFA_SUCURSAL_PR ha ocurrido un error: %/%', SQLSTATE, SQLERRM;
END;
$$;

COMMENT ON FUNCTION PARQUEADERO.ACTUALIZACION_TARIFA_TR IS E'Trigger que verifica que una sucursal solo tenga una tarifa activa.';

ALTER FUNCTION PARQUEADERO.ACTUALIZACION_TARIFA_TR() OWNER TO PARKUD_DB_ADMIN ;

CREATE OR REPLACE TRIGGER ACTUALIZACION_TARIFA_TR
    BEFORE INSERT ON PARQUEADERO.TARIFA_MINUTO
    FOR EACH ROW
    EXECUTE FUNCTION PARQUEADERO.ACTUALIZACION_TARIFA_TR();