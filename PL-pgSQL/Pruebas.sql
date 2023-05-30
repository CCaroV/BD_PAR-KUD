-- Para insertar un operador
SELECT
    PARQUEADERO.CREAR_OPERADOR_FU('CC', '104782165', 'Laura', 'Tatiana', 'Ramírez', NULL, 3027415896, 'ltrr2001@gmail.com');

-- Para agregar un cliente:
SELECT
    PARQUEADERO.CREAR_CLIENTE_FU('CC', '1045698521', 'Christian', NULL, 'Caro', 'Vargas', 3005050527, 'chcarov@udistrital.edu.co');

-- Para cambiar su clave y que esta se vuelva válida:
CALL PARQUEADERO.PRIMER_CAMBIO_CLAVE_PR('chcarov@udistrital.edu.co', '1234');

-- Para agregar un vehículo:
CALL PARQUEADERO.AGREGAR_VEHICULO_PR('Automóvil', 'CFD256', 'Christian', NULL, 'Caro', 'Vargas', 'Audi', 'Negro');

-- Para insertar una sucursa;:
-- CALL PARQUEADERO.CREAR_SUCURSAL_PR('Bogotá, D.C.', 'Bogotá, D.C.', 'Carrera 72B # 89 - 42', 'Edificio Av.Boyacá', '111196', 'Sucursal Av. Boyacá', 'Descubierta', 10, 15);

--CREATE ROLE "mafeijoog@udistrital.edu.co" WITH LOGIN PASSWORD 'Miguel1234' IN ROLE SUPER_ADMIN_ROLE;
SELECT
    PARQUEADERO.MOSTRAR_INFO_BASICA_SUCURSAL('SUV', NULL, 'Cubierta', NULL);

SELECT PARQUEADERO.MOSTRAR_VEHICULOS_FU('Automóvil');

SELECT PARQUEADERO.MOSTRAR_SUCURSALES_FU();

SELECT PARQUEADERO.MOSTRAR_INFO_BASICA_SUCURSAL('Automóvil', NULL, NULL, NULL);

SELECT PARQUEADERO.MOSTRAR_INFO_SUCURSAL_RESERVA_FU('Bogotá, D.C.', TRUE, 'SUV', 'Sucursal Chapinero');

-- Para insertar un método de pago
CALL PARQUEADERO.INSERTAR_METODO_PAGO_PR('Christian', 'Caro', '5540500001000004', '0004', '02', '2027', 'MasterCard');

CALL PARQUEADERO.CREAR_RESERVA_PR('Automóvil', 'Audi - CFD256', TRUE, 'Bogotá, D.C.', 'Sucursal Kennedy', 'Carrera 77B # 58C - 41', '2023-05-29', '13:00', '0004', 'MasterCard', 'Christian', 'Caro', 0);

SELECT * FROM PARQUEADERO.RESERVA;

SELECT * FROM PARQUEADERO.TARJETA_PAGO;

SELECT T.K_TARJETA_PAGO 
    FROM PARQUEADERO.CLIENTE C 
        INNER JOIN PARQUEADERO.TARJETA_PAGO T ON C.K_CLIENTE = T.K_CLIENTE
    WHERE C.K_CLIENTE = 2
        AND PARQUEADERO.PGP_SYM_DECRYPT(T.NOMBRE_DUENIO_TARJETA, 'AES_KEY') = 'Christian'
        AND PARQUEADERO.PGP_SYM_DECRYPT(T.APELLIDO_DUENIO_TARJETA, 'AES_KEY') = 'Caro'
        AND PARQUEADERO.PGP_SYM_DECRYPT(T.ULTIMOS_CUATRO_DIGITOS, 'AES_KEY') = '0004'
        AND PARQUEADERO.PGP_SYM_DECRYPT(T.TIPO_TARJETA, 'AES_KEY') = 'MasterCard';