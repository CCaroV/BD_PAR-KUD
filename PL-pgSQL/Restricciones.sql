/* Triggers que verifican que los datos de las tablas se correspondan con las reglas de negocio.
Existen algunas reglas de negocio que no pueden ser definidas mediante la cláusula CHECK en la BD.
Estas restricciones pueden ser modeladas mediante triggers.*/

-- Trigger que verifica que la tabla de auditoría de usuarios tenga una llave foránea de empleado o cliente (excluyentes).
CREATE OR REPLACE FUNCTION AUDITORIA.VERIFICAR_AUDIT_USUARIO_TR()
RETURNS TRIGGER
PARALLEL SAFE
LANGUAGE PLPGSQL
AS $$
BEGIN
    -- Si hay dos llaves foráneas se está auditando a un empleado y a un cliente a la vez.
    IF NEW.K_EMPLEADO IS NOT NULL AND NEW.K_CLIENTE IS NOT NULL THEN
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
PARALLEL RESTRICTED
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
PARALLEL UNSAFE
AS $$
DECLARE
    -- Declaración de variables locales
    K_TARIFA_MINUTO_L PARQUEADERO.TARIFA_MINUTO.K_TARIFA_MINUTO%TYPE;
    FECHA_INICIO_TARIFA_L PARQUEADERO.TARIFA_MINUTO.FECHA_INICIO_TARIFA%TYPE;
    -- Códigos de error
    CODIGO_ERROR_L TEXT;
    RESUMEN_ERROR_L TEXT;
    MENSAJE_ERROR_L TEXT;
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
            -- Bloquea temporalmente las filas que se van a modificar en la tabla
            LOCK TABLE PARQUEADERO.TARIFA_MINUTO IN ROW EXCLUSIVE MODE;
            
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
            -- Bloquea temporalmente las filas que se van a modificar en la tabla
            LOCK TABLE PARQUEADERO.TARIFA_MINUTO IN ROW EXCLUSIVE MODE;
            
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
        RAISE EXCEPTION 'Inconsistencias en la BD: Hay más de una tarifa activa para la sucursal de PK: %', NEW.K_SUCURSAL;
    WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS 
            CODIGO_ERROR_L := RETURNED_SQLSTATE,
            RESUMEN_ERROR_L := MESSAGE_TEXT,
            MENSAJE_ERROR_L := PG_EXCEPTION_CONTEXT;
        RAISE EXCEPTION 'Código de error: % / Resumen del error: % / Mensaje de error: %', CODIGO_ERROR_L, RESUMEN_ERROR_L, MENSAJE_ERROR_L;
END;
$$;

COMMENT ON FUNCTION PARQUEADERO.ACTUALIZACION_TARIFA_TR IS E'Trigger que verifica que una sucursal solo tenga una tarifa activa.';

ALTER FUNCTION PARQUEADERO.ACTUALIZACION_TARIFA_TR OWNER TO PARKUD_DB_ADMIN ;

CREATE OR REPLACE TRIGGER ACTUALIZACION_TARIFA_TR
    BEFORE INSERT ON PARQUEADERO.TARIFA_MINUTO
    FOR EACH ROW
    EXECUTE FUNCTION PARQUEADERO.ACTUALIZACION_TARIFA_TR();


-- Trigger que verifica que una sucursal tenga los tipos de parqueaderos correspondientes.
CREATE OR REPLACE FUNCTION PARQUEADERO.VERIFICAR_TIPO_SUCURSAL_SLOT_TR()
RETURNS TRIGGER
LANGUAGE PLPGSQL
PARALLEL RESTRICTED
AS $$
DECLARE
    -- Declaración de variables locales
    TIPO_SUCURSAL_L PARQUEADERO.SUCURSAL.TIPO_SUCURSAL%TYPE;
BEGIN
    -- Recupera la clave primaria de la sucursal
    SELECT TIPO_SUCURSAL INTO STRICT TIPO_SUCURSAL_L
    FROM PARQUEADERO.SUCURSAL
    WHERE K_SUCURSAL = NEW.K_SUCURSAL;

    -- Verifica que las reglas de negocio se cumplan
    IF TIPO_SUCURSAL_L = 'Descubierta' AND NEW.ES_CUBIERTO = TRUE THEN
        RAISE EXCEPTION 'No se pueden insertar parqueaderos cubiertos para sucursales descubiertas.';
    ELSIF TIPO_SUCURSAL_L = 'Cubierta' AND NEW.ES_CUBIERTO = FALSE THEN
        RAISE EXCEPTION 'No se pueden insertar parqueaderos descubiertos para sucursales cubiertas.';
    END IF;

    -- Continúa con el INSERT
    RETURN NEW;
END;
$$;

COMMENT ON FUNCTION PARQUEADERO.VERIFICAR_TIPO_SUCURSAL_SLOT_TR IS E'Trigger que verifica que una sucursal tenga los tipos de parqueaderos correspondientes.';

ALTER FUNCTION PARQUEADERO.VERIFICAR_TIPO_SUCURSAL_SLOT_TR OWNER TO PARKUD_DB_ADMIN;

CREATE OR REPLACE TRIGGER VERIFICAR_TIPO_SUCURSAL_SLOT_TR
    BEFORE INSERT OR UPDATE ON PARQUEADERO.SLOT_PARQUEADERO
    FOR EACH ROW
    EXECUTE FUNCTION PARQUEADERO.VERIFICAR_TIPO_SUCURSAL_SLOT_TR();

CREATE OR REPLACE FUNCTION PARQUEADERO.VERIFICAR_PLACA_RESERVA_TR()
RETURNS TRIGGER
LANGUAGE PLPGSQL
PARALLEL RESTRICTED
AS $$
BEGIN
    -- Si la placa no está registrada en los vehículos del cliente
    IF NOT EXISTS (
        SELECT 1
        FROM PARQUEADERO.VEHICULO V
            INNER JOIN PARQUEADERO.CLIENTE C ON V.K_CLIENTE = C.K_CLIENTE
        WHERE V.PLACA_VEHICULO = NEW.PLACA_VEHICULO
            AND C.K_CLIENTE = NEW.K_CLIENTE
    ) THEN
        -- Devuelve una excepción
        RAISE EXCEPTION 'El cliente no tiene registrado un vehículo de placa %', NEW.PLACA_VEHICULO;
    END IF;

    -- Continúa con el INSERT o UPDATE
    RETURN NEW;
END;
$$;

COMMENT ON FUNCTION PARQUEADERO.VERIFICAR_PLACA_RESERVA_TR IS E'Trigger para verificar que la placa insertada en una reserva esté registrado en los vehículos del cliente.';

ALTER FUNCTION PARQUEADERO.VERIFICAR_PLACA_RESERVA_TR OWNER TO PARKUD_DB_ADMIN;

CREATE OR REPLACE TRIGGER VERIFICAR_PLACA_RESERVA_TR
    BEFORE INSERT ON PARQUEADERO.RESERVA
    FOR EACH ROW
    EXECUTE FUNCTION PARQUEADERO.VERIFICAR_PLACA_RESERVA_TR();


CREATE OR REPLACE FUNCTION PARQUEADERO.VERIFICAR_NUM_TARJETA_TR()
RETURNS TRIGGER
PARALLEL RESTRICTED
LANGUAGE PLPGSQL
AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM PARQUEADERO.TARJETA_PAGO T
            INNER JOIN PARQUEADERO.CLIENTE C ON T.K_CLIENTE = C.K_CLIENTE
        WHERE C.K_CLIENTE = NEW.K_CLIENTE
            AND PARQUEADERO.PGP_SYM_DECRYPT(NEW.NUMERO_TARJETA, 'AES_KEY') = PARQUEADERO.PGP_SYM_DECRYPT(T.NUMERO_TARJETA, 'AES_KEY')
    ) THEN 
        --Devuelve una excepción
        RAISE EXCEPTION 'Esta tarjeta ya está registrada.';
    END IF;

    -- Continúa con el INSERT o UPDATE
    RETURN NEW;
END;
$$;

COMMENT ON FUNCTION PARQUEADERO.VERIFICAR_NUM_TARJETA_TR IS E'Trigger que verifica que el número de tarjeta sea único por usuario.';

ALTER FUNCTION PARQUEADERO.VERIFICAR_NUM_TARJETA_TR OWNER TO PARKUD_DB_ADMIN;

CREATE OR REPLACE TRIGGER VERIFICAR_NUM_TARJETA_TR
    BEFORE INSERT OR UPDATE ON PARQUEADERO.TARJETA_PAGO
    FOR EACH ROW
    EXECUTE FUNCTION PARQUEADERO.VERIFICAR_NUM_TARJETA_TR();