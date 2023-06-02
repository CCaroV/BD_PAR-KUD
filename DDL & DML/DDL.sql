-- Database generated with pgModeler (PostgreSQL Database Modeler).
-- pgModeler version: 1.0.2
-- PostgreSQL version: 14.0
-- Project Site: pgmodeler.io
-- Model Author: ---
-- object: parkud_db_admin | type: ROLE --
-- DROP ROLE IF EXISTS parkud_db_admin;
CREATE ROLE parkud_db_admin WITH 
	CREATEROLE
	LOGIN
	 PASSWORD '20181020027';
-- ddl-end --
COMMENT ON ROLE parkud_db_admin IS E'El administrador de la base de datos de PAR-KUD.';
-- ddl-end --

-- object: admin_role | type: ROLE --
-- DROP ROLE IF EXISTS admin_role;
CREATE ROLE admin_role WITH 
	CREATEROLE;
-- ddl-end --
COMMENT ON ROLE admin_role IS E'Rol de administrador en la base de datos.';
-- ddl-end --

-- object: user_role | type: ROLE --
-- DROP ROLE IF EXISTS user_role;
CREATE ROLE user_role WITH ;
-- ddl-end --
COMMENT ON ROLE user_role IS E'Rol de un usuario del sistema.';
-- ddl-end --

-- object: manage_account_user | type: ROLE --
-- DROP ROLE IF EXISTS manage_account_user;
CREATE ROLE manage_account_user WITH 
	CREATEROLE
	LOGIN
	 PASSWORD 'CA1234';
-- ddl-end --
COMMENT ON ROLE manage_account_user IS E'Usuario utilizado solo para crear o eliminar las cuentas de los clientes con el rol user_role. No puede acceder a ninguna tabla y su única función es ejecutar un procedimiento de creación de usuario.';
-- ddl-end --

-- object: super_admin_role | type: ROLE --
-- DROP ROLE IF EXISTS super_admin_role;
CREATE ROLE super_admin_role WITH 
	CREATEROLE
	BYPASSRLS;
-- ddl-end --
COMMENT ON ROLE super_admin_role IS E'Rol de súper administrador en la base de datos.';
-- ddl-end --

-- object: operador_role | type: ROLE --
-- DROP ROLE IF EXISTS operador_role;
CREATE ROLE operador_role WITH ;
-- ddl-end --
COMMENT ON ROLE operador_role IS E'Rol de operador en la base de datos.';
-- ddl-end --


-- Database creation must be performed outside a multi lined SQL file. 
-- These commands were put in this file only as a convenience.
-- 
-- object: parkud_dbpg | type: DATABASE --
-- DROP DATABASE IF EXISTS parkud_dbpg;
CREATE DATABASE parkud_dbpg
	OWNER = parkud_db_admin;
-- ddl-end --
COMMENT ON DATABASE parkud_dbpg IS E'Base de datos relacional encargada de almacenar el sistema transaccional del SI de parqueaderos de PAR-KUD.';
-- ddl-end --


-- object: parqueadero | type: SCHEMA --
-- DROP SCHEMA IF EXISTS parqueadero CASCADE;
CREATE SCHEMA parqueadero;
-- ddl-end --
ALTER SCHEMA parqueadero OWNER TO parkud_db_admin;
-- ddl-end --
COMMENT ON SCHEMA parqueadero IS E'Esquema principal del SI de parqueaderos.';
-- ddl-end --

-- object: auditoria | type: SCHEMA --
-- DROP SCHEMA IF EXISTS auditoria CASCADE;
CREATE SCHEMA auditoria;
-- ddl-end --
ALTER SCHEMA auditoria OWNER TO parkud_db_admin;
-- ddl-end --
COMMENT ON SCHEMA auditoria IS E'Esquema de auditoría de la BD de parqueaderos.';
-- ddl-end --

SET search_path TO pg_catalog,public,parqueadero,auditoria;
-- ddl-end --

-- object: parqueadero.pais | type: TABLE --
-- DROP TABLE IF EXISTS parqueadero.pais CASCADE;
CREATE TABLE parqueadero.pais (
	k_pais varchar(3) NOT NULL,
	nombre_pais varchar(100) NOT NULL,
	CONSTRAINT pais_pk PRIMARY KEY (k_pais)
);
-- ddl-end --
COMMENT ON TABLE parqueadero.pais IS E'Tabla que almacena los países en que PAR-KUD tiene sucursales de parqueaderos.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.pais.k_pais IS E'Clave primaria de la tabla País, utilizando el estándar ISO 3166-1 alpha-3.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.pais.nombre_pais IS E'Nombre del país.';
-- ddl-end --
ALTER TABLE parqueadero.pais OWNER TO parkud_db_admin;
-- ddl-end --

-- object: parqueadero.departamento | type: TABLE --
-- DROP TABLE IF EXISTS parqueadero.departamento CASCADE;
CREATE TABLE parqueadero.departamento (
	k_departamento varchar(5) NOT NULL,
	k_pais varchar(3) NOT NULL,
	nombre_departamento varchar(100) NOT NULL,
	CONSTRAINT departamento_pk PRIMARY KEY (k_departamento)
);
-- ddl-end --
COMMENT ON TABLE parqueadero.departamento IS E'Los diferentes departamentos, estados, provincias, en los que se divide un país.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.departamento.k_departamento IS E'Clave primaria de la tabla Departamento.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.departamento.nombre_departamento IS E'Nombre del departamento, estado, provincia, entre otros.';
-- ddl-end --
ALTER TABLE parqueadero.departamento OWNER TO parkud_db_admin;
-- ddl-end --

-- object: parqueadero.ciudad | type: TABLE --
-- DROP TABLE IF EXISTS parqueadero.ciudad CASCADE;
CREATE TABLE parqueadero.ciudad (
	k_ciudad varchar(5) NOT NULL,
	k_departamento varchar(5) NOT NULL,
	nombre_ciudad varchar(100) NOT NULL,
	CONSTRAINT ciudad_pk PRIMARY KEY (k_ciudad)
);
-- ddl-end --
COMMENT ON TABLE parqueadero.ciudad IS E'Nombre de las diferentes ciudades, municipios, entre otros que un departamento puede tener.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.ciudad.k_ciudad IS E'Clave primaria de la tabla Ciudad.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.ciudad.nombre_ciudad IS E'Nombre de la ciudad, municipio, entre otros.';
-- ddl-end --
ALTER TABLE parqueadero.ciudad OWNER TO parkud_db_admin;
-- ddl-end --

-- object: pais_fk | type: CONSTRAINT --
-- ALTER TABLE parqueadero.departamento DROP CONSTRAINT IF EXISTS pais_fk CASCADE;
ALTER TABLE parqueadero.departamento ADD CONSTRAINT pais_fk FOREIGN KEY (k_pais)
REFERENCES parqueadero.pais (k_pais) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: departamento_fk | type: CONSTRAINT --
-- ALTER TABLE parqueadero.ciudad DROP CONSTRAINT IF EXISTS departamento_fk CASCADE;
ALTER TABLE parqueadero.ciudad ADD CONSTRAINT departamento_fk FOREIGN KEY (k_departamento)
REFERENCES parqueadero.departamento (k_departamento) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: parqueadero.sucursal | type: TABLE --
-- DROP TABLE IF EXISTS parqueadero.sucursal CASCADE;
CREATE TABLE parqueadero.sucursal (
	k_sucursal integer NOT NULL,
	k_direccion integer NOT NULL,
	nombre_sucursal varchar(50) NOT NULL,
	tipo_sucursal varchar(13) NOT NULL,
	tiempo_gracia_previo numeric(3) NOT NULL,
	tiempo_gracia_pos numeric(3) NOT NULL,
	CONSTRAINT sucursal_pk PRIMARY KEY (k_sucursal),
	CONSTRAINT tipo_sucursal_ck CHECK (tipo_sucursal in ('Cubierta', 'Semicubierta', 'Descubierta'))
);
-- ddl-end --
COMMENT ON TABLE parqueadero.sucursal IS E'Las diferentes sucursales con las que PAR-KUD cuenta.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.sucursal.k_sucursal IS E'Clave primaria de la tabla Sucursal.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.sucursal.nombre_sucursal IS E'El nombre de la sucursal.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.sucursal.tipo_sucursal IS E'Determina el tipo de sucursal.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.sucursal.tiempo_gracia_previo IS E'El tiempo de gracia previo a la reserva en minutos que un administrador determina para una sucursal.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.sucursal.tiempo_gracia_pos IS E'El tiempo de gracia pos a la reserva en minutos que un administrador determina para una sucursal.';
-- ddl-end --
COMMENT ON CONSTRAINT tipo_sucursal_ck ON parqueadero.sucursal IS E'Verifica que el tipo de sucursal se ajuste a las reglas de negocio.';
-- ddl-end --
ALTER TABLE parqueadero.sucursal OWNER TO parkud_db_admin;
-- ddl-end --

-- object: parqueadero.reserva | type: TABLE --
-- DROP TABLE IF EXISTS parqueadero.reserva CASCADE;
CREATE TABLE parqueadero.reserva (
	k_reserva bigint NOT NULL,
	k_cliente integer NOT NULL,
	k_promocion integer,
	k_fidelizacion integer,
	k_sucursal integer NOT NULL,
	k_slot_parqueadero varchar(5) NOT NULL,
	k_tarjeta_pago integer NOT NULL,
	fecha_reserva timestamp NOT NULL,
	fecha_inicio_reserva timestamp NOT NULL,
	puntos_usados numeric(8) NOT NULL,
	esta_activa boolean NOT NULL,
	placa_vehiculo varchar(7) NOT NULL,
	fecha_ingreso_vehiculo timestamp,
	fecha_salida_vehiculo timestamp,
	valor_reserva numeric(7,1),
	puntos_acumulados numeric(8),
	observaciones_reserva varchar(500),
	CONSTRAINT reserva_pk PRIMARY KEY (k_reserva),
	CONSTRAINT valor_reserva_ck CHECK (valor_reserva > 0),
	CONSTRAINT fecha_reserva_ck CHECK (fecha_inicio_reserva < fecha_salida_vehiculo)
);
-- ddl-end --
COMMENT ON TABLE parqueadero.reserva IS E'Las diferentes reservas que un cliente puede hacer de un parqueadero.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.reserva.k_reserva IS E'Clave primaria de la tabla Parqueadero.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.reserva.fecha_reserva IS E'Hora y fecha en que el usuario realizó la reserva.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.reserva.fecha_inicio_reserva IS E'Hora y fecha en que la reserva comienza.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.reserva.puntos_usados IS E'La cantidad de puntos que un cliente usó en una reserva.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.reserva.esta_activa IS E'Booleano que determina si la reserva está activa o no.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.reserva.placa_vehiculo IS E'La placa del vehículo que reservó.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.reserva.fecha_ingreso_vehiculo IS E'Determina la hora y fecha de ingreso del vehículo a la sucursal.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.reserva.fecha_salida_vehiculo IS E'Índica cuando el vehículo sale de la sucursal.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.reserva.valor_reserva IS E'Determina el valor total de la reserva.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.reserva.puntos_acumulados IS E'La cantidad de puntos que el cliente acumuló en la reserva.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.reserva.observaciones_reserva IS E'Observaciones generales de la reserva.';
-- ddl-end --
COMMENT ON CONSTRAINT valor_reserva_ck ON parqueadero.reserva IS E'Verifica que el valor de la reserva es un número positivo.';
-- ddl-end --
COMMENT ON CONSTRAINT fecha_reserva_ck ON parqueadero.reserva IS E'Verifica que las fechas de la reserva sean consistentes.';
-- ddl-end --
ALTER TABLE parqueadero.reserva OWNER TO parkud_db_admin;
-- ddl-end --
ALTER TABLE parqueadero.reserva ENABLE ROW LEVEL SECURITY;
-- ddl-end --

-- object: parqueadero.reserva_sq | type: SEQUENCE --
-- ALTER TABLE parqueadero.reserva DROP SEQUENCE IF EXISTS parqueadero.reserva_sq CASCADE;
CREATE SEQUENCE parqueadero.reserva_sq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	CYCLE
	OWNED BY parqueadero.reserva.k_reserva;

ALTER TABLE parqueadero.reserva ALTER COLUMN k_reserva
 SET DEFAULT nextval('parqueadero.reserva_sq'::regclass);
-- ddl-end --
ALTER SEQUENCE parqueadero.reserva_sq OWNER TO parkud_db_admin;
-- ddl-end --
COMMENT ON SEQUENCE parqueadero.reserva_sq IS E'Secuencia de clave primaria de la tabla Reserva.';
-- ddl-end --

-- object: parqueadero.slot_parqueadero | type: TABLE --
-- DROP TABLE IF EXISTS parqueadero.slot_parqueadero CASCADE;
CREATE TABLE parqueadero.slot_parqueadero (
	k_slot_parqueadero varchar(5) NOT NULL,
	k_sucursal integer NOT NULL,
	es_cubierto boolean NOT NULL,
	tipo_parqueadero varchar(9) NOT NULL,
	CONSTRAINT parqueadero_pk PRIMARY KEY (k_slot_parqueadero,k_sucursal),
	CONSTRAINT tipo_parqueadero_ck CHECK (tipo_parqueadero in ('SUV', 'Automóvil', 'Moto'))
);
-- ddl-end --
COMMENT ON TABLE parqueadero.slot_parqueadero IS E'Los diferentes parqueaderos que se encuentran en una sucursal.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.slot_parqueadero.k_slot_parqueadero IS E'Residuo de la tabla Parqueadero.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.slot_parqueadero.es_cubierto IS E'Determina si el parqueadero es cubierto o no.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.slot_parqueadero.tipo_parqueadero IS E'Determina qué vehículo puede guardarse en el parqueadero.';
-- ddl-end --
COMMENT ON CONSTRAINT tipo_parqueadero_ck ON parqueadero.slot_parqueadero IS E'Verifica que el tipo de parqueadero esté dentro de los valores establecidos en las reglas de negocio.';
-- ddl-end --
ALTER TABLE parqueadero.slot_parqueadero OWNER TO parkud_db_admin;
-- ddl-end --

-- object: sucursal_fk | type: CONSTRAINT --
-- ALTER TABLE parqueadero.slot_parqueadero DROP CONSTRAINT IF EXISTS sucursal_fk CASCADE;
ALTER TABLE parqueadero.slot_parqueadero ADD CONSTRAINT sucursal_fk FOREIGN KEY (k_sucursal)
REFERENCES parqueadero.sucursal (k_sucursal) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: parqueadero.cliente | type: TABLE --
-- DROP TABLE IF EXISTS parqueadero.cliente CASCADE;
CREATE TABLE parqueadero.cliente (
	k_cliente integer NOT NULL,
	tipo_identificacion_cliente varchar(3) NOT NULL,
	numero_identificacion_cliente varchar(12) NOT NULL,
	nombre1_cliente varchar(50) NOT NULL,
	nombre2_cliente varchar(50),
	apellido1_cliente varchar(50) NOT NULL,
	apellido2_cliente varchar(50),
	telefono_cliente numeric(10) NOT NULL,
	correo_cliente bytea NOT NULL,
	CONSTRAINT cliente_pk PRIMARY KEY (k_cliente),
	CONSTRAINT tipo_id_cliente_uq UNIQUE (tipo_identificacion_cliente,numero_identificacion_cliente),
	CONSTRAINT telefono_cliente_uq UNIQUE (telefono_cliente),
	CONSTRAINT correo_cliente_uq UNIQUE (correo_cliente),
	CONSTRAINT tipo_id_cliente_ck CHECK (tipo_identificacion_cliente in ('CC', 'CE', 'PAP'))
);
-- ddl-end --
COMMENT ON TABLE parqueadero.cliente IS E'Los clientes que reservan parqueaderos en el sistema.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.cliente.k_cliente IS E'Clave primaria de la tabla Cliente.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.cliente.tipo_identificacion_cliente IS E'Determina el tipo de identificación del cliente.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.cliente.numero_identificacion_cliente IS E'Número de identificación del cliente.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.cliente.nombre1_cliente IS E'Primer nombre del cliente.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.cliente.nombre2_cliente IS E'Segundo nombre del cliente.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.cliente.apellido1_cliente IS E'Primer apellido del cliente.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.cliente.apellido2_cliente IS E'Segundo apellido del cliente.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.cliente.telefono_cliente IS E'Número de teléfono o celular del cliente.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.cliente.correo_cliente IS E'Dirección de correo electrónico del cliente encriptada.';
-- ddl-end --
COMMENT ON CONSTRAINT tipo_id_cliente_uq ON parqueadero.cliente IS E'Verifica que el número de documento del cliente sea único respecto a su tipo de documento.';
-- ddl-end --
COMMENT ON CONSTRAINT telefono_cliente_uq ON parqueadero.cliente IS E'Verifica que el número de teléfono de un cliente no se repita.';
-- ddl-end --
COMMENT ON CONSTRAINT correo_cliente_uq ON parqueadero.cliente IS E'Verifica que el correo de un cliente no se repita.';
-- ddl-end --
COMMENT ON CONSTRAINT tipo_id_cliente_ck ON parqueadero.cliente IS E'Verifica que el tipo de identificación es válido de acuerdo a la normatividad colombiana.';
-- ddl-end --
ALTER TABLE parqueadero.cliente OWNER TO parkud_db_admin;
-- ddl-end --
ALTER TABLE parqueadero.cliente ENABLE ROW LEVEL SECURITY;
-- ddl-end --

-- object: cliente_fk | type: CONSTRAINT --
-- ALTER TABLE parqueadero.reserva DROP CONSTRAINT IF EXISTS cliente_fk CASCADE;
ALTER TABLE parqueadero.reserva ADD CONSTRAINT cliente_fk FOREIGN KEY (k_cliente)
REFERENCES parqueadero.cliente (k_cliente) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: parqueadero.cliente_sq | type: SEQUENCE --
-- ALTER TABLE parqueadero.cliente DROP SEQUENCE IF EXISTS parqueadero.cliente_sq CASCADE;
CREATE SEQUENCE parqueadero.cliente_sq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	CYCLE
	OWNED BY parqueadero.cliente.k_cliente;

ALTER TABLE parqueadero.cliente ALTER COLUMN k_cliente
 SET DEFAULT nextval('parqueadero.cliente_sq'::regclass);
-- ddl-end --
ALTER SEQUENCE parqueadero.cliente_sq OWNER TO parkud_db_admin;
-- ddl-end --
COMMENT ON SEQUENCE parqueadero.cliente_sq IS E'Consecutivo de la clave primaria de la tabla Cliente.';
-- ddl-end --

-- object: parqueadero.direccion | type: TABLE --
-- DROP TABLE IF EXISTS parqueadero.direccion CASCADE;
CREATE TABLE parqueadero.direccion (
	k_direccion integer NOT NULL,
	k_ciudad varchar(5) NOT NULL,
	nombre_direccion varchar(200) NOT NULL,
	edificio_direccion varchar(200) NOT NULL,
	codigo_postal varchar(6) NOT NULL,
	CONSTRAINT direccion_pk PRIMARY KEY (k_direccion)
);
-- ddl-end --
COMMENT ON TABLE parqueadero.direccion IS E'Índica la dirección en la que una sucursal se encuentra.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.direccion.k_direccion IS E'Clave primaria de la tabla Dirección.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.direccion.nombre_direccion IS E'El nombre de la dirección con calle, carrera, diagonal, transversal, entre otros.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.direccion.edificio_direccion IS E'Indica el edificio, centro comercial, entre otros establecimientos en la que la sucursal se encuentra establecida.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.direccion.codigo_postal IS E'El código postal de la dirección.';
-- ddl-end --
ALTER TABLE parqueadero.direccion OWNER TO parkud_db_admin;
-- ddl-end --

-- object: ciudad_fk | type: CONSTRAINT --
-- ALTER TABLE parqueadero.direccion DROP CONSTRAINT IF EXISTS ciudad_fk CASCADE;
ALTER TABLE parqueadero.direccion ADD CONSTRAINT ciudad_fk FOREIGN KEY (k_ciudad)
REFERENCES parqueadero.ciudad (k_ciudad) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: direccion_fk | type: CONSTRAINT --
-- ALTER TABLE parqueadero.sucursal DROP CONSTRAINT IF EXISTS direccion_fk CASCADE;
ALTER TABLE parqueadero.sucursal ADD CONSTRAINT direccion_fk FOREIGN KEY (k_direccion)
REFERENCES parqueadero.direccion (k_direccion) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: sucursal_uq | type: CONSTRAINT --
-- ALTER TABLE parqueadero.sucursal DROP CONSTRAINT IF EXISTS sucursal_uq CASCADE;
ALTER TABLE parqueadero.sucursal ADD CONSTRAINT sucursal_uq UNIQUE (k_direccion);
-- ddl-end --

-- object: parqueadero.tarifa_minuto | type: TABLE --
-- DROP TABLE IF EXISTS parqueadero.tarifa_minuto CASCADE;
CREATE TABLE parqueadero.tarifa_minuto (
	k_tarifa_minuto integer NOT NULL,
	k_sucursal integer NOT NULL,
	valor_minuto_suv numeric(5,1) NOT NULL,
	valor_minuto_auto numeric(5,1) NOT NULL,
	valor_minuto_moto numeric(5,1) NOT NULL,
	adicion_parq_cubierto numeric(5,1) NOT NULL,
	valor_multa_cancelacion numeric(6,1) NOT NULL,
	fecha_inicio_tarifa timestamp NOT NULL,
	fecha_fin_tarifa timestamp,
	esta_activa boolean NOT NULL,
	CONSTRAINT tarifa_minuto_pk PRIMARY KEY (k_tarifa_minuto),
	CONSTRAINT valor_tarifa_ck CHECK (valor_minuto_suv >= 0 and valor_minuto_auto >= 0 and valor_minuto_moto >= 0),
	CONSTRAINT fecha_tarifa_ck CHECK (fecha_inicio_tarifa < fecha_fin_tarifa)
);
-- ddl-end --
COMMENT ON TABLE parqueadero.tarifa_minuto IS E'Tarifa cobrada por minuto en una sucursal.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.tarifa_minuto.k_tarifa_minuto IS E'Clave primaria de la tabla Tarifa Minuto';
-- ddl-end --
COMMENT ON COLUMN parqueadero.tarifa_minuto.valor_minuto_suv IS E'Valor a pagar por vehículo de tipo SUV. Si es cero significa que la sucursal no tiene parqueaderos de este tipo.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.tarifa_minuto.valor_minuto_auto IS E'Valor a pagar por vehículo de tipo automóvil. Si es cero significa que la sucursal no tiene parqueaderos de este tipo.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.tarifa_minuto.valor_minuto_moto IS E'Valor a pagar por vehículo de tipo moto. Si es cero significa que la sucursal no tiene parqueaderos de este tipo.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.tarifa_minuto.adicion_parq_cubierto IS E'Valor adicional a pagar por parqueaderos cubiertos.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.tarifa_minuto.valor_multa_cancelacion IS E'El valor a pagar por cancelar una reserva.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.tarifa_minuto.fecha_inicio_tarifa IS E'Fecha de inicio en que la tarifa se encuentra activa.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.tarifa_minuto.fecha_fin_tarifa IS E'Indica la fecha final en que la tarifa se encuentra activa.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.tarifa_minuto.esta_activa IS E'Determina si la tarifa actual se encuentra activa o no.';
-- ddl-end --
COMMENT ON CONSTRAINT valor_tarifa_ck ON parqueadero.tarifa_minuto IS E'Verifica que los valores por tarifa de cada tipo de vehículo son números positivos.';
-- ddl-end --
COMMENT ON CONSTRAINT fecha_tarifa_ck ON parqueadero.tarifa_minuto IS E'Verifica que las fechas de las tarifas sean consistentes.';
-- ddl-end --
ALTER TABLE parqueadero.tarifa_minuto OWNER TO parkud_db_admin;
-- ddl-end --

-- object: sucursal_fk | type: CONSTRAINT --
-- ALTER TABLE parqueadero.tarifa_minuto DROP CONSTRAINT IF EXISTS sucursal_fk CASCADE;
ALTER TABLE parqueadero.tarifa_minuto ADD CONSTRAINT sucursal_fk FOREIGN KEY (k_sucursal)
REFERENCES parqueadero.sucursal (k_sucursal) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: parqueadero.horario_sucursal | type: TABLE --
-- DROP TABLE IF EXISTS parqueadero.horario_sucursal CASCADE;
CREATE TABLE parqueadero.horario_sucursal (
	k_horario_sucursal integer NOT NULL,
	k_sucursal integer NOT NULL,
	k_dia_semana varchar(9) NOT NULL,
	hora_abierto_sucursal time,
	hora_cerrado_sucursal time,
	es_horario_completo boolean NOT NULL,
	es_cerrado_completo boolean NOT NULL,
	CONSTRAINT horario_sucursal_pk PRIMARY KEY (k_horario_sucursal,k_sucursal)
);
-- ddl-end --
COMMENT ON TABLE parqueadero.horario_sucursal IS E'Determina el horario de una sucursal. El horario puede variar todos los días.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.horario_sucursal.k_horario_sucursal IS E'Residuo de la tabla Horario Sucursal.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.horario_sucursal.hora_abierto_sucursal IS E'Índica la hora en que la sucursal abre. Si ese día atienden 24/7 este valor será nulo.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.horario_sucursal.hora_cerrado_sucursal IS E'Índica la hora en que la sucursal abre. Si ese día atienden 24/7 este valor será nulo.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.horario_sucursal.es_horario_completo IS E'Determina si para un día de la semana atienden 24/7.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.horario_sucursal.es_cerrado_completo IS E'Determina si para un día de la semana la sucursal no abre.';
-- ddl-end --
ALTER TABLE parqueadero.horario_sucursal OWNER TO parkud_db_admin;
-- ddl-end --

-- object: parqueadero.dia_semana | type: TABLE --
-- DROP TABLE IF EXISTS parqueadero.dia_semana CASCADE;
CREATE TABLE parqueadero.dia_semana (
	k_dia_semana varchar(9) NOT NULL,
	CONSTRAINT dia_semana_pk PRIMARY KEY (k_dia_semana),
	CONSTRAINT dia_semana_ck CHECK (k_dia_semana in ('Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'))
);
-- ddl-end --
COMMENT ON TABLE parqueadero.dia_semana IS E'Almacena el día de la semana.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.dia_semana.k_dia_semana IS E'Clave primaria de la tabla Día Semana. También almacena el día de la semana.';
-- ddl-end --
COMMENT ON CONSTRAINT dia_semana_ck ON parqueadero.dia_semana IS E'Verifica que solo se puedan almacenar los días de la semana.';
-- ddl-end --
ALTER TABLE parqueadero.dia_semana OWNER TO parkud_db_admin;
-- ddl-end --

-- object: sucursal_fk | type: CONSTRAINT --
-- ALTER TABLE parqueadero.horario_sucursal DROP CONSTRAINT IF EXISTS sucursal_fk CASCADE;
ALTER TABLE parqueadero.horario_sucursal ADD CONSTRAINT sucursal_fk FOREIGN KEY (k_sucursal)
REFERENCES parqueadero.sucursal (k_sucursal) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: dia_semana_fk | type: CONSTRAINT --
-- ALTER TABLE parqueadero.horario_sucursal DROP CONSTRAINT IF EXISTS dia_semana_fk CASCADE;
ALTER TABLE parqueadero.horario_sucursal ADD CONSTRAINT dia_semana_fk FOREIGN KEY (k_dia_semana)
REFERENCES parqueadero.dia_semana (k_dia_semana) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: parqueadero.horario_empleado | type: TABLE --
-- DROP TABLE IF EXISTS parqueadero.horario_empleado CASCADE;
CREATE TABLE parqueadero.horario_empleado (
	k_horario_empleado integer NOT NULL,
	k_empleado integer NOT NULL,
	k_dia_semana varchar(9) NOT NULL,
	hora_entrada time,
	hora_salida time,
	es_dia_descanso boolean NOT NULL,
	CONSTRAINT horario_empleado_pk PRIMARY KEY (k_horario_empleado,k_empleado)
);
-- ddl-end --
COMMENT ON TABLE parqueadero.horario_empleado IS E'Almacena el horario de un empleado por día.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.horario_empleado.k_horario_empleado IS E'Discriminante de la tabla Horario Empleado';
-- ddl-end --
COMMENT ON COLUMN parqueadero.horario_empleado.hora_entrada IS E'Determina la hora de entrada al turno. Si es nulo es porque es el día libre del empleado.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.horario_empleado.hora_salida IS E'Determina la hora de salida al turno. Si es nulo es porque es el día libre del empleado.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.horario_empleado.es_dia_descanso IS E'Determina si es el día de descanso del empleado.';
-- ddl-end --
ALTER TABLE parqueadero.horario_empleado OWNER TO parkud_db_admin;
-- ddl-end --

-- object: parqueadero.empleado | type: TABLE --
-- DROP TABLE IF EXISTS parqueadero.empleado CASCADE;
CREATE TABLE parqueadero.empleado (
	k_empleado integer NOT NULL,
	tipo_identificacion_empleado varchar(3) NOT NULL,
	numero_identificacion_emp varchar(12) NOT NULL,
	nombre1_empleado varchar(50) NOT NULL,
	nombre2_empleado varchar(50),
	apellido1_empleado varchar(50) NOT NULL,
	apellido2_empleado varchar(50),
	telefono_empleado numeric(10) NOT NULL,
	correo_empleado bytea NOT NULL,
	CONSTRAINT empleado_pk PRIMARY KEY (k_empleado),
	CONSTRAINT tipo_id_empleado_uq UNIQUE (tipo_identificacion_empleado,numero_identificacion_emp),
	CONSTRAINT telefono_empleado_uq UNIQUE (telefono_empleado),
	CONSTRAINT correo_empleado_uq UNIQUE (correo_empleado),
	CONSTRAINT tipo_id_empleado_ck CHECK (tipo_identificacion_empleado in ('PEP', 'CE', 'CC', 'PPT'))
);
-- ddl-end --
COMMENT ON TABLE parqueadero.empleado IS E'Empleado que trabaja en una o varias sucursales.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.empleado.k_empleado IS E'Clave primaria de la tabla Empleado.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.empleado.tipo_identificacion_empleado IS E'Determina el tipo de identificación del empleado, CC, PPT, PEP o CE.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.empleado.numero_identificacion_emp IS E'El número de identificación del empleado.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.empleado.nombre1_empleado IS E'Primer nombre del empleado.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.empleado.nombre2_empleado IS E'Segundo nombre del empleado.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.empleado.apellido1_empleado IS E'Primer apellido del empleado.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.empleado.apellido2_empleado IS E'Segundo apellido del empleado.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.empleado.telefono_empleado IS E'Número de celular del empleado.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.empleado.correo_empleado IS E'Correo electrónico del empleado.';
-- ddl-end --
COMMENT ON CONSTRAINT tipo_id_empleado_uq ON parqueadero.empleado IS E'Verifica que el número de documento del empleado sea único respecto a su tipo de documento.';
-- ddl-end --
COMMENT ON CONSTRAINT telefono_empleado_uq ON parqueadero.empleado IS E'Verifica que el número de teléfono de un empleado no se repita.';
-- ddl-end --
COMMENT ON CONSTRAINT correo_empleado_uq ON parqueadero.empleado IS E'Verifica que el correo de un empleado no se repita.';
-- ddl-end --
COMMENT ON CONSTRAINT tipo_id_empleado_ck ON parqueadero.empleado IS E'Verifica que el tipo de identificación es válido de acuerdo a la normatividad colombiana.';
-- ddl-end --
ALTER TABLE parqueadero.empleado OWNER TO parkud_db_admin;
-- ddl-end --
ALTER TABLE parqueadero.empleado ENABLE ROW LEVEL SECURITY;
-- ddl-end --

-- object: parqueadero.trabaja | type: TABLE --
-- DROP TABLE IF EXISTS parqueadero.trabaja CASCADE;
CREATE TABLE parqueadero.trabaja (
	k_sucursal integer NOT NULL,
	k_empleado integer NOT NULL,
	CONSTRAINT trabaja_pk PRIMARY KEY (k_sucursal,k_empleado)
);
-- ddl-end --
COMMENT ON TABLE parqueadero.trabaja IS E'Tabla de rompimiento entre Empleado y Sucursal.';
-- ddl-end --
ALTER TABLE parqueadero.trabaja OWNER TO parkud_db_admin;
-- ddl-end --

-- object: sucursal_fk | type: CONSTRAINT --
-- ALTER TABLE parqueadero.trabaja DROP CONSTRAINT IF EXISTS sucursal_fk CASCADE;
ALTER TABLE parqueadero.trabaja ADD CONSTRAINT sucursal_fk FOREIGN KEY (k_sucursal)
REFERENCES parqueadero.sucursal (k_sucursal) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: empleado_fk | type: CONSTRAINT --
-- ALTER TABLE parqueadero.trabaja DROP CONSTRAINT IF EXISTS empleado_fk CASCADE;
ALTER TABLE parqueadero.trabaja ADD CONSTRAINT empleado_fk FOREIGN KEY (k_empleado)
REFERENCES parqueadero.empleado (k_empleado) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: dia_semana_fk | type: CONSTRAINT --
-- ALTER TABLE parqueadero.horario_empleado DROP CONSTRAINT IF EXISTS dia_semana_fk CASCADE;
ALTER TABLE parqueadero.horario_empleado ADD CONSTRAINT dia_semana_fk FOREIGN KEY (k_dia_semana)
REFERENCES parqueadero.dia_semana (k_dia_semana) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: parqueadero.cargo | type: TABLE --
-- DROP TABLE IF EXISTS parqueadero.cargo CASCADE;
CREATE TABLE parqueadero.cargo (
	k_nombre_cargo varchar(30) NOT NULL,
	CONSTRAINT cargo_pk PRIMARY KEY (k_nombre_cargo)
);
-- ddl-end --
COMMENT ON TABLE parqueadero.cargo IS E'Los diferentes cargos que una sucursal tiene.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.cargo.k_nombre_cargo IS E'Nombre del cargo.';
-- ddl-end --
ALTER TABLE parqueadero.cargo OWNER TO parkud_db_admin;
-- ddl-end --

-- object: parqueadero.ejerce | type: TABLE --
-- DROP TABLE IF EXISTS parqueadero.ejerce CASCADE;
CREATE TABLE parqueadero.ejerce (
	k_empleado integer NOT NULL,
	k_nombre_cargo varchar(30) NOT NULL,
	fecha_inicio_cargo date NOT NULL,
	fecha_fin_cargo date,
	es_cargo_activo boolean NOT NULL,
	CONSTRAINT ejerce_pk PRIMARY KEY (k_nombre_cargo,k_empleado),
	CONSTRAINT fecha_ejerce_ck CHECK (fecha_inicio_cargo < fecha_fin_cargo)
);
-- ddl-end --
COMMENT ON TABLE parqueadero.ejerce IS E'Tabla de rompimiento entre Cargo y Empleado.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.ejerce.fecha_inicio_cargo IS E'Fecha de inicio del cargo.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.ejerce.fecha_fin_cargo IS E'Fecha final del cargo.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.ejerce.es_cargo_activo IS E'Determina si es el cargo es el que actualmente está desempeñando el empleado.';
-- ddl-end --
COMMENT ON CONSTRAINT fecha_ejerce_ck ON parqueadero.ejerce IS E'Verifica que las fechas de ejercer un cargo sean consistentes.';
-- ddl-end --
ALTER TABLE parqueadero.ejerce OWNER TO parkud_db_admin;
-- ddl-end --

-- object: cargo_fk | type: CONSTRAINT --
-- ALTER TABLE parqueadero.ejerce DROP CONSTRAINT IF EXISTS cargo_fk CASCADE;
ALTER TABLE parqueadero.ejerce ADD CONSTRAINT cargo_fk FOREIGN KEY (k_nombre_cargo)
REFERENCES parqueadero.cargo (k_nombre_cargo) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: empleado_fk | type: CONSTRAINT --
-- ALTER TABLE parqueadero.ejerce DROP CONSTRAINT IF EXISTS empleado_fk CASCADE;
ALTER TABLE parqueadero.ejerce ADD CONSTRAINT empleado_fk FOREIGN KEY (k_empleado)
REFERENCES parqueadero.empleado (k_empleado) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: parqueadero.promocion | type: TABLE --
-- DROP TABLE IF EXISTS parqueadero.promocion CASCADE;
CREATE TABLE parqueadero.promocion (
	k_promocion integer NOT NULL,
	k_sucursal integer NOT NULL,
	fecha_promocion timestamp NOT NULL,
	fecha_activa_desde timestamp NOT NULL,
	fecha_activa_hasta timestamp NOT NULL,
	descripcion_promocion varchar(500) NOT NULL,
	CONSTRAINT promocion_pk PRIMARY KEY (k_promocion),
	CONSTRAINT fecha_promocion_ck CHECK (fecha_activa_desde < fecha_activa_hasta)
);
-- ddl-end --
COMMENT ON TABLE parqueadero.promocion IS E'Promociones de puntos de fidelización que una sucursal puede ofrecer.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.promocion.k_promocion IS E'Clave primaria de la tabla Promoción.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.promocion.fecha_promocion IS E'Fecha en que la promoción fue creada.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.promocion.fecha_activa_desde IS E'Indica la fecha de inicio en que la promoción tiene validez.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.promocion.fecha_activa_hasta IS E'Indica hasta cuando la promoción tiene validez.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.promocion.descripcion_promocion IS E'Breve descripción de la promoción.';
-- ddl-end --
COMMENT ON CONSTRAINT fecha_promocion_ck ON parqueadero.promocion IS E'Verifica que las fechas de una promoción sean consistentes.';
-- ddl-end --
ALTER TABLE parqueadero.promocion OWNER TO parkud_db_admin;
-- ddl-end --

-- object: sucursal_fk | type: CONSTRAINT --
-- ALTER TABLE parqueadero.promocion DROP CONSTRAINT IF EXISTS sucursal_fk CASCADE;
ALTER TABLE parqueadero.promocion ADD CONSTRAINT sucursal_fk FOREIGN KEY (k_sucursal)
REFERENCES parqueadero.sucursal (k_sucursal) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: parqueadero.promocion_por_tiempo | type: TABLE --
-- DROP TABLE IF EXISTS parqueadero.promocion_por_tiempo CASCADE;
CREATE TABLE parqueadero.promocion_por_tiempo (
	k_promocion integer NOT NULL,
	puntos_por_minuto numeric(8) NOT NULL,
	adicion_minutos_suv numeric(8) NOT NULL,
	adicion_minutos_auto numeric(8) NOT NULL,
	adicion_minutos_moto numeric(8) NOT NULL,
	adicion_parq_cubierto numeric(8) NOT NULL,
	adicion_parq_descubierto numeric(8) NOT NULL,
	CONSTRAINT promocion_por_tiempo_pk PRIMARY KEY (k_promocion)
);
-- ddl-end --
COMMENT ON TABLE parqueadero.promocion_por_tiempo IS E'Promoción que da puntos de fidelización por tiempo reservado.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.promocion_por_tiempo.puntos_por_minuto IS E'Indica cuántos puntos por minuto otorga la promoción.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.promocion_por_tiempo.adicion_minutos_suv IS E'Indica la adición de puntos por minuto correspondiente por parquear usando un SUV.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.promocion_por_tiempo.adicion_minutos_auto IS E'Indica la adición de puntos por minuto correspondiente por parquear usando un auto.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.promocion_por_tiempo.adicion_minutos_moto IS E'Indica la adición de puntos por minuto correspondiente por parquear usando una moto.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.promocion_por_tiempo.adicion_parq_cubierto IS E'Indica la adición de puntos por minuto correspondiente por parquear en un slot cubierto.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.promocion_por_tiempo.adicion_parq_descubierto IS E'Indica la adición de puntos por minuto correspondiente por parquear en un slot descubierto.';
-- ddl-end --
ALTER TABLE parqueadero.promocion_por_tiempo OWNER TO parkud_db_admin;
-- ddl-end --

-- object: promocion_fk | type: CONSTRAINT --
-- ALTER TABLE parqueadero.promocion_por_tiempo DROP CONSTRAINT IF EXISTS promocion_fk CASCADE;
ALTER TABLE parqueadero.promocion_por_tiempo ADD CONSTRAINT promocion_fk FOREIGN KEY (k_promocion)
REFERENCES parqueadero.promocion (k_promocion) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: parqueadero.promocion_por_reserva | type: TABLE --
-- DROP TABLE IF EXISTS parqueadero.promocion_por_reserva CASCADE;
CREATE TABLE parqueadero.promocion_por_reserva (
	k_promocion integer NOT NULL,
	puntos_por_reserva numeric(8) NOT NULL,
	adicion_reserva_suv numeric(8) NOT NULL,
	adicion_reserva_auto numeric(8) NOT NULL,
	adicion_reserva_moto numeric(8) NOT NULL,
	adicion_parq_cubierto numeric(8) NOT NULL,
	adicion_parq_descubierto numeric(8) NOT NULL,
	CONSTRAINT promocion_por_reserva_pk PRIMARY KEY (k_promocion)
);
-- ddl-end --
COMMENT ON TABLE parqueadero.promocion_por_reserva IS E'Promoción que da puntos de fidelización por reservar un parqueadero.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.promocion_por_reserva.puntos_por_reserva IS E'Los puntos acumulados por reservar.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.promocion_por_reserva.adicion_reserva_suv IS E'Indica la adición correspondiente por reservar usando un SUV.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.promocion_por_reserva.adicion_reserva_auto IS E'Indica la adición correspondiente por reservar usando un automóvil.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.promocion_por_reserva.adicion_reserva_moto IS E'Indica la adición correspondiente por reservar usando una moto.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.promocion_por_reserva.adicion_parq_cubierto IS E'Indica la adición correspondiente por reservar en un slot cubierto.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.promocion_por_reserva.adicion_parq_descubierto IS E'Indica la adición correspondiente por reservar en un slot descubierto.';
-- ddl-end --
ALTER TABLE parqueadero.promocion_por_reserva OWNER TO parkud_db_admin;
-- ddl-end --

-- object: promocion_fk | type: CONSTRAINT --
-- ALTER TABLE parqueadero.promocion_por_reserva DROP CONSTRAINT IF EXISTS promocion_fk CASCADE;
ALTER TABLE parqueadero.promocion_por_reserva ADD CONSTRAINT promocion_fk FOREIGN KEY (k_promocion)
REFERENCES parqueadero.promocion (k_promocion) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: parqueadero.tarjeta_pago | type: TABLE --
-- DROP TABLE IF EXISTS parqueadero.tarjeta_pago CASCADE;
CREATE TABLE parqueadero.tarjeta_pago (
	k_tarjeta_pago integer NOT NULL,
	k_cliente integer NOT NULL,
	nombre_duenio_tarjeta bytea NOT NULL,
	apellido_duenio_tarjeta bytea NOT NULL,
	numero_tarjeta bytea NOT NULL,
	ultimos_cuatro_digitos bytea NOT NULL,
	mes_vencimiento bytea NOT NULL,
	anio_vencimiento bytea NOT NULL,
	tipo_tarjeta bytea NOT NULL,
	CONSTRAINT tarjeta_pago_pk PRIMARY KEY (k_tarjeta_pago)
);
-- ddl-end --
COMMENT ON TABLE parqueadero.tarjeta_pago IS E'Las diferentes tarjetas que un cliente puede tener asociadas.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.tarjeta_pago.k_tarjeta_pago IS E'Clave primaria de la tabla Tarjeta Pago.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.tarjeta_pago.nombre_duenio_tarjeta IS E'El nombre que aparece en la tarjeta.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.tarjeta_pago.apellido_duenio_tarjeta IS E'El apellido que aparece en la tarjeta.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.tarjeta_pago.numero_tarjeta IS E'El número de la tarjeta, encriptado.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.tarjeta_pago.ultimos_cuatro_digitos IS E'Los últimos cuatro dígitos de la tarjeta, encriptados.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.tarjeta_pago.mes_vencimiento IS E'El mes en que vence la tarjeta, encriptado.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.tarjeta_pago.anio_vencimiento IS E'El año en que vence la tarjeta, encriptado.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.tarjeta_pago.tipo_tarjeta IS E'Determina si la tarjeta es Mastercard, Visa, Discover, Amex, Diners, entre otros.';
-- ddl-end --
ALTER TABLE parqueadero.tarjeta_pago OWNER TO parkud_db_admin;
-- ddl-end --
ALTER TABLE parqueadero.tarjeta_pago ENABLE ROW LEVEL SECURITY;
-- ddl-end --

-- object: cliente_fk | type: CONSTRAINT --
-- ALTER TABLE parqueadero.tarjeta_pago DROP CONSTRAINT IF EXISTS cliente_fk CASCADE;
ALTER TABLE parqueadero.tarjeta_pago ADD CONSTRAINT cliente_fk FOREIGN KEY (k_cliente)
REFERENCES parqueadero.cliente (k_cliente) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: parqueadero.vehiculo | type: TABLE --
-- DROP TABLE IF EXISTS parqueadero.vehiculo CASCADE;
CREATE TABLE parqueadero.vehiculo (
	k_vehiculo integer NOT NULL,
	k_marca_vehiculo varchar(40) NOT NULL,
	k_cliente integer NOT NULL,
	placa_vehiculo varchar(7) NOT NULL,
	nombre1_propietario varchar NOT NULL,
	nombre2_propietario varchar(50),
	apellido1_propietario varchar(50) NOT NULL,
	apellido2_propietario varchar(50),
	tipo_vehiculo varchar(10) NOT NULL,
	color_vehiculo varchar(20) NOT NULL,
	CONSTRAINT vehiculo_pk PRIMARY KEY (k_vehiculo),
	CONSTRAINT tipo_vehiculo_ck CHECK (tipo_vehiculo in ('SUV', 'Automóvil', 'Moto'))
);
-- ddl-end --
COMMENT ON TABLE parqueadero.vehiculo IS E'Los vehículos que un cliente parquea en una sucursal.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.vehiculo.k_vehiculo IS E'Clave primaria de la tabla Vehículo.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.vehiculo.placa_vehiculo IS E'Placa del vehículo.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.vehiculo.nombre1_propietario IS E'Primer nombre de la persona que aparece en la tarjeta de propiedad del vehículo.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.vehiculo.nombre2_propietario IS E'Segundo nombre de la persona que aparece en la tarjeta de propiedad del vehículo.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.vehiculo.apellido1_propietario IS E'Primer apellido de la persona que aparece en la tarjeta de propiedad del vehículo.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.vehiculo.apellido2_propietario IS E'Segundo apellido de la persona que aparece en la tarjeta de propiedad del vehículo.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.vehiculo.tipo_vehiculo IS E'Determina el tipo de vehículo: SUV, automóvil o moto.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.vehiculo.color_vehiculo IS E'Determina el color del vehículo.';
-- ddl-end --
COMMENT ON CONSTRAINT tipo_vehiculo_ck ON parqueadero.vehiculo IS E'Verifica que el tipo de vehículo se corresponde con las reglas de negocio.';
-- ddl-end --
ALTER TABLE parqueadero.vehiculo OWNER TO parkud_db_admin;
-- ddl-end --
ALTER TABLE parqueadero.vehiculo ENABLE ROW LEVEL SECURITY;
-- ddl-end --

-- object: parqueadero.marca_vehiculo | type: TABLE --
-- DROP TABLE IF EXISTS parqueadero.marca_vehiculo CASCADE;
CREATE TABLE parqueadero.marca_vehiculo (
	k_marca_vehiculo varchar(40) NOT NULL,
	CONSTRAINT marca_vehiculo_pk PRIMARY KEY (k_marca_vehiculo)
);
-- ddl-end --
COMMENT ON TABLE parqueadero.marca_vehiculo IS E'Tabla que almacena las principales marcas de vehículos en el mundo.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.marca_vehiculo.k_marca_vehiculo IS E'Clave primaria de la tabla Marca Vehículo, se corresponde con el nombre de la marca.';
-- ddl-end --
ALTER TABLE parqueadero.marca_vehiculo OWNER TO parkud_db_admin;
-- ddl-end --

-- object: marca_vehiculo_fk | type: CONSTRAINT --
-- ALTER TABLE parqueadero.vehiculo DROP CONSTRAINT IF EXISTS marca_vehiculo_fk CASCADE;
ALTER TABLE parqueadero.vehiculo ADD CONSTRAINT marca_vehiculo_fk FOREIGN KEY (k_marca_vehiculo)
REFERENCES parqueadero.marca_vehiculo (k_marca_vehiculo) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: cliente_fk | type: CONSTRAINT --
-- ALTER TABLE parqueadero.vehiculo DROP CONSTRAINT IF EXISTS cliente_fk CASCADE;
ALTER TABLE parqueadero.vehiculo ADD CONSTRAINT cliente_fk FOREIGN KEY (k_cliente)
REFERENCES parqueadero.cliente (k_cliente) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: depto_pais_ixfk | type: INDEX --
-- DROP INDEX IF EXISTS parqueadero.depto_pais_ixfk CASCADE;
CREATE INDEX depto_pais_ixfk ON parqueadero.departamento
USING btree
(
	k_pais ASC NULLS LAST
);
-- ddl-end --
COMMENT ON INDEX parqueadero.depto_pais_ixfk IS E'Índice de la llave foránea de la tabla País.';
-- ddl-end --

-- object: ciudad_dpto_ixkf | type: INDEX --
-- DROP INDEX IF EXISTS parqueadero.ciudad_dpto_ixkf CASCADE;
CREATE INDEX ciudad_dpto_ixkf ON parqueadero.ciudad
USING btree
(
	k_departamento ASC NULLS LAST
);
-- ddl-end --
COMMENT ON INDEX parqueadero.ciudad_dpto_ixkf IS E'Índice de la llave foránea de la tabla Departamento.';
-- ddl-end --

-- object: tarifa_sucursal_ixfk | type: INDEX --
-- DROP INDEX IF EXISTS parqueadero.tarifa_sucursal_ixfk CASCADE;
CREATE INDEX tarifa_sucursal_ixfk ON parqueadero.tarifa_minuto
USING btree
(
	k_sucursal ASC NULLS LAST
);
-- ddl-end --
COMMENT ON INDEX parqueadero.tarifa_sucursal_ixfk IS E'Índice de la llave foránea de la tabla Sucursal.';
-- ddl-end --

-- object: horario_sucursal_dia_ixfk | type: INDEX --
-- DROP INDEX IF EXISTS parqueadero.horario_sucursal_dia_ixfk CASCADE;
CREATE INDEX horario_sucursal_dia_ixfk ON parqueadero.horario_sucursal
USING btree
(
	k_dia_semana ASC NULLS LAST
);
-- ddl-end --
COMMENT ON INDEX parqueadero.horario_sucursal_dia_ixfk IS E'Índice de la llave foránea de la tabla Día Semana.';
-- ddl-end --

-- object: horario_emp_dia_ixfk | type: INDEX --
-- DROP INDEX IF EXISTS parqueadero.horario_emp_dia_ixfk CASCADE;
CREATE INDEX horario_emp_dia_ixfk ON parqueadero.horario_empleado
USING btree
(
	k_dia_semana ASC NULLS LAST
);
-- ddl-end --
COMMENT ON INDEX parqueadero.horario_emp_dia_ixfk IS E'Índice de la llave foránea de la tabla Día Semana.';
-- ddl-end --

-- object: promocion_sucursal_ixfk | type: INDEX --
-- DROP INDEX IF EXISTS parqueadero.promocion_sucursal_ixfk CASCADE;
CREATE INDEX promocion_sucursal_ixfk ON parqueadero.promocion
USING btree
(
	k_sucursal ASC NULLS LAST
);
-- ddl-end --
COMMENT ON INDEX parqueadero.promocion_sucursal_ixfk IS E'Índice de la llave foránea de la tabla Sucursal.';
-- ddl-end --

-- object: marca_vehiculo_ixkf | type: INDEX --
-- DROP INDEX IF EXISTS parqueadero.marca_vehiculo_ixkf CASCADE;
CREATE INDEX marca_vehiculo_ixkf ON parqueadero.vehiculo
USING btree
(
	k_marca_vehiculo ASC NULLS LAST
);
-- ddl-end --
COMMENT ON INDEX parqueadero.marca_vehiculo_ixkf IS E'Índice de la llave foránea de la tabla Marca Vehículo.';
-- ddl-end --

-- object: vehiculo_cliente_ixfk | type: INDEX --
-- DROP INDEX IF EXISTS parqueadero.vehiculo_cliente_ixfk CASCADE;
CREATE INDEX vehiculo_cliente_ixfk ON parqueadero.vehiculo
USING btree
(
	k_cliente ASC NULLS LAST
);
-- ddl-end --
COMMENT ON INDEX parqueadero.vehiculo_cliente_ixfk IS E'Índice de la llave foránea de la tabla Cliente.';
-- ddl-end --

-- object: tarjeta_cliente_ixfk | type: INDEX --
-- DROP INDEX IF EXISTS parqueadero.tarjeta_cliente_ixfk CASCADE;
CREATE INDEX tarjeta_cliente_ixfk ON parqueadero.tarjeta_pago
USING btree
(
	k_cliente ASC NULLS LAST
);
-- ddl-end --
COMMENT ON INDEX parqueadero.tarjeta_cliente_ixfk IS E'Índice de la llave foránea de la tabla Cliente.';
-- ddl-end --

-- object: direccion_ciudad_ixfk | type: INDEX --
-- DROP INDEX IF EXISTS parqueadero.direccion_ciudad_ixfk CASCADE;
CREATE INDEX direccion_ciudad_ixfk ON parqueadero.direccion
USING btree
(
	k_ciudad ASC NULLS LAST
);
-- ddl-end --
COMMENT ON INDEX parqueadero.direccion_ciudad_ixfk IS E'Índice de la llave foránea de la tabla Ciudad.';
-- ddl-end --

-- object: parqueadero.fidelizacion_cliente | type: TABLE --
-- DROP TABLE IF EXISTS parqueadero.fidelizacion_cliente CASCADE;
CREATE TABLE parqueadero.fidelizacion_cliente (
	k_fidelizacion integer NOT NULL,
	k_cliente integer NOT NULL,
	cantidad_puntos numeric(8) NOT NULL,
	fecha_inicio_puntaje timestamp NOT NULL,
	fecha_fin_puntaje timestamp,
	es_actual boolean NOT NULL,
	CONSTRAINT fidelizacion_cliente_pk PRIMARY KEY (k_fidelizacion)
);
-- ddl-end --
COMMENT ON TABLE parqueadero.fidelizacion_cliente IS E'Almacena los datos de fidelización de un cliente.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.fidelizacion_cliente.k_fidelizacion IS E'Clave primaria de la tabla Fidelización Cliente.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.fidelizacion_cliente.cantidad_puntos IS E'Determina la cantidad de puntos que el cliente tiene.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.fidelizacion_cliente.fecha_inicio_puntaje IS E'Fecha de inicio del puntaje almacenado.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.fidelizacion_cliente.fecha_fin_puntaje IS E'Fecha en que el puntaje cambia por uno distinto y se genera un nuevo registro en la BD.';
-- ddl-end --
COMMENT ON COLUMN parqueadero.fidelizacion_cliente.es_actual IS E'Determina si el puntaje de la tupla es el que se encuentra activo para el cliente.';
-- ddl-end --
ALTER TABLE parqueadero.fidelizacion_cliente OWNER TO parkud_db_admin;
-- ddl-end --
ALTER TABLE parqueadero.fidelizacion_cliente ENABLE ROW LEVEL SECURITY;
-- ddl-end --

-- object: promocion_fk | type: CONSTRAINT --
-- ALTER TABLE parqueadero.reserva DROP CONSTRAINT IF EXISTS promocion_fk CASCADE;
ALTER TABLE parqueadero.reserva ADD CONSTRAINT promocion_fk FOREIGN KEY (k_promocion)
REFERENCES parqueadero.promocion (k_promocion) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: cliente_fk | type: CONSTRAINT --
-- ALTER TABLE parqueadero.fidelizacion_cliente DROP CONSTRAINT IF EXISTS cliente_fk CASCADE;
ALTER TABLE parqueadero.fidelizacion_cliente ADD CONSTRAINT cliente_fk FOREIGN KEY (k_cliente)
REFERENCES parqueadero.cliente (k_cliente) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: fidelizacion_cliente_fk | type: CONSTRAINT --
-- ALTER TABLE parqueadero.reserva DROP CONSTRAINT IF EXISTS fidelizacion_cliente_fk CASCADE;
ALTER TABLE parqueadero.reserva ADD CONSTRAINT fidelizacion_cliente_fk FOREIGN KEY (k_fidelizacion)
REFERENCES parqueadero.fidelizacion_cliente (k_fidelizacion) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: auditoria.audit_vehiculo | type: TABLE --
-- DROP TABLE IF EXISTS auditoria.audit_vehiculo CASCADE;
CREATE TABLE auditoria.audit_vehiculo (
	k_auditoria_vehiculo integer NOT NULL,
	k_cliente integer NOT NULL,
	k_vehiculo integer,
	placa_vehiculo varchar(7) NOT NULL,
	fecha_audit_vehiculo timestamp NOT NULL,
	tipo_vehiculo_audit varchar(10) NOT NULL,
	tipo_transaccion_vehiculo varchar(20) NOT NULL,
	nombre_usuario_vehiculo varchar(200) NOT NULL,
	CONSTRAINT vehiculo_pk PRIMARY KEY (k_auditoria_vehiculo),
	CONSTRAINT tipo_vehiculo_audit_ck CHECK (tipo_vehiculo_audit in ('SUV', 'Automóvil', 'Moto')),
	CONSTRAINT tipo_transaccion_vehiculo_ck CHECK (tipo_transaccion_vehiculo in ('Modificación', 'Eliminación', 'Agregar'))
);
-- ddl-end --
COMMENT ON TABLE auditoria.audit_vehiculo IS E'Tabla de aditoría para la tabla Vehículo del esquema Parqueadero.';
-- ddl-end --
COMMENT ON COLUMN auditoria.audit_vehiculo.k_auditoria_vehiculo IS E'Clave primaria de la tabla Auditoría Vehículo.';
-- ddl-end --
COMMENT ON COLUMN auditoria.audit_vehiculo.placa_vehiculo IS E'La placa del vehículo auditado.';
-- ddl-end --
COMMENT ON COLUMN auditoria.audit_vehiculo.fecha_audit_vehiculo IS E'Fecha y hora en la que se hace auditoría del vehículo.';
-- ddl-end --
COMMENT ON COLUMN auditoria.audit_vehiculo.tipo_vehiculo_audit IS E'Tipo de vehículo al que se le hizo auditoría.';
-- ddl-end --
COMMENT ON COLUMN auditoria.audit_vehiculo.tipo_transaccion_vehiculo IS E'El tipo de transacción que fue auditada.';
-- ddl-end --
COMMENT ON COLUMN auditoria.audit_vehiculo.nombre_usuario_vehiculo IS E'Nombre de usuario que hizo la transacción.';
-- ddl-end --
COMMENT ON CONSTRAINT tipo_vehiculo_audit_ck ON auditoria.audit_vehiculo IS E'Verifica que el tipo de vehículo esté dentro de los valores admitidos.';
-- ddl-end --
COMMENT ON CONSTRAINT tipo_transaccion_vehiculo_ck ON auditoria.audit_vehiculo IS E'Verifica que los tipos de transacción de la tabla Vehículo del esquema Auditoría sean válidos.';
-- ddl-end --
ALTER TABLE auditoria.audit_vehiculo OWNER TO parkud_db_admin;
-- ddl-end --

-- object: vehiculo_fk | type: CONSTRAINT --
-- ALTER TABLE auditoria.audit_vehiculo DROP CONSTRAINT IF EXISTS vehiculo_fk CASCADE;
ALTER TABLE auditoria.audit_vehiculo ADD CONSTRAINT vehiculo_fk FOREIGN KEY (k_vehiculo)
REFERENCES parqueadero.vehiculo (k_vehiculo) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: cliente_fk | type: CONSTRAINT --
-- ALTER TABLE auditoria.audit_vehiculo DROP CONSTRAINT IF EXISTS cliente_fk CASCADE;
ALTER TABLE auditoria.audit_vehiculo ADD CONSTRAINT cliente_fk FOREIGN KEY (k_cliente)
REFERENCES parqueadero.cliente (k_cliente) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: auditoria.audit_usuario | type: TABLE --
-- DROP TABLE IF EXISTS auditoria.audit_usuario CASCADE;
CREATE TABLE auditoria.audit_usuario (
	k_auditoria_usuario integer NOT NULL,
	k_empleado integer,
	k_cliente integer,
	nombre_usuario varchar(200) NOT NULL,
	direccion_ip varchar(39) NOT NULL,
	fecha_audit_usuario timestamp NOT NULL,
	tipo_transaccion_cliente varchar(20) NOT NULL,
	CONSTRAINT usuario_pk PRIMARY KEY (k_auditoria_usuario),
	CONSTRAINT tipo_transaccion_cliente_ck CHECK (tipo_transaccion_cliente IN ('Ingreso', 'Registro'))
);
-- ddl-end --
COMMENT ON TABLE auditoria.audit_usuario IS E'Tabla encargada de auditar los inicios de sesión realizados por los usuarios.';
-- ddl-end --
COMMENT ON COLUMN auditoria.audit_usuario.k_auditoria_usuario IS E'Clave primaria de la tabla Auditoría Usuario';
-- ddl-end --
COMMENT ON COLUMN auditoria.audit_usuario.nombre_usuario IS E'Nombre de usuario auditado.';
-- ddl-end --
COMMENT ON COLUMN auditoria.audit_usuario.direccion_ip IS E'Dirección IP (IPv4 o IPv6) desde donde el usuario inició sesión.';
-- ddl-end --
COMMENT ON COLUMN auditoria.audit_usuario.fecha_audit_usuario IS E'Fecha y hora en que se hizo la auditoría.';
-- ddl-end --
COMMENT ON COLUMN auditoria.audit_usuario.tipo_transaccion_cliente IS E'Valor que identifica la transacción que hizo el cliente auditado.';
-- ddl-end --
COMMENT ON CONSTRAINT tipo_transaccion_cliente_ck ON auditoria.audit_usuario IS E'Verifica que el tipo de transacción del cliente esté dentro de los rangos válidos.';
-- ddl-end --
ALTER TABLE auditoria.audit_usuario OWNER TO parkud_db_admin;
-- ddl-end --

-- object: empleado_fk | type: CONSTRAINT --
-- ALTER TABLE auditoria.audit_usuario DROP CONSTRAINT IF EXISTS empleado_fk CASCADE;
ALTER TABLE auditoria.audit_usuario ADD CONSTRAINT empleado_fk FOREIGN KEY (k_empleado)
REFERENCES parqueadero.empleado (k_empleado) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: cliente_fk | type: CONSTRAINT --
-- ALTER TABLE auditoria.audit_usuario DROP CONSTRAINT IF EXISTS cliente_fk CASCADE;
ALTER TABLE auditoria.audit_usuario ADD CONSTRAINT cliente_fk FOREIGN KEY (k_cliente)
REFERENCES parqueadero.cliente (k_cliente) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: auditoria.audit_reserva | type: TABLE --
-- DROP TABLE IF EXISTS auditoria.audit_reserva CASCADE;
CREATE TABLE auditoria.audit_reserva (
	k_auditoria_reserva bigint NOT NULL,
	k_reserva bigint NOT NULL,
	k_cliente integer NOT NULL,
	k_sucursal integer NOT NULL,
	fecha_audit_reserva timestamp NOT NULL,
	ciudad_audit_reserva varchar(100) NOT NULL,
	sucursal_audit_reserva varchar(50) NOT NULL,
	tipo_vehiculo_reserva varchar(9) NOT NULL,
	tipo_transaccion_reserva varchar(12) NOT NULL,
	nombre_usuario_reserva varchar(200) NOT NULL,
	CONSTRAINT reserva_pk PRIMARY KEY (k_auditoria_reserva),
	CONSTRAINT tipo_vehiculo_reserva_audit_ck CHECK (tipo_vehiculo_reserva in ('SUV', 'Automóvil', 'Moto')),
	CONSTRAINT tipo_transaccion_reserva_ck CHECK (tipo_transaccion_reserva in ('Creación','Modificación', 'Eliminación', 'Cancelación'))
);
-- ddl-end --
COMMENT ON COLUMN auditoria.audit_reserva.k_auditoria_reserva IS E'Clave primaria de la tabla Auditoría Reserva.';
-- ddl-end --
COMMENT ON COLUMN auditoria.audit_reserva.fecha_audit_reserva IS E'Fecha y hora en que se auditó la reserva.';
-- ddl-end --
COMMENT ON COLUMN auditoria.audit_reserva.ciudad_audit_reserva IS E'Ciudad en que se hizo la reserva auditada.';
-- ddl-end --
COMMENT ON COLUMN auditoria.audit_reserva.sucursal_audit_reserva IS E'Nombre de la sucursal en que la reserva fue auditada.';
-- ddl-end --
COMMENT ON COLUMN auditoria.audit_reserva.tipo_vehiculo_reserva IS E'Tipo de vehículo que participó en la reserva auditada.';
-- ddl-end --
COMMENT ON COLUMN auditoria.audit_reserva.tipo_transaccion_reserva IS E'Determina el tipo de transacción de la reserva auditada.';
-- ddl-end --
COMMENT ON COLUMN auditoria.audit_reserva.nombre_usuario_reserva IS E'Nombre del usuario que hizo la transacción de la reserva auditada.';
-- ddl-end --
COMMENT ON CONSTRAINT tipo_vehiculo_reserva_audit_ck ON auditoria.audit_reserva IS E'Verifica que el valor de tipo de vehículo sea válido.';
-- ddl-end --
COMMENT ON CONSTRAINT tipo_transaccion_reserva_ck ON auditoria.audit_reserva IS E'Verifica que el valor del tipo de transacción de la tabla de reserva sea válido.';
-- ddl-end --
ALTER TABLE auditoria.audit_reserva OWNER TO parkud_db_admin;
-- ddl-end --

-- object: reserva_fk | type: CONSTRAINT --
-- ALTER TABLE auditoria.audit_reserva DROP CONSTRAINT IF EXISTS reserva_fk CASCADE;
ALTER TABLE auditoria.audit_reserva ADD CONSTRAINT reserva_fk FOREIGN KEY (k_reserva)
REFERENCES parqueadero.reserva (k_reserva) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: cliente_fk | type: CONSTRAINT --
-- ALTER TABLE auditoria.audit_reserva DROP CONSTRAINT IF EXISTS cliente_fk CASCADE;
ALTER TABLE auditoria.audit_reserva ADD CONSTRAINT cliente_fk FOREIGN KEY (k_cliente)
REFERENCES parqueadero.cliente (k_cliente) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: sucursal_fk | type: CONSTRAINT --
-- ALTER TABLE auditoria.audit_reserva DROP CONSTRAINT IF EXISTS sucursal_fk CASCADE;
ALTER TABLE auditoria.audit_reserva ADD CONSTRAINT sucursal_fk FOREIGN KEY (k_sucursal)
REFERENCES parqueadero.sucursal (k_sucursal) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: slot_parqueadero_fk | type: CONSTRAINT --
-- ALTER TABLE parqueadero.reserva DROP CONSTRAINT IF EXISTS slot_parqueadero_fk CASCADE;
ALTER TABLE parqueadero.reserva ADD CONSTRAINT slot_parqueadero_fk FOREIGN KEY (k_slot_parqueadero,k_sucursal)
REFERENCES parqueadero.slot_parqueadero (k_slot_parqueadero,k_sucursal) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: fidelizacion_cliente_ixfk | type: INDEX --
-- DROP INDEX IF EXISTS parqueadero.fidelizacion_cliente_ixfk CASCADE;
CREATE INDEX fidelizacion_cliente_ixfk ON parqueadero.fidelizacion_cliente
USING btree
(
	k_cliente ASC NULLS LAST
);
-- ddl-end --
COMMENT ON INDEX parqueadero.fidelizacion_cliente_ixfk IS E'Índice de la llave foránea de la tabla Cliente.';
-- ddl-end --

-- object: reserva_cliente_ixfk | type: INDEX --
-- DROP INDEX IF EXISTS parqueadero.reserva_cliente_ixfk CASCADE;
CREATE INDEX reserva_cliente_ixfk ON parqueadero.reserva
USING btree
(
	k_cliente ASC NULLS LAST
);
-- ddl-end --
COMMENT ON INDEX parqueadero.reserva_cliente_ixfk IS E'Índice de la llave foránea de la tabla Cliente.';
-- ddl-end --

-- object: reserva_promocion_ixkf | type: INDEX --
-- DROP INDEX IF EXISTS parqueadero.reserva_promocion_ixkf CASCADE;
CREATE INDEX reserva_promocion_ixkf ON parqueadero.reserva
USING btree
(
	k_promocion ASC NULLS LAST
);
-- ddl-end --
COMMENT ON INDEX parqueadero.reserva_promocion_ixkf IS E'Índice de la llave foránea de la tabla Promoción.';
-- ddl-end --

-- object: reserva_fidelizacion_ixfk | type: INDEX --
-- DROP INDEX IF EXISTS parqueadero.reserva_fidelizacion_ixfk CASCADE;
CREATE INDEX reserva_fidelizacion_ixfk ON parqueadero.reserva
USING btree
(
	k_fidelizacion ASC NULLS LAST
);
-- ddl-end --
COMMENT ON INDEX parqueadero.reserva_fidelizacion_ixfk IS E'Índice de la llave foránea de la tabla Fidelización Cliente.';
-- ddl-end --

-- object: reserva_sucursal_slot_ixfk | type: INDEX --
-- DROP INDEX IF EXISTS parqueadero.reserva_sucursal_slot_ixfk CASCADE;
CREATE INDEX reserva_sucursal_slot_ixfk ON parqueadero.reserva
USING btree
(
	k_slot_parqueadero ASC NULLS LAST,
	k_sucursal ASC NULLS LAST
);
-- ddl-end --
COMMENT ON INDEX parqueadero.reserva_sucursal_slot_ixfk IS E'Índice de la llave foránea de la tabla Slot Parqueadero.';
-- ddl-end --

-- object: auditusuario_empleado_ixfk | type: INDEX --
-- DROP INDEX IF EXISTS auditoria.auditusuario_empleado_ixfk CASCADE;
CREATE INDEX auditusuario_empleado_ixfk ON auditoria.audit_usuario
USING btree
(
	k_empleado ASC NULLS LAST
);
-- ddl-end --
COMMENT ON INDEX auditoria.auditusuario_empleado_ixfk IS E'Índice de la llave foránea de la tabla Empelado del esquema Parqueadero.';
-- ddl-end --

-- object: auditusuario_cliente_ixfk | type: INDEX --
-- DROP INDEX IF EXISTS auditoria.auditusuario_cliente_ixfk CASCADE;
CREATE INDEX auditusuario_cliente_ixfk ON auditoria.audit_usuario
USING btree
(
	k_cliente ASC NULLS LAST
);
-- ddl-end --
COMMENT ON INDEX auditoria.auditusuario_cliente_ixfk IS E'Índice de la llave foránea de la tabla Cliente del esquema Parqueadero.';
-- ddl-end --

-- object: auditreserva_reserva_ixfk | type: INDEX --
-- DROP INDEX IF EXISTS auditoria.auditreserva_reserva_ixfk CASCADE;
CREATE INDEX auditreserva_reserva_ixfk ON auditoria.audit_reserva
USING btree
(
	k_reserva ASC NULLS LAST
);
-- ddl-end --
COMMENT ON INDEX auditoria.auditreserva_reserva_ixfk IS E'Índice de la llave foránea de la tabla Reserva del esquema Parqueadero.';
-- ddl-end --

-- object: auditreserva_cliente_ixfk | type: INDEX --
-- DROP INDEX IF EXISTS auditoria.auditreserva_cliente_ixfk CASCADE;
CREATE INDEX auditreserva_cliente_ixfk ON auditoria.audit_reserva
USING btree
(
	k_cliente ASC NULLS LAST
);
-- ddl-end --
COMMENT ON INDEX auditoria.auditreserva_cliente_ixfk IS E'Índice de la llave foránea de la tabla Cliente del esquema Parqueadero.';
-- ddl-end --

-- object: auditreserva_sucursal | type: INDEX --
-- DROP INDEX IF EXISTS auditoria.auditreserva_sucursal CASCADE;
CREATE INDEX auditreserva_sucursal ON auditoria.audit_reserva
USING btree
(
	k_sucursal ASC NULLS LAST
);
-- ddl-end --
COMMENT ON INDEX auditoria.auditreserva_sucursal IS E'Índice de la llave foránea de la tabla Sucursal del esquema Parqueadero.';
-- ddl-end --

-- object: pgcrypto | type: EXTENSION --
-- DROP EXTENSION IF EXISTS pgcrypto CASCADE;
CREATE EXTENSION pgcrypto
WITH SCHEMA parqueadero;
-- ddl-end --
COMMENT ON EXTENSION pgcrypto IS E'Extensión que permite hacer encriptaciones en la base de datos.';
-- ddl-end --

-- object: placa_cliente_uq | type: CONSTRAINT --
-- ALTER TABLE parqueadero.vehiculo DROP CONSTRAINT IF EXISTS placa_cliente_uq CASCADE;
ALTER TABLE parqueadero.vehiculo ADD CONSTRAINT placa_cliente_uq UNIQUE (k_cliente,placa_vehiculo);
-- ddl-end --
COMMENT ON CONSTRAINT placa_cliente_uq ON parqueadero.vehiculo IS E'Verifica que un cliente no tenga dos veces el mismo vehículo.';
-- ddl-end --


-- object: auditvehiculo_vehiculo_ixfk | type: INDEX --
-- DROP INDEX IF EXISTS auditoria.auditvehiculo_vehiculo_ixfk CASCADE;
CREATE INDEX auditvehiculo_vehiculo_ixfk ON auditoria.audit_vehiculo
USING btree
(
	k_vehiculo ASC NULLS LAST
);
-- ddl-end --
COMMENT ON INDEX auditoria.auditvehiculo_vehiculo_ixfk IS E'Índice de la llave foránea de la tabla Vehículo del esquema Parqueadero.';
-- ddl-end --

-- object: parqueadero.vehiculo_sq | type: SEQUENCE --
-- ALTER TABLE parqueadero.vehiculo DROP SEQUENCE IF EXISTS parqueadero.vehiculo_sq CASCADE;
CREATE SEQUENCE parqueadero.vehiculo_sq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	CYCLE
	OWNED BY parqueadero.vehiculo.k_vehiculo;

ALTER TABLE parqueadero.vehiculo ALTER COLUMN k_vehiculo
 SET DEFAULT nextval('parqueadero.vehiculo_sq'::regclass);
-- ddl-end --
ALTER SEQUENCE parqueadero.vehiculo_sq OWNER TO parkud_db_admin;
-- ddl-end --
COMMENT ON SEQUENCE parqueadero.vehiculo_sq IS E'Secuencia asociada a la tabla Vehículo.';
-- ddl-end --

-- object: parqueadero.fidelizacion_sq | type: SEQUENCE --
-- ALTER TABLE parqueadero.fidelizacion_cliente DROP SEQUENCE IF EXISTS parqueadero.fidelizacion_sq CASCADE;
CREATE SEQUENCE parqueadero.fidelizacion_sq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	CYCLE
	OWNED BY parqueadero.fidelizacion_cliente.k_fidelizacion;

ALTER TABLE parqueadero.fidelizacion_cliente ALTER COLUMN k_fidelizacion
 SET DEFAULT nextval('parqueadero.fidelizacion_sq'::regclass);
-- ddl-end --
ALTER SEQUENCE parqueadero.fidelizacion_sq OWNER TO parkud_db_admin;
-- ddl-end --
COMMENT ON SEQUENCE parqueadero.fidelizacion_sq IS E'Secuencia asociada a la tabla Fidelización Cliente.';
-- ddl-end --

-- object: parqueadero.promocion_sq | type: SEQUENCE --
-- ALTER TABLE parqueadero.promocion DROP SEQUENCE IF EXISTS parqueadero.promocion_sq CASCADE;
CREATE SEQUENCE parqueadero.promocion_sq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	CYCLE
	OWNED BY parqueadero.promocion.k_promocion;

ALTER TABLE parqueadero.promocion ALTER COLUMN k_promocion
 SET DEFAULT nextval('parqueadero.promocion_sq'::regclass);
-- ddl-end --
ALTER SEQUENCE parqueadero.promocion_sq OWNER TO parkud_db_admin;
-- ddl-end --
COMMENT ON SEQUENCE parqueadero.promocion_sq IS E'Secuencia asociada a la tabla Promoción.';
-- ddl-end --

-- object: parqueadero.sucursal_sq | type: SEQUENCE --
-- ALTER TABLE parqueadero.sucursal DROP SEQUENCE IF EXISTS parqueadero.sucursal_sq CASCADE;
CREATE SEQUENCE parqueadero.sucursal_sq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	CYCLE
	OWNED BY parqueadero.sucursal.k_sucursal;

ALTER TABLE parqueadero.sucursal ALTER COLUMN k_sucursal
 SET DEFAULT nextval('parqueadero.sucursal_sq'::regclass);
-- ddl-end --
ALTER SEQUENCE parqueadero.sucursal_sq OWNER TO parkud_db_admin;
-- ddl-end --
COMMENT ON SEQUENCE parqueadero.sucursal_sq IS E'Secuencia asociada a la tabla Sucursal.';
-- ddl-end --

-- object: parqueadero.tarifa_minuto_sq | type: SEQUENCE --
-- ALTER TABLE parqueadero.tarifa_minuto DROP SEQUENCE IF EXISTS parqueadero.tarifa_minuto_sq CASCADE;
CREATE SEQUENCE parqueadero.tarifa_minuto_sq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	CYCLE
	OWNED BY parqueadero.tarifa_minuto.k_tarifa_minuto;

ALTER TABLE parqueadero.tarifa_minuto ALTER COLUMN k_tarifa_minuto
 SET DEFAULT nextval('parqueadero.tarifa_minuto_sq'::regclass);
-- ddl-end --
ALTER SEQUENCE parqueadero.tarifa_minuto_sq OWNER TO parkud_db_admin;
-- ddl-end --
COMMENT ON SEQUENCE parqueadero.tarifa_minuto_sq IS E'Secuencia asociada a la tabla Tarifa Minuto.';
-- ddl-end --

-- object: parqueadero.direccion_sq | type: SEQUENCE --
-- ALTER TABLE parqueadero.direccion DROP SEQUENCE IF EXISTS parqueadero.direccion_sq CASCADE;
CREATE SEQUENCE parqueadero.direccion_sq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	CYCLE
	OWNED BY parqueadero.direccion.k_direccion;

ALTER TABLE parqueadero.direccion ALTER COLUMN k_direccion
 SET DEFAULT nextval('parqueadero.direccion_sq'::regclass);
-- ddl-end --
ALTER SEQUENCE parqueadero.direccion_sq OWNER TO parkud_db_admin;
-- ddl-end --
COMMENT ON SEQUENCE parqueadero.direccion_sq IS E'Secuencia asociada a la tabla Dirección.';
-- ddl-end --

-- object: parqueadero.empleado_sq | type: SEQUENCE --
-- ALTER TABLE parqueadero.empleado DROP SEQUENCE IF EXISTS parqueadero.empleado_sq CASCADE;
CREATE SEQUENCE parqueadero.empleado_sq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	CYCLE
	OWNED BY parqueadero.empleado.k_empleado;

ALTER TABLE parqueadero.empleado ALTER COLUMN k_empleado
 SET DEFAULT nextval('parqueadero.empleado_sq'::regclass);
-- ddl-end --
ALTER SEQUENCE parqueadero.empleado_sq OWNER TO parkud_db_admin;
-- ddl-end --
COMMENT ON SEQUENCE parqueadero.empleado_sq IS E'Secuencia asociada a la tabla Empleado.';
-- ddl-end --

-- object: parqueadero.tarjeta_pago_sq | type: SEQUENCE --
-- ALTER TABLE parqueadero.tarjeta_pago DROP SEQUENCE IF EXISTS parqueadero.tarjeta_pago_sq CASCADE;
CREATE SEQUENCE parqueadero.tarjeta_pago_sq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	CYCLE
	OWNED BY parqueadero.tarjeta_pago.k_tarjeta_pago;

ALTER TABLE parqueadero.tarjeta_pago ALTER COLUMN k_tarjeta_pago
 SET DEFAULT nextval('parqueadero.tarjeta_pago_sq'::regclass);
-- ddl-end --
ALTER SEQUENCE parqueadero.tarjeta_pago_sq OWNER TO parkud_db_admin;
-- ddl-end --
COMMENT ON SEQUENCE parqueadero.tarjeta_pago_sq IS E'Secuencia asociada a la tabla Tarjeta Pago.';
-- ddl-end --

-- object: parqueadero.horario_sucursal_sq | type: SEQUENCE --
-- ALTER TABLE parqueadero.horario_sucursal DROP SEQUENCE IF EXISTS parqueadero.horario_sucursal_sq CASCADE;
CREATE SEQUENCE parqueadero.horario_sucursal_sq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	CYCLE
	OWNED BY parqueadero.horario_sucursal.k_horario_sucursal;

ALTER TABLE parqueadero.horario_sucursal ALTER COLUMN k_horario_sucursal
 SET DEFAULT nextval('parqueadero.horario_sucursal_sq'::regclass);
-- ddl-end --
ALTER SEQUENCE parqueadero.horario_sucursal_sq OWNER TO parkud_db_admin;
-- ddl-end --
COMMENT ON SEQUENCE parqueadero.horario_sucursal_sq IS E'Secuencia asociada a la tabla Horario Sucursal.';
-- ddl-end --

-- object: auditoria.vehiculo_sq | type: SEQUENCE --
-- ALTER TABLE auditoria.audit_vehiculo DROP SEQUENCE IF EXISTS auditoria.vehiculo_sq CASCADE;
CREATE SEQUENCE auditoria.vehiculo_sq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	CYCLE
	OWNED BY auditoria.audit_vehiculo.k_auditoria_vehiculo;

ALTER TABLE auditoria.audit_vehiculo ALTER COLUMN k_auditoria_vehiculo
 SET DEFAULT nextval('auditoria.vehiculo_sq'::regclass);
-- ddl-end --
ALTER SEQUENCE auditoria.vehiculo_sq OWNER TO parkud_db_admin;
-- ddl-end --
COMMENT ON SEQUENCE auditoria.vehiculo_sq IS E'Secuencia asociada a la tabla Vehículo.';
-- ddl-end --

-- object: auditoria.usuario_sq | type: SEQUENCE --
-- ALTER TABLE auditoria.audit_usuario DROP SEQUENCE IF EXISTS auditoria.usuario_sq CASCADE;
CREATE SEQUENCE auditoria.usuario_sq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	CYCLE
	OWNED BY auditoria.audit_usuario.k_auditoria_usuario;

ALTER TABLE auditoria.audit_usuario ALTER COLUMN k_auditoria_usuario
 SET DEFAULT nextval('auditoria.usuario_sq'::regclass);
-- ddl-end --
ALTER SEQUENCE auditoria.usuario_sq OWNER TO parkud_db_admin;
-- ddl-end --
COMMENT ON SEQUENCE auditoria.usuario_sq IS E'Secuencia asociada a la tabla Usuario.';
-- ddl-end --

-- object: auditoria.reserva_sq | type: SEQUENCE --
-- ALTER TABLE auditoria.audit_reserva DROP SEQUENCE IF EXISTS auditoria.reserva_sq CASCADE;
CREATE SEQUENCE auditoria.reserva_sq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	CYCLE
	OWNED BY auditoria.audit_reserva.k_auditoria_reserva;

ALTER TABLE auditoria.audit_reserva ALTER COLUMN k_auditoria_reserva
 SET DEFAULT nextval('auditoria.reserva_sq'::regclass);
-- ddl-end --
ALTER SEQUENCE auditoria.reserva_sq OWNER TO parkud_db_admin;
-- ddl-end --
COMMENT ON SEQUENCE auditoria.reserva_sq IS E'Secuencia asociada a la tabla Reserva.';
-- ddl-end --

-- object: cliente_pl | type: POLICY --
-- DROP POLICY IF EXISTS cliente_pl ON parqueadero.cliente CASCADE;
CREATE POLICY cliente_pl ON parqueadero.cliente
	AS PERMISSIVE
	FOR ALL
	TO user_role
	USING (PARQUEADERO.PGP_SYM_DECRYPT(CORREO_CLIENTE, 'AES_KEY') = CURRENT_USER);
-- ddl-end --
COMMENT ON POLICY cliente_pl ON parqueadero.cliente IS E'Política que evita que un cliente pueda ver registros en la tabla aparte de los suyos.';
-- ddl-end --

-- object: tarjeta_pago_pl | type: POLICY --
-- DROP POLICY IF EXISTS tarjeta_pago_pl ON parqueadero.tarjeta_pago CASCADE;
CREATE POLICY tarjeta_pago_pl ON parqueadero.tarjeta_pago
	AS PERMISSIVE
	FOR ALL
	TO user_role
	USING (K_CLIENTE IN (SELECT K_CLIENTE FROM PARQUEADERO.CLIENTE WHERE PARQUEADERO.PGP_SYM_DECRYPT(CORREO_CLIENTE, 'AES_KEY') = CURRENT_USER));
-- ddl-end --
COMMENT ON POLICY tarjeta_pago_pl ON parqueadero.tarjeta_pago IS E'Política que solo deja que un cliente pueda ver las tarjetas asociadas a él mismo.';
-- ddl-end --

-- object: empleado_operador_pl | type: POLICY --
-- DROP POLICY IF EXISTS empleado_operador_pl ON parqueadero.empleado CASCADE;
CREATE POLICY empleado_operador_pl ON parqueadero.empleado
	AS PERMISSIVE
	FOR ALL
	TO operador_role
	USING (PARQUEADERO.PGP_SYM_DECRYPT(CORREO_EMPLEADO, 'AES_KEY') = CURRENT_USER);
-- ddl-end --
COMMENT ON POLICY empleado_operador_pl ON parqueadero.empleado IS E'Política que evita que un operador pueda ver registros en la tabla aparte de los suyos.';
-- ddl-end --

-- object: empleado_fk | type: CONSTRAINT --
-- ALTER TABLE parqueadero.horario_empleado DROP CONSTRAINT IF EXISTS empleado_fk CASCADE;
ALTER TABLE parqueadero.horario_empleado ADD CONSTRAINT empleado_fk FOREIGN KEY (k_empleado)
REFERENCES parqueadero.empleado (k_empleado) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: parqueadero.horario_empleado_sq | type: SEQUENCE --
-- ALTER TABLE parqueadero.horario_empleado DROP SEQUENCE IF EXISTS parqueadero.horario_empleado_sq CASCADE;
CREATE SEQUENCE parqueadero.horario_empleado_sq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY parqueadero.horario_empleado.k_horario_empleado;

ALTER TABLE parqueadero.horario_empleado ALTER COLUMN k_horario_empleado
 SET DEFAULT nextval('parqueadero.horario_empleado_sq'::regclass);
-- ddl-end --
ALTER SEQUENCE parqueadero.horario_empleado_sq OWNER TO parkud_db_admin;
-- ddl-end --
COMMENT ON SEQUENCE parqueadero.horario_empleado_sq IS E'Secuencia asociada a la tabla Horario Empleado.';
-- ddl-end --

-- object: vehiculo_cliente_pl | type: POLICY --
-- DROP POLICY IF EXISTS vehiculo_cliente_pl ON parqueadero.vehiculo CASCADE;
CREATE POLICY vehiculo_cliente_pl ON parqueadero.vehiculo
	AS PERMISSIVE
	FOR ALL
	TO user_role
	USING (K_CLIENTE IN (SELECT K_CLIENTE FROM PARQUEADERO.CLIENTE WHERE PARQUEADERO.PGP_SYM_DECRYPT(CORREO_CLIENTE, 'AES_KEY') = CURRENT_USER));
-- ddl-end --
COMMENT ON POLICY vehiculo_cliente_pl ON parqueadero.vehiculo IS E'Política que solo deja que un cliente pueda ver los vehículos asociados a él mismo.';
-- ddl-end --

-- object: fidelizacion_cliente_pl | type: POLICY --
-- DROP POLICY IF EXISTS fidelizacion_cliente_pl ON parqueadero.fidelizacion_cliente CASCADE;
CREATE POLICY fidelizacion_cliente_pl ON parqueadero.fidelizacion_cliente
	AS PERMISSIVE
	FOR ALL
	TO user_role
	USING (K_CLIENTE IN (SELECT K_CLIENTE FROM PARQUEADERO.CLIENTE WHERE PARQUEADERO.PGP_SYM_DECRYPT(CORREO_CLIENTE, 'AES_KEY') = CURRENT_USER));
-- ddl-end --
COMMENT ON POLICY fidelizacion_cliente_pl ON parqueadero.fidelizacion_cliente IS E'Política que solo deja que un cliente pueda ver el plan de fidelización asociado a él mismo.';
-- ddl-end --

-- object: reserva_cliente_pl | type: POLICY --
-- DROP POLICY IF EXISTS reserva_cliente_pl ON parqueadero.reserva CASCADE;
CREATE POLICY reserva_cliente_pl ON parqueadero.reserva
	AS PERMISSIVE
	FOR ALL
	TO user_role
	USING (K_CLIENTE IN (SELECT K_CLIENTE FROM PARQUEADERO.CLIENTE WHERE PARQUEADERO.PGP_SYM_DECRYPT(CORREO_CLIENTE, 'AES_KEY') = CURRENT_USER));
-- ddl-end --
COMMENT ON POLICY reserva_cliente_pl ON parqueadero.reserva IS E'Política que solo deja que un cliente pueda ver las reservas asociadas a él mismo.';
-- ddl-end --

-- object: operador_horario_pl | type: POLICY --
-- DROP POLICY IF EXISTS operador_horario_pl ON parqueadero.horario_empleado CASCADE;
CREATE POLICY operador_horario_pl ON parqueadero.horario_empleado
	AS PERMISSIVE
	FOR SELECT
	TO operador_role
	USING (K_EMPLEADO IN (SELECT K_EMPLEADO FROM PARQUEADERO.EMPLEADO WHERE PARQUEADERO.PGP_SYM_DECRYPT(CORREO_EMPLEADO, 'AES_KEY') = CURRENT_USER));
-- ddl-end --
COMMENT ON POLICY operador_horario_pl ON parqueadero.horario_empleado IS E'Política que solo deja que un operador pueda ver los horarios asociados a él mismo.';
-- ddl-end --

-- object: tarjeta_pago_fk | type: CONSTRAINT --
-- ALTER TABLE parqueadero.reserva DROP CONSTRAINT IF EXISTS tarjeta_pago_fk CASCADE;
ALTER TABLE parqueadero.reserva ADD CONSTRAINT tarjeta_pago_fk FOREIGN KEY (k_tarjeta_pago)
REFERENCES parqueadero.tarjeta_pago (k_tarjeta_pago) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: sucursal_direccion_ixfk | type: INDEX --
-- DROP INDEX IF EXISTS parqueadero.sucursal_direccion_ixfk CASCADE;
CREATE INDEX sucursal_direccion_ixfk ON parqueadero.sucursal
USING btree
(
	k_direccion ASC NULLS LAST
);
-- ddl-end --
COMMENT ON INDEX parqueadero.sucursal_direccion_ixfk IS E'Índice de la llave foránea de la tabla Dirección.';
-- ddl-end --

-- object: auditvehiculo_cliente_ixfk | type: INDEX --
-- DROP INDEX IF EXISTS auditoria.auditvehiculo_cliente_ixfk CASCADE;
CREATE INDEX auditvehiculo_cliente_ixfk ON auditoria.audit_vehiculo
USING btree
(
	k_cliente ASC NULLS LAST
);
-- ddl-end --
COMMENT ON INDEX auditoria.auditvehiculo_cliente_ixfk IS E'Índice de la llave foránea de la tabla Cliente del esquema Parqueadero.';
-- ddl-end --

-- object: reserva_tarjeta_pago_ixfk | type: INDEX --
-- DROP INDEX IF EXISTS parqueadero.reserva_tarjeta_pago_ixfk CASCADE;
CREATE INDEX reserva_tarjeta_pago_ixfk ON parqueadero.reserva
USING btree
(
	k_tarjeta_pago ASC NULLS LAST
);
-- ddl-end --
COMMENT ON INDEX parqueadero.reserva_tarjeta_pago_ixfk IS E'Índice de la llave foránea de la tabla Tarjeta Pago.';
-- ddl-end --

-- object: cliente_select_pl | type: POLICY --
-- DROP POLICY IF EXISTS cliente_select_pl ON parqueadero.cliente CASCADE;
CREATE POLICY cliente_select_pl ON parqueadero.cliente
	AS PERMISSIVE
	FOR SELECT
	TO super_admin_role, operador_role, admin_role
	USING (TRUE);
-- ddl-end --
COMMENT ON POLICY cliente_select_pl ON parqueadero.cliente IS E'Política que permite a los roles pertinentes seleccionar datos de la tabla Cliente.';
-- ddl-end --

-- object: cliente_insert_pl | type: POLICY --
-- DROP POLICY IF EXISTS cliente_insert_pl ON parqueadero.cliente CASCADE;
CREATE POLICY cliente_insert_pl ON parqueadero.cliente
	AS PERMISSIVE
	FOR INSERT
	TO manage_account_user, super_admin_role, admin_role
	WITH CHECK (TRUE);
-- ddl-end --
COMMENT ON POLICY cliente_insert_pl ON parqueadero.cliente IS E'Política que permite a los roles pertinentes insertar datos en la tabla del cliente.';
-- ddl-end --

-- object: cliente_update_pl | type: POLICY --
-- DROP POLICY IF EXISTS cliente_update_pl ON parqueadero.cliente CASCADE;
CREATE POLICY cliente_update_pl ON parqueadero.cliente
	AS PERMISSIVE
	FOR UPDATE
	TO super_admin_role, admin_role
	USING (TRUE)
	WITH CHECK (TRUE);
-- ddl-end --
COMMENT ON POLICY cliente_update_pl ON parqueadero.cliente IS E'Política que permite a los roles pertinentes actualizar datos de la tabla Cliente.';
-- ddl-end --

-- object: vehiculo_select_pl | type: POLICY --
-- DROP POLICY IF EXISTS vehiculo_select_pl ON parqueadero.vehiculo CASCADE;
CREATE POLICY vehiculo_select_pl ON parqueadero.vehiculo
	AS PERMISSIVE
	FOR SELECT
	TO operador_role, admin_role, super_admin_role
	USING (TRUE);
-- ddl-end --
COMMENT ON POLICY vehiculo_select_pl ON parqueadero.vehiculo IS E'Política que permite a los roles pertinentes seleccionar datos de la tabla Vehículo.';
-- ddl-end --

-- object: vehiculo_insert_pl | type: POLICY --
-- DROP POLICY IF EXISTS vehiculo_insert_pl ON parqueadero.vehiculo CASCADE;
CREATE POLICY vehiculo_insert_pl ON parqueadero.vehiculo
	AS PERMISSIVE
	FOR INSERT
	TO super_admin_role, admin_role
	WITH CHECK (TRUE);
-- ddl-end --
COMMENT ON POLICY vehiculo_insert_pl ON parqueadero.vehiculo IS E'Política que permite a los roles pertinentes insertar datos de la tabla Vehículo.';
-- ddl-end --

-- object: vehiculo_update_pl | type: POLICY --
-- DROP POLICY IF EXISTS vehiculo_update_pl ON parqueadero.vehiculo CASCADE;
CREATE POLICY vehiculo_update_pl ON parqueadero.vehiculo
	AS PERMISSIVE
	FOR UPDATE
	TO super_admin_role, admin_role
	USING (TRUE)
	WITH CHECK (TRUE);
-- ddl-end --
COMMENT ON POLICY vehiculo_update_pl ON parqueadero.vehiculo IS E'Política que permite a los roles pertinentes actualizar datos de la tabla Vehículo.';
-- ddl-end --

-- object: vehiculo_delete_pl | type: POLICY --
-- DROP POLICY IF EXISTS vehiculo_delete_pl ON parqueadero.vehiculo CASCADE;
CREATE POLICY vehiculo_delete_pl ON parqueadero.vehiculo
	AS PERMISSIVE
	FOR DELETE
	TO super_admin_role
	USING (TRUE);
-- ddl-end --
COMMENT ON POLICY vehiculo_delete_pl ON parqueadero.vehiculo IS E'Política que permite a los roles pertinentes eliminar datos de la tabla Vehículo.';
-- ddl-end --

-- object: empleado_select_pl | type: POLICY --
-- DROP POLICY IF EXISTS empleado_select_pl ON parqueadero.empleado CASCADE;
CREATE POLICY empleado_select_pl ON parqueadero.empleado
	AS PERMISSIVE
	FOR SELECT
	TO super_admin_role, admin_role
	USING (TRUE);
-- ddl-end --
COMMENT ON POLICY empleado_select_pl ON parqueadero.empleado IS E'Política que permite a los roles pertinentes seleccionar datos de la tabla Empleado.';
-- ddl-end --

-- object: empleado_insert_pl | type: POLICY --
-- DROP POLICY IF EXISTS empleado_insert_pl ON parqueadero.empleado CASCADE;
CREATE POLICY empleado_insert_pl ON parqueadero.empleado
	AS PERMISSIVE
	FOR INSERT
	TO super_admin_role, admin_role
	WITH CHECK (TRUE);
-- ddl-end --
COMMENT ON POLICY empleado_insert_pl ON parqueadero.empleado IS E'Política que permite a los roles pertinentes insertar datos de la tabla Empleado.';
-- ddl-end --

-- object: empleado_update_pl | type: POLICY --
-- DROP POLICY IF EXISTS empleado_update_pl ON parqueadero.empleado CASCADE;
CREATE POLICY empleado_update_pl ON parqueadero.empleado
	AS PERMISSIVE
	FOR UPDATE
	TO super_admin_role, admin_role
	USING (TRUE)
	WITH CHECK (TRUE);
-- ddl-end --
COMMENT ON POLICY empleado_update_pl ON parqueadero.empleado IS E'Política que permite a los roles pertinentes actualizar datos de la tabla Empleado.';
-- ddl-end --

-- object: empleado_delete | type: POLICY --
-- DROP POLICY IF EXISTS empleado_delete ON parqueadero.empleado CASCADE;
CREATE POLICY empleado_delete ON parqueadero.empleado
	AS PERMISSIVE
	FOR DELETE
	TO super_admin_role
	USING (TRUE);
-- ddl-end --
COMMENT ON POLICY empleado_delete ON parqueadero.empleado IS E'Política que permite a los roles pertinentes eliminar datos de la tabla Empleado.';
-- ddl-end --

-- object: cliente_delete_pl | type: POLICY --
-- DROP POLICY IF EXISTS cliente_delete_pl ON parqueadero.cliente CASCADE;
CREATE POLICY cliente_delete_pl ON parqueadero.cliente
	AS PERMISSIVE
	FOR DELETE
	TO super_admin_role
	USING (TRUE);
-- ddl-end --
COMMENT ON POLICY cliente_delete_pl ON parqueadero.cliente IS E'Política que permite a los roles pertinentes eliminar datos de la tabla Cliente.';
-- ddl-end --

-- object: reserva_select_pl | type: POLICY --
-- DROP POLICY IF EXISTS reserva_select_pl ON parqueadero.reserva CASCADE;
CREATE POLICY reserva_select_pl ON parqueadero.reserva
	AS PERMISSIVE
	FOR SELECT
	TO admin_role, operador_role, super_admin_role
	USING (TRUE);
-- ddl-end --
COMMENT ON POLICY reserva_select_pl ON parqueadero.reserva IS E'Política que permite a los roles pertinentes seleccionar datos de la tabla Reserva.';
-- ddl-end --

-- object: reserva_insert_pl | type: POLICY --
-- DROP POLICY IF EXISTS reserva_insert_pl ON parqueadero.reserva CASCADE;
CREATE POLICY reserva_insert_pl ON parqueadero.reserva
	AS PERMISSIVE
	FOR INSERT
	TO super_admin_role, admin_role
	WITH CHECK (TRUE);
-- ddl-end --
COMMENT ON POLICY reserva_insert_pl ON parqueadero.reserva IS E'Política que permite a los roles pertinentes insertar datos de la tabla Reserva.';
-- ddl-end --

-- object: reserva_update_pl | type: POLICY --
-- DROP POLICY IF EXISTS reserva_update_pl ON parqueadero.reserva CASCADE;
CREATE POLICY reserva_update_pl ON parqueadero.reserva
	AS PERMISSIVE
	FOR UPDATE
	TO super_admin_role, admin_role
	USING (TRUE);
-- ddl-end --
COMMENT ON POLICY reserva_update_pl ON parqueadero.reserva IS E'Política que permite a los roles pertinentes actualizar datos de la tabla Reserva.';
-- ddl-end --

-- object: "grant_U_ad498d56ef" | type: PERMISSION --
GRANT USAGE
   ON SCHEMA parqueadero
   TO user_role;
-- ddl-end --

-- object: grant_raw_3755bd246b | type: PERMISSION --
GRANT SELECT,INSERT,UPDATE
   ON TABLE parqueadero.reserva
   TO user_role;
-- ddl-end --

-- object: grant_rawd_f5b271ce19 | type: PERMISSION --
GRANT SELECT,INSERT,UPDATE,DELETE
   ON TABLE parqueadero.tarjeta_pago
   TO user_role;
-- ddl-end --

-- object: grant_r_dcdefe732e | type: PERMISSION --
GRANT SELECT
   ON TABLE parqueadero.marca_vehiculo
   TO user_role;
-- ddl-end --

-- object: grant_raw_0257d8eb3a | type: PERMISSION --
GRANT SELECT,INSERT,UPDATE
   ON TABLE parqueadero.fidelizacion_cliente
   TO user_role;
-- ddl-end --

-- object: grant_r_cb8e78821b | type: PERMISSION --
GRANT SELECT
   ON TABLE parqueadero.promocion
   TO user_role;
-- ddl-end --

-- object: grant_r_e17ec8007e | type: PERMISSION --
GRANT SELECT
   ON TABLE parqueadero.promocion_por_reserva
   TO user_role;
-- ddl-end --

-- object: grant_r_8fe16c0dd4 | type: PERMISSION --
GRANT SELECT
   ON TABLE parqueadero.promocion_por_tiempo
   TO user_role;
-- ddl-end --

-- object: grant_r_dd6e9098a0 | type: PERMISSION --
GRANT SELECT
   ON TABLE parqueadero.tarifa_minuto
   TO user_role;
-- ddl-end --

-- object: grant_r_f6d692b65c | type: PERMISSION --
GRANT SELECT
   ON TABLE parqueadero.horario_sucursal
   TO user_role;
-- ddl-end --

-- object: grant_r_397d55a858 | type: PERMISSION --
GRANT SELECT
   ON TABLE auditoria.audit_reserva
   TO admin_role;
-- ddl-end --

-- object: grant_r_f2d039c306 | type: PERMISSION --
GRANT SELECT
   ON TABLE auditoria.audit_vehiculo
   TO admin_role;
-- ddl-end --

-- object: grant_raw_4a871f5de9 | type: PERMISSION --
GRANT SELECT,INSERT,UPDATE
   ON TABLE parqueadero.empleado
   TO admin_role;
-- ddl-end --

-- object: "grant_U_f5e89417e9" | type: PERMISSION --
GRANT USAGE
   ON SCHEMA parqueadero
   TO manage_account_user;
-- ddl-end --

-- object: "grant_U_b79e3d979b" | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE parqueadero.cliente_sq
   TO manage_account_user;
-- ddl-end --

-- object: grant_rw_507d21393d | type: PERMISSION --
GRANT SELECT,UPDATE
   ON TABLE parqueadero.sucursal
   TO admin_role;
-- ddl-end --

-- object: grant_raw_8caa9cc55d | type: PERMISSION --
GRANT SELECT,INSERT,UPDATE
   ON TABLE parqueadero.tarifa_minuto
   TO admin_role;
-- ddl-end --

-- object: grant_rw_a22aa08338 | type: PERMISSION --
GRANT SELECT,UPDATE
   ON TABLE parqueadero.direccion
   TO admin_role;
-- ddl-end --

-- object: grant_raw_1a7315474e | type: PERMISSION --
GRANT SELECT,INSERT,UPDATE
   ON TABLE parqueadero.horario_sucursal
   TO admin_role;
-- ddl-end --

-- object: grant_raw_e86404c9a0 | type: PERMISSION --
GRANT SELECT,INSERT,UPDATE
   ON TABLE parqueadero.horario_empleado
   TO admin_role;
-- ddl-end --

-- object: grant_raw_49db34cc11 | type: PERMISSION --
GRANT SELECT,INSERT,UPDATE
   ON TABLE parqueadero.ejerce
   TO admin_role;
-- ddl-end --

-- object: grant_raw_ae364acded | type: PERMISSION --
GRANT SELECT,INSERT,UPDATE
   ON TABLE parqueadero.reserva
   TO admin_role;
-- ddl-end --

-- object: grant_rawd_3236e2309b | type: PERMISSION --
GRANT SELECT,INSERT,UPDATE,DELETE
   ON TABLE parqueadero.slot_parqueadero
   TO admin_role;
-- ddl-end --

-- object: grant_rawd_639d3c6d75 | type: PERMISSION --
GRANT SELECT,INSERT,UPDATE,DELETE
   ON TABLE parqueadero.trabaja
   TO admin_role;
-- ddl-end --

-- object: grant_rawd_ed4c877a0b | type: PERMISSION --
GRANT SELECT,INSERT,UPDATE,DELETE
   ON TABLE parqueadero.promocion
   TO admin_role;
-- ddl-end --

-- object: grant_rawd_ec7b5d5de1 | type: PERMISSION --
GRANT SELECT,INSERT,UPDATE,DELETE
   ON TABLE parqueadero.promocion_por_reserva
   TO admin_role;
-- ddl-end --

-- object: grant_rawd_0423a0a1bf | type: PERMISSION --
GRANT SELECT,INSERT,UPDATE,DELETE
   ON TABLE parqueadero.promocion_por_tiempo
   TO admin_role;
-- ddl-end --

-- object: grant_raw_26fd68668b | type: PERMISSION --
GRANT SELECT,INSERT,UPDATE
   ON TABLE parqueadero.fidelizacion_cliente
   TO admin_role;
-- ddl-end --

-- object: grant_rawd_c6c52cf6c0 | type: PERMISSION --
GRANT SELECT,INSERT,UPDATE,DELETE
   ON TABLE parqueadero.marca_vehiculo
   TO admin_role;
-- ddl-end --

-- object: grant_rawd_46efe7ba9a | type: PERMISSION --
GRANT SELECT,INSERT,UPDATE,DELETE
   ON TABLE parqueadero.tarifa_minuto
   TO super_admin_role;
-- ddl-end --

-- object: grant_rawd_57a6036427 | type: PERMISSION --
GRANT SELECT,INSERT,UPDATE,DELETE
   ON TABLE parqueadero.direccion
   TO super_admin_role;
-- ddl-end --

-- object: grant_rawd_da80dd6fa8 | type: PERMISSION --
GRANT SELECT,INSERT,UPDATE,DELETE
   ON TABLE parqueadero.ciudad
   TO super_admin_role;
-- ddl-end --

-- object: grant_rawd_844ce6e932 | type: PERMISSION --
GRANT SELECT,INSERT,UPDATE,DELETE
   ON TABLE parqueadero.departamento
   TO super_admin_role;
-- ddl-end --

-- object: grant_rawd_7e46499f7d | type: PERMISSION --
GRANT SELECT,INSERT,UPDATE,DELETE
   ON TABLE parqueadero.pais
   TO super_admin_role;
-- ddl-end --

-- object: grant_rawd_8ece23bd4a | type: PERMISSION --
GRANT SELECT,INSERT,UPDATE,DELETE
   ON TABLE parqueadero.horario_sucursal
   TO super_admin_role;
-- ddl-end --

-- object: grant_r_71c1e6c020 | type: PERMISSION --
GRANT SELECT
   ON TABLE parqueadero.dia_semana
   TO admin_role;
-- ddl-end --

-- object: grant_r_e88a42aab0 | type: PERMISSION --
GRANT SELECT
   ON TABLE parqueadero.dia_semana
   TO super_admin_role;
-- ddl-end --

-- object: grant_rawd_5e4d8ed963 | type: PERMISSION --
GRANT SELECT,INSERT,UPDATE,DELETE
   ON TABLE parqueadero.horario_empleado
   TO super_admin_role;
-- ddl-end --

-- object: grant_rawd_e114ec061f | type: PERMISSION --
GRANT SELECT,INSERT,UPDATE,DELETE
   ON TABLE parqueadero.cargo
   TO super_admin_role;
-- ddl-end --

-- object: grant_r_4bffeea596 | type: PERMISSION --
GRANT SELECT
   ON TABLE parqueadero.cargo
   TO admin_role;
-- ddl-end --

-- object: grant_r_da111b0166 | type: PERMISSION --
GRANT SELECT
   ON TABLE parqueadero.cargo
   TO operador_role;
-- ddl-end --

-- object: grant_r_b255dd40dc | type: PERMISSION --
GRANT SELECT
   ON TABLE parqueadero.horario_empleado
   TO operador_role;
-- ddl-end --

-- object: grant_r_d91d2e8253 | type: PERMISSION --
GRANT SELECT
   ON TABLE parqueadero.dia_semana
   TO operador_role;
-- ddl-end --

-- object: grant_r_e868e277ba | type: PERMISSION --
GRANT SELECT
   ON TABLE parqueadero.sucursal
   TO operador_role;
-- ddl-end --

-- object: grant_r_c45162bf77 | type: PERMISSION --
GRANT SELECT
   ON TABLE parqueadero.horario_sucursal
   TO operador_role;
-- ddl-end --

-- object: grant_rawd_02f5b5dd7d | type: PERMISSION --
GRANT SELECT,INSERT,UPDATE,DELETE
   ON TABLE parqueadero.ejerce
   TO super_admin_role;
-- ddl-end --

-- object: grant_r_2b4b83cf08 | type: PERMISSION --
GRANT SELECT
   ON TABLE parqueadero.ejerce
   TO operador_role;
-- ddl-end --

-- object: grant_rawd_093bfcce6c | type: PERMISSION --
GRANT SELECT,INSERT,UPDATE,DELETE
   ON TABLE parqueadero.trabaja
   TO super_admin_role;
-- ddl-end --

-- object: grant_r_630b0e1309 | type: PERMISSION --
GRANT SELECT
   ON TABLE parqueadero.trabaja
   TO operador_role;
-- ddl-end --

-- object: grant_rawd_8f906a3245 | type: PERMISSION --
GRANT SELECT,INSERT,UPDATE,DELETE
   ON TABLE parqueadero.slot_parqueadero
   TO super_admin_role;
-- ddl-end --

-- object: grant_r_fdeb638e92 | type: PERMISSION --
GRANT SELECT
   ON TABLE parqueadero.slot_parqueadero
   TO operador_role;
-- ddl-end --

-- object: grant_raw_11fa57018e | type: PERMISSION --
GRANT SELECT,INSERT,UPDATE
   ON TABLE parqueadero.reserva
   TO super_admin_role;
-- ddl-end --

-- object: grant_r_bfb876c072 | type: PERMISSION --
GRANT SELECT
   ON TABLE parqueadero.reserva
   TO operador_role;
-- ddl-end --

-- object: grant_r_5463325bed | type: PERMISSION --
GRANT SELECT
   ON TABLE parqueadero.marca_vehiculo
   TO operador_role;
-- ddl-end --

-- object: grant_rawd_f17010370f | type: PERMISSION --
GRANT SELECT,INSERT,UPDATE,DELETE
   ON TABLE parqueadero.marca_vehiculo
   TO super_admin_role;
-- ddl-end --

-- object: grant_r_86e1e6e52b | type: PERMISSION --
GRANT SELECT
   ON TABLE auditoria.audit_reserva
   TO super_admin_role;
-- ddl-end --

-- object: grant_r_c559c1b727 | type: PERMISSION --
GRANT SELECT
   ON TABLE parqueadero.promocion
   TO operador_role;
-- ddl-end --

-- object: grant_rawd_6518d3ae6b | type: PERMISSION --
GRANT SELECT,INSERT,UPDATE,DELETE
   ON TABLE parqueadero.promocion
   TO super_admin_role;
-- ddl-end --

-- object: grant_r_6f12068f2b | type: PERMISSION --
GRANT SELECT
   ON TABLE parqueadero.promocion_por_reserva
   TO operador_role;
-- ddl-end --

-- object: grant_rawd_6609a5a67d | type: PERMISSION --
GRANT SELECT,INSERT,UPDATE,DELETE
   ON TABLE parqueadero.promocion_por_reserva
   TO super_admin_role;
-- ddl-end --

-- object: grant_r_cb8f47d19d | type: PERMISSION --
GRANT SELECT
   ON TABLE parqueadero.promocion_por_tiempo
   TO operador_role;
-- ddl-end --

-- object: grant_rawd_9e07467d78 | type: PERMISSION --
GRANT SELECT,INSERT,UPDATE,DELETE
   ON TABLE parqueadero.promocion_por_tiempo
   TO super_admin_role;
-- ddl-end --

-- object: grant_r_0fb2e128f1 | type: PERMISSION --
GRANT SELECT
   ON TABLE parqueadero.fidelizacion_cliente
   TO operador_role;
-- ddl-end --

-- object: grant_raw_ccc056f658 | type: PERMISSION --
GRANT SELECT,INSERT,UPDATE
   ON TABLE parqueadero.fidelizacion_cliente
   TO super_admin_role;
-- ddl-end --

-- object: grant_r_b020419bcf | type: PERMISSION --
GRANT SELECT
   ON TABLE parqueadero.empleado
   TO operador_role;
-- ddl-end --

-- object: grant_rawd_ca1c7a37ee | type: PERMISSION --
GRANT SELECT,INSERT,UPDATE,DELETE
   ON TABLE parqueadero.empleado
   TO super_admin_role;
-- ddl-end --

-- object: "grant_U_f3121d3c2b" | type: PERMISSION --
GRANT USAGE
   ON SCHEMA auditoria
   TO admin_role;
-- ddl-end --

-- object: "grant_U_a721e2e829" | type: PERMISSION --
GRANT USAGE
   ON SCHEMA auditoria
   TO super_admin_role;
-- ddl-end --

-- object: "grant_U_7f1ce47b4a" | type: PERMISSION --
GRANT USAGE
   ON SCHEMA parqueadero
   TO super_admin_role;
-- ddl-end --

-- object: "grant_U_5fb27da27a" | type: PERMISSION --
GRANT USAGE
   ON SCHEMA parqueadero
   TO admin_role;
-- ddl-end --

-- object: "grant_U_9e380d5a68" | type: PERMISSION --
GRANT USAGE
   ON SCHEMA parqueadero
   TO operador_role;
-- ddl-end --

-- object: grant_c_d3bfd29072 | type: PERMISSION --
GRANT CONNECT
   ON DATABASE parkud_dbpg
   TO admin_role;
-- ddl-end --

-- object: grant_c_9b69d6341d | type: PERMISSION --
GRANT CONNECT
   ON DATABASE parkud_dbpg
   TO super_admin_role;
-- ddl-end --

-- object: grant_c_5e3ab5c415 | type: PERMISSION --
GRANT CONNECT
   ON DATABASE parkud_dbpg
   TO user_role;
-- ddl-end --

-- object: grant_c_324606cc1b | type: PERMISSION --
GRANT CONNECT
   ON DATABASE parkud_dbpg
   TO operador_role;
-- ddl-end --

-- object: grant_r_613744a161 | type: PERMISSION --
GRANT SELECT
   ON TABLE parqueadero.pais
   TO admin_role;
-- ddl-end --

-- object: grant_r_7c1ee5131f | type: PERMISSION --
GRANT SELECT
   ON TABLE parqueadero.pais
   TO operador_role;
-- ddl-end --

-- object: grant_r_24bfe5c4ab | type: PERMISSION --
GRANT SELECT
   ON TABLE parqueadero.pais
   TO user_role;
-- ddl-end --

-- object: grant_r_57f91634cd | type: PERMISSION --
GRANT SELECT
   ON TABLE parqueadero.departamento
   TO admin_role;
-- ddl-end --

-- object: grant_r_e96bacd77d | type: PERMISSION --
GRANT SELECT
   ON TABLE parqueadero.departamento
   TO operador_role;
-- ddl-end --

-- object: grant_r_497562a93d | type: PERMISSION --
GRANT SELECT
   ON TABLE parqueadero.departamento
   TO user_role;
-- ddl-end --

-- object: grant_r_736c7f6e80 | type: PERMISSION --
GRANT SELECT
   ON TABLE parqueadero.ciudad
   TO admin_role;
-- ddl-end --

-- object: grant_r_275143e948 | type: PERMISSION --
GRANT SELECT
   ON TABLE parqueadero.ciudad
   TO operador_role;
-- ddl-end --

-- object: grant_r_226f04860e | type: PERMISSION --
GRANT SELECT
   ON TABLE parqueadero.ciudad
   TO user_role;
-- ddl-end --

-- object: grant_r_3436ac8036 | type: PERMISSION --
GRANT SELECT
   ON TABLE parqueadero.direccion
   TO operador_role;
-- ddl-end --

-- object: grant_r_2c849c8ade | type: PERMISSION --
GRANT SELECT
   ON TABLE parqueadero.direccion
   TO user_role;
-- ddl-end --

-- object: grant_rawd_d40f1c1259 | type: PERMISSION --
GRANT SELECT,INSERT,UPDATE,DELETE
   ON TABLE parqueadero.sucursal
   TO super_admin_role;
-- ddl-end --

-- object: grant_r_638b842fd2 | type: PERMISSION --
GRANT SELECT
   ON TABLE parqueadero.sucursal
   TO user_role;
-- ddl-end --

-- object: grant_r_7989fff223 | type: PERMISSION --
GRANT SELECT
   ON TABLE parqueadero.tarifa_minuto
   TO operador_role;
-- ddl-end --

-- object: grant_r_7c8770db98 | type: PERMISSION --
GRANT SELECT
   ON TABLE parqueadero.dia_semana
   TO user_role;
-- ddl-end --

-- object: grant_r_c5b8f271de | type: PERMISSION --
GRANT SELECT
   ON TABLE parqueadero.slot_parqueadero
   TO user_role;
-- ddl-end --

-- object: "grant_U_0269bc81b0" | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE parqueadero.reserva_sq
   TO user_role;
-- ddl-end --

-- object: "grant_U_a992a583e9" | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE parqueadero.reserva_sq
   TO operador_role;
-- ddl-end --

-- object: "grant_U_4321b34746" | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE parqueadero.reserva_sq
   TO admin_role;
-- ddl-end --

-- object: "grant_U_40e4e38c91" | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE parqueadero.reserva_sq
   TO super_admin_role;
-- ddl-end --

-- object: "grant_U_04b881bf80" | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE parqueadero.vehiculo_sq
   TO user_role;
-- ddl-end --

-- object: "grant_U_a909f0a22c" | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE parqueadero.vehiculo_sq
   TO operador_role;
-- ddl-end --

-- object: "grant_U_153c8516bd" | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE parqueadero.vehiculo_sq
   TO super_admin_role;
-- ddl-end --

-- object: "grant_U_8f8a6df690" | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE parqueadero.vehiculo_sq
   TO admin_role;
-- ddl-end --

-- object: "grant_U_7cf9067df4" | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE parqueadero.fidelizacion_sq
   TO admin_role;
-- ddl-end --

-- object: "grant_U_6153b6b0bb" | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE parqueadero.fidelizacion_sq
   TO super_admin_role;
-- ddl-end --

-- object: "grant_U_3a818bdf58" | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE parqueadero.fidelizacion_sq
   TO operador_role;
-- ddl-end --

-- object: "grant_U_0e006b0f3c" | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE parqueadero.fidelizacion_sq
   TO user_role;
-- ddl-end --

-- object: "grant_U_d0a7bba3f3" | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE parqueadero.promocion_sq
   TO super_admin_role;
-- ddl-end --

-- object: "grant_U_82a0092b52" | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE parqueadero.promocion_sq
   TO admin_role;
-- ddl-end --

-- object: "grant_U_3d2deb4cc9" | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE parqueadero.sucursal_sq
   TO super_admin_role;
-- ddl-end --

-- object: "grant_U_74f9fd5c4c" | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE parqueadero.tarifa_minuto_sq
   TO super_admin_role;
-- ddl-end --

-- object: "grant_U_fbbb4dfa27" | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE parqueadero.tarifa_minuto_sq
   TO admin_role;
-- ddl-end --

-- object: "grant_U_cdb816110f" | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE parqueadero.direccion_sq
   TO super_admin_role;
-- ddl-end --

-- object: "grant_U_0ba87cb89f" | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE parqueadero.empleado_sq
   TO super_admin_role;
-- ddl-end --

-- object: "grant_U_08453ad86d" | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE parqueadero.empleado_sq
   TO admin_role;
-- ddl-end --

-- object: "grant_U_ade7565ff7" | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE parqueadero.tarjeta_pago_sq
   TO user_role;
-- ddl-end --

-- object: "grant_U_26a2c50c9c" | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE parqueadero.horario_sucursal_sq
   TO admin_role;
-- ddl-end --

-- object: "grant_U_c1ded1cab3" | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE parqueadero.horario_sucursal_sq
   TO super_admin_role;
-- ddl-end --

-- object: "grant_U_55a503a449" | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE auditoria.vehiculo_sq
   TO admin_role;
-- ddl-end --

-- object: "grant_U_ce4bce070d" | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE auditoria.vehiculo_sq
   TO user_role;
-- ddl-end --

-- object: "grant_U_b3eb71d013" | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE auditoria.vehiculo_sq
   TO super_admin_role;
-- ddl-end --

-- object: "grant_U_f8aeb23ca0" | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE auditoria.reserva_sq
   TO user_role;
-- ddl-end --

-- object: "grant_U_cba6546d0f" | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE auditoria.reserva_sq
   TO operador_role;
-- ddl-end --

-- object: "grant_U_49461ff771" | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE auditoria.reserva_sq
   TO admin_role;
-- ddl-end --

-- object: "grant_U_85f0c24271" | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE auditoria.reserva_sq
   TO super_admin_role;
-- ddl-end --

-- object: "grant_U_2e81ae2f7e" | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE auditoria.usuario_sq
   TO user_role;
-- ddl-end --

-- object: "grant_U_4efc1b1d1f" | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE auditoria.usuario_sq
   TO operador_role;
-- ddl-end --

-- object: "grant_U_18f6fdf951" | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE auditoria.usuario_sq
   TO super_admin_role;
-- ddl-end --

-- object: "grant_U_d8ed91daa5" | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE auditoria.usuario_sq
   TO admin_role;
-- ddl-end --

-- object: "grant_U_e20820ced3" | type: PERMISSION --
GRANT USAGE
   ON SCHEMA auditoria
   TO operador_role;
-- ddl-end --

-- object: "grant_U_479bd34e72" | type: PERMISSION --
GRANT USAGE
   ON SCHEMA auditoria
   TO user_role;
-- ddl-end --

-- object: grant_a_a50691e9bf | type: PERMISSION --
GRANT INSERT
   ON TABLE auditoria.audit_vehiculo
   TO user_role;
-- ddl-end --

-- object: grant_ra_596d502ee9 | type: PERMISSION --
GRANT SELECT,INSERT
   ON TABLE auditoria.audit_usuario
   TO admin_role;
-- ddl-end --

-- object: grant_ra_4575e72bfe | type: PERMISSION --
GRANT SELECT,INSERT
   ON TABLE auditoria.audit_usuario
   TO super_admin_role;
-- ddl-end --

-- object: grant_a_a078c808ef | type: PERMISSION --
GRANT INSERT
   ON TABLE auditoria.audit_usuario
   TO user_role;
-- ddl-end --

-- object: grant_a_47dedde5b6 | type: PERMISSION --
GRANT INSERT
   ON TABLE auditoria.audit_usuario
   TO operador_role;
-- ddl-end --

-- object: grant_r_eb0b6f3ddf | type: PERMISSION --
GRANT SELECT
   ON TABLE auditoria.audit_vehiculo
   TO super_admin_role;
-- ddl-end --

-- object: grant_a_615cc875e2 | type: PERMISSION --
GRANT INSERT
   ON TABLE auditoria.audit_reserva
   TO user_role;
-- ddl-end --

-- object: "grant_U_840e5c3c7a" | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE parqueadero.horario_empleado_sq
   TO operador_role;
-- ddl-end --

-- object: "grant_U_12f5906d5e" | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE parqueadero.horario_empleado_sq
   TO admin_role;
-- ddl-end --

-- object: "grant_U_36c3680165" | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE parqueadero.horario_empleado_sq
   TO super_admin_role;
-- ddl-end --

-- object: grant_r_cd5524e76e | type: PERMISSION --
GRANT SELECT
   ON TABLE parqueadero.tarjeta_pago
   TO super_admin_role;
-- ddl-end --

-- object: grant_rawd_b89557d3ff | type: PERMISSION --
GRANT SELECT,INSERT,UPDATE,DELETE
   ON TABLE parqueadero.cliente
   TO super_admin_role;
-- ddl-end --

-- object: grant_raw_05708b9cdf | type: PERMISSION --
GRANT SELECT,INSERT,UPDATE
   ON TABLE parqueadero.cliente
   TO admin_role;
-- ddl-end --

-- object: grant_raw_bc7fd06f04 | type: PERMISSION --
GRANT SELECT,INSERT,UPDATE
   ON TABLE parqueadero.cliente
   TO user_role;
-- ddl-end --

-- object: grant_a_b6821eb769 | type: PERMISSION --
GRANT INSERT
   ON TABLE parqueadero.cliente
   TO manage_account_user;
-- ddl-end --

-- object: grant_rawd_fce1799191 | type: PERMISSION --
GRANT SELECT,INSERT,UPDATE,DELETE
   ON TABLE parqueadero.vehiculo
   TO user_role;
-- ddl-end --

-- object: grant_r_abf2d71493 | type: PERMISSION --
GRANT SELECT
   ON TABLE parqueadero.vehiculo
   TO operador_role;
-- ddl-end --

-- object: grant_raw_cdf7aa8a7a | type: PERMISSION --
GRANT SELECT,INSERT,UPDATE
   ON TABLE parqueadero.vehiculo
   TO admin_role;
-- ddl-end --

-- object: grant_rawd_418b521192 | type: PERMISSION --
GRANT SELECT,INSERT,UPDATE,DELETE
   ON TABLE parqueadero.vehiculo
   TO super_admin_role;
-- ddl-end --

-- object: grant_r_0af199fdda | type: PERMISSION --
GRANT SELECT
   ON TABLE parqueadero.cliente
   TO operador_role;
-- ddl-end --

-- object: "grant_U_4da3bf0fd0" | type: PERMISSION --
GRANT USAGE
   ON SCHEMA auditoria
   TO manage_account_user;
-- ddl-end --

-- object: grant_a_cab836193d | type: PERMISSION --
GRANT INSERT
   ON TABLE auditoria.audit_usuario
   TO manage_account_user;
-- ddl-end --

-- object: "grant_U_442a08b980" | type: PERMISSION --
GRANT USAGE
   ON SEQUENCE auditoria.usuario_sq
   TO manage_account_user;
-- ddl-end --

-- object: revoke_rwx_e369c9da65 | type: PERMISSION --
REVOKE SELECT(numero_tarjeta),UPDATE(numero_tarjeta),REFERENCES(numero_tarjeta)
   ON TABLE parqueadero.tarjeta_pago
   FROM user_role;
-- ddl-end --

-- object: revoke_rawx_6332f16e0d | type: PERMISSION --
REVOKE SELECT(numero_tarjeta),INSERT(numero_tarjeta),UPDATE(numero_tarjeta),REFERENCES(numero_tarjeta)
   ON TABLE parqueadero.tarjeta_pago
   FROM super_admin_role;
-- ddl-end --

-- object: revoke_rwx_f78106da68 | type: PERMISSION --
REVOKE SELECT(mes_vencimiento),UPDATE(mes_vencimiento),REFERENCES(mes_vencimiento)
   ON TABLE parqueadero.tarjeta_pago
   FROM operador_role;
-- ddl-end --

-- object: revoke_rawx_ad847dfda6 | type: PERMISSION --
REVOKE SELECT(mes_vencimiento),INSERT(mes_vencimiento),UPDATE(mes_vencimiento),REFERENCES(mes_vencimiento)
   ON TABLE parqueadero.tarjeta_pago
   FROM super_admin_role;
-- ddl-end --

-- object: revoke_rwx_18c4d3d6ed | type: PERMISSION --
REVOKE SELECT(anio_vencimiento),UPDATE(anio_vencimiento),REFERENCES(anio_vencimiento)
   ON TABLE parqueadero.tarjeta_pago
   FROM user_role;
-- ddl-end --

-- object: revoke_rawx_5b3277dcb7 | type: PERMISSION --
REVOKE SELECT(anio_vencimiento),INSERT(anio_vencimiento),UPDATE(anio_vencimiento),REFERENCES(anio_vencimiento)
   ON TABLE parqueadero.tarjeta_pago
   FROM super_admin_role;
-- ddl-end --

-- object: revoke_rawx_7e3bc53a83 | type: PERMISSION --
REVOKE SELECT(apellido_duenio_tarjeta),INSERT(apellido_duenio_tarjeta),UPDATE(apellido_duenio_tarjeta),REFERENCES(apellido_duenio_tarjeta)
   ON TABLE parqueadero.tarjeta_pago
   FROM super_admin_role;
-- ddl-end --

-- object: revoke_rawx_53615802c1 | type: PERMISSION --
REVOKE SELECT(nombre_duenio_tarjeta),INSERT(nombre_duenio_tarjeta),UPDATE(nombre_duenio_tarjeta),REFERENCES(nombre_duenio_tarjeta)
   ON TABLE parqueadero.tarjeta_pago
   FROM super_admin_role;
-- ddl-end --

-- object: revoke_rawx_334e594a21 | type: PERMISSION --
REVOKE SELECT(ultimos_cuatro_digitos),INSERT(ultimos_cuatro_digitos),UPDATE(ultimos_cuatro_digitos),REFERENCES(ultimos_cuatro_digitos)
   ON TABLE parqueadero.tarjeta_pago
   FROM super_admin_role;
-- ddl-end --

-- object: revoke_r_96809283d1 | type: PERMISSION --
REVOKE SELECT(tipo_identificacion_cliente)
   ON TABLE parqueadero.cliente
   FROM operador_role;
-- ddl-end --

-- object: revoke_r_6a64655b93 | type: PERMISSION --
REVOKE SELECT(numero_identificacion_cliente)
   ON TABLE parqueadero.cliente
   FROM operador_role;
-- ddl-end --


