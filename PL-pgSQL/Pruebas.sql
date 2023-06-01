-- Para insertar un operador
SELECT
    PARQUEADERO.CREAR_OPERADOR_FU('CC', '104782165', 'Laura', 'Tatiana', 'Ramírez', NULL, 3027415896, 'ltrr2001@gmail.com');

-- Para agregar un cliente:
SELECT
    PARQUEADERO.CREAR_CLIENTE_FU('CC', '1045698521', 'Christian', NULL, 'Caro', 'Vargas', 3005050527, 'chcarov@udistrital.edu.co');

-- Para cambiar su clave y que esta se vuelva válida:
CALL PARQUEADERO.PRIMER_CAMBIO_CLAVE_PR('chcarov@udistrital.edu.co', '1234');

CALL AUDITORIA.AUDIT_INGRESO_USUARIO_PR();

-- Para agregar un vehículo:
CALL PARQUEADERO.AGREGAR_VEHICULO_PR('Automóvil', 'CFD256', 'Christian', NULL, 'Caro', 'Vargas', 'Audi', 'Negro');
CALL PARQUEADERO.AGREGAR_VEHICULO_PR('SUV', 'BWD456', 'Christian', NULL, 'Caro', 'Vargas', 'Skoda', 'Negro');
CALL PARQUEADERO.AGREGAR_VEHICULO_PR('SUV', 'FDS123', 'Christian', NULL, 'Caro', 'Vargas', 'BMW', 'Blanco');

-- Para insertar una sucursa;:
-- CALL PARQUEADERO.CREAR_SUCURSAL_PR('Bogotá, D.C.', 'Bogotá, D.C.', 'Carrera 72B # 89 - 42', 'Edificio Av.Boyacá', '111196', 'Sucursal Av. Boyacá', 'Descubierta', 10, 15);

--CREATE ROLE "mafeijoog@udistrital.edu.co" WITH LOGIN PASSWORD 'Miguel1234' IN ROLE SUPER_ADMIN_ROLE;
SELECT
    PARQUEADERO.MOSTRAR_INFO_BASICA_SUCURSAL('SUV', NULL, 'Cubierta', NULL);

SELECT PARQUEADERO.MOSTRAR_VEHICULOS_RESERVA_FU('Automóvil');

SELECT PARQUEADERO.RETORNAR_LLAVE_TEMPORAL_FU();

SELECT PARQUEADERO.MOSTRAR_SUCURSALES_FU();

SELECT PARQUEADERO.MOSTRAR_INFO_BASICA_SUCURSAL_FU('Automóvil', NULL, NULL, NULL);

SELECT PARQUEADERO.MOSTRAR_INFO_SUCURSAL_RESERVA_FU('Bogotá, D.C.', TRUE, 'SUV', 'Sucursal Chapinero');

-- Para insertar un método de pago
CALL PARQUEADERO.INSERTAR_METODO_PAGO_PR('Christian', 'Caro', '5540500001000004', '0004', '02', '2027', 'MasterCard');

CALL PARQUEADERO.CREAR_RESERVA_PR('Automóvil', 'Audi - CFD256', TRUE, 'Bogotá, D.C.', 'Sucursal Kennedy', 'Carrera 77B # 58C - 41', '2023-05-29', '13:00', '0004', 'MasterCard', 'Christian', 'Caro', 0);
CALL PARQUEADERO.CREAR_RESERVA_PR('SUV', 'BMW - FDS123', TRUE, 'Bogotá, D.C.', 'Sucursal Chapinero', 'Carrera 7B # 45A - 23', '2023-06-01', '08:00', '0004', 'MasterCard', 'Christian', 'Caro', 0);

SELECT AUDITORIA.MOSTRAR_AUDITORIA_FU();

SELECT PARQUEADERO.VERIFICAR_CORREO_FU('chcarov@udistrital.edu.co');