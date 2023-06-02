/* ---------------------------------------------------------------------------------------------------------------------
Pruebas: Creación de usuarios: */
SELECT PARQUEADERO.CREAR_CLIENTE_FU('CC', '1045698521', 'Christian', NULL, 'Caro', 'Vargas', 3005050527, 'chcarov@udistrital.edu.co');
SELECT PARQUEADERO.CREAR_CLIENTE_FU('CC', '1069716415', 'Samuel', 'David', 'Franco', 'Cuenca', 3006487845, 'sdfrancoc@udistrital.edu.co');
SELECT PARQUEADERO.CREAR_CLIENTE_FU('CC', '1234567891', 'Andrés', NULL, 'Beltrán', NULL, 3002012598, 'andres5354317@gmail.com');
SELECT PARQUEADERO.CREAR_CLIENTE_FU('CE', '1234562342', 'Laura', 'Tatiana', 'Ramirez', 'Rodriguez', 3198764234, 'ltrr20101@gmail.com');

/* ---------------------------------------------------------------------------------------------------------------------
Pruebas: Primer cambio de clave de usuarios: */
CALL PARQUEADERO.PRIMER_CAMBIO_CLAVE_PR('chcarov@udistrital.edu.co', '1234');
CALL PARQUEADERO.PRIMER_CAMBIO_CLAVE_PR('ltrr2001', 'pass');
CALL PARQUEADERO.PRIMER_CAMBIO_CLAVE_PR('sdfrancoc@udistrital.edu.co', '1234');

/* ---------------------------------------------------------------------------------------------------------------------
Pruebas: Adición de vehículos: */
CALL PARQUEADERO.AGREGAR_VEHICULO_PR('Automóvil', 'CFD256', 'Christian', NULL, 'Caro', 'Vargas', 'Audi', 'Negro');
CALL PARQUEADERO.AGREGAR_VEHICULO_PR('SUV', 'BWD456', 'Christian', NULL, 'Caro', 'Vargas', 'Skoda', 'Negro');
CALL PARQUEADERO.AGREGAR_VEHICULO_PR('Automóvil', 'FDS123', 'Christian', NULL, 'Caro', 'Vargas', 'BMW', 'Blanco');
CALL PARQUEADERO.AGREGAR_VEHICULO_PR('SUV', 'HTB236', 'Christian', NULL, 'Caro', 'Vargas', 'Fiat', 'Verde');
CALL PARQUEADERO.AGREGAR_VEHICULO_PR('Automóvil', 'FSD263', 'Christian', NULL, 'Caro', 'Vargas', 'Honda', 'Azul');
CALL PARQUEADERO.AGREGAR_VEHICULO_PR('SUV', 'FAS154', 'Samuel', 'David', 'Franco', 'Cuenca', 'Chevrolet', 'Plata');

/* ---------------------------------------------------------------------------------------------------------------------
Pruebas: Insertar un método de pago: */
CALL PARQUEADERO.INSERTAR_METODO_PAGO_PR('Christian', 'Caro', '5540500001000004', '0004', '02', '2027', 'MasterCard');
CALL PARQUEADERO.INSERTAR_METODO_PAGO_PR('Samuel', 'Franco', '4781147814781475', '1475', '10', '2028', 'Visa');

/* ---------------------------------------------------------------------------------------------------------------------
Pruebas: Ver la información de las sucursales: */
SELECT PARQUEADERO.MOSTRAR_SUCURSALES_FU();

/* ---------------------------------------------------------------------------------------------------------------------
Pruebas: Pasos para hacer una reserva: */
-- 1. Primer paso
SELECT PARQUEADERO.MOSTRAR_VEHICULOS_RESERVA_FU('Automóvil');
SELECT PARQUEADERO.MOSTRAR_VEHICULOS_RESERVA_FU('SUV');
-- 2. Segundo paso
SELECT PARQUEADERO.MOSTRAR_INFO_BASICA_SUCURSAL('SUV', NULL, 'Cubierta', NULL);
SELECT PARQUEADERO.MOSTRAR_INFO_BASICA_SUCURSAL_FU('Automóvil', NULL, NULL, NULL);
-- 3. Tercer paso
SELECT PARQUEADERO.MOSTRAR_INFO_SUCURSAL_RESERVA_FU('Bogotá, D.C.', TRUE, 'SUV', 'Sucursal Chapinero');

--5 Quinto paso (hace la reserva):
CALL PARQUEADERO.CREAR_RESERVA_PR('Automóvil', 'Audi - CFD256', TRUE, 'Bogotá, D.C.', 'Sucursal Kennedy', 'Carrera 77B # 58C - 41', '2023-05-29', '13:00', '0004', 'MasterCard', 'Christian', 'Caro', 0);
CALL PARQUEADERO.CREAR_RESERVA_PR('SUV', 'BMW - FDS123', TRUE, 'Bogotá, D.C.', 'Sucursal Chapinero', 'Carrera 7B # 45A - 23', '2023-06-01', '08:00', '0004', 'MasterCard', 'Christian', 'Caro', 0);
CALL PARQUEADERO.CREAR_RESERVA_PR('SUV', 'Fiat - HTB236', TRUE, 'Bogotá, D.C.', 'Sucursal Ciudad Bolivar', 'Carrera 66B # 56F - 12 Sur', '2023-06-16', '13:00', '0004', 'MasterCard', 'Christian', 'Caro', 0);
CALL PARQUEADERO.CREAR_RESERVA_PR('SUV', 'Honda - FSD263', TRUE, 'Bogotá, D.C.', 'Sucursal Suba', 'Calle 138B # 130A - 85', '2023-06-10', '16:00', '0004', 'MasterCard', 'Christian', 'Caro', 0);
CALL PARQUEADERO.CREAR_RESERVA_PR('SUV', 'Chevrolet - FAS154', TRUE, 'Bogotá, D.C.', 'Sucursal Suba', 'Calle 138B # 130A - 85', '2023-06-10', '16:00', '1475', 'Visa', 'Samuel', 'Franco', 0);

/* ---------------------------------------------------------------------------------------------------------------------
Pruebas: Mostrar la información de todas las sucursales: */
SELECT PARQUEADERO.MOSTRAR_SUCURSALES_FU();

/* ---------------------------------------------------------------------------------------------------------------------
Pruebas: Mostrar la información auditada de la BD: */
SELECT AUDITORIA.MOSTRAR_AUDITORIA_FU();