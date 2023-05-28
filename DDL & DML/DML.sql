-- Insertar datos iniciales
INSERT INTO PARQUEADERO.MARCA_VEHICULO VALUES (
    'Abarth'
),
(
    'Acura'
),
(
    'Alfa Romeo'
),
(
    'Aston Martin'
),
(
    'Audi'
),
(
    'Bentley'
),
(
    'BMW'
),
(
    'Bugatti'
),
(
    'Buick'
),
(
    'Cadillac'
),
(
    'Chevrolet'
),
(
    'Chrysler'
),
(
    'Citroën'
),
(
    'Dodge'
),
(
    'Ferrari'
),
(
    'Fiat'
),
(
    'Ford'
),
(
    'GMC'
),
(
    'Honda'
),
(
    'Hyundai'
),
(
    'Infiniti'
),
(
    'Jaguar'
),
(
    'Jeep'
),
(
    'Kia'
),
(
    'Lamborghini'
),
(
    'Lancia'
),
(
    'Land Rover'
),
(
    'Lexus'
),
(
    'Lincoln'
),
(
    'Lotus'
),
(
    'Maserati'
),
(
    'Mazda'
),
(
    'McLaren'
),
(
    'Mercedes-Benz'
),
(
    'MG'
),
(
    'Mini'
),
(
    'Mitsubishi'
),
(
    'Nissan'
),
(
    'Pagani'
),
(
    'Peugeot'
),
(
    'Porsche'
),
(
    'Ram'
),
(
    'Renault'
),
(
    'Rolls-Royce'
),
(
    'Seat'
),
(
    'Skoda'
),
(
    'Smart'
),
(
    'SsangYong'
),
(
    'Subaru'
),
(
    'Suzuki'
),
(
    'Tesla'
),
(
    'Toyota'
),
(
    'Volkswagen'
),
(
    'Volvo'
);

INSERT INTO PARQUEADERO.DIA_SEMANA VALUES (
    'Lunes'
),
(
    'Martes'
),
(
    'Miércoles'
),
(
    'Jueves'
),
(
    'Viernes'
),
(
    'Sábado'
),
(
    'Domingo'
);

INSERT INTO PARQUEADERO.CARGO VALUES (
    'Súper Administrador'
),
(
    'Administrador'
),
(
    'Operador'
);

INSERT INTO PARQUEADERO.PAIS(
    K_PAIS,
    NOMBRE_PAIS
) VALUES (
    'COL',
    'Colombia'
);

INSERT INTO PARQUEADERO.DEPARTAMENTO(
    K_DEPARTAMENTO,
    K_PAIS,
    NOMBRE_DEPARTAMENTO
) VALUES (
    '91',
    'COL',
    'Amazonas'
),
(
    '05',
    'COL',
    'Antioquia'
),
(
    '81',
    'COL',
    'Arauca'
),
(
    '08',
    'COL',
    'Atlántico'
),
(
    '11',
    'COL',
    'Bogotá, D.C.'
),
(
    '13',
    'COL',
    'Bolívar'
),
(
    '15',
    'COL',
    'Boyacá'
),
(
    '17',
    'COL',
    'Caldas'
),
(
    '18',
    'COL',
    'Caquetá'
),
(
    '85',
    'COL',
    'Casanare'
),
(
    '19',
    'COL',
    'Cauca'
),
(
    '20',
    'COL',
    'Cesar'
),
(
    '27',
    'COL',
    'Chocó'
),
(
    '23',
    'COL',
    'Córdoba'
),
(
    '25',
    'COL',
    'Cundinamarca'
),
(
    '94',
    'COL',
    'Guainía'
),
(
    '95',
    'COL',
    'Guaviare'
),
(
    '41',
    'COL',
    'Huila'
),
(
    '44',
    'COL',
    'La Guajira'
),
(
    '47',
    'COL',
    'Magdalena'
),
(
    '50',
    'COL',
    'Meta'
),
(
    '52',
    'COL',
    'Nariño'
),
(
    '54',
    'COL',
    'Norte de Santander'
),
(
    '86',
    'COL',
    'Putumayo'
),
(
    '63',
    'COL',
    'Quindío'
),
(
    '66',
    'COL',
    'Risaralda'
),
(
    '88',
    'COL',
    'San Andrés, Providencia y Santa Catalina'
),
(
    '68',
    'COL',
    'Santander'
),
(
    '70',
    'COL',
    'Sucre'
),
(
    '73',
    'COL',
    'Tolima'
),
(
    '76',
    'COL',
    'Valle del Cauca'
),
(
    '97',
    'COL',
    'Vaupés'
),
(
    '99',
    'COL',
    'Vichada'
);

INSERT INTO PARQUEADERO.CIUDAD(
    K_CIUDAD,
    K_DEPARTAMENTO,
    NOMBRE_CIUDAD
) VALUES (
    'C001',
    '91',
    'Leticia'
),
(
    'C002',
    '05',
    'Medellín'
),
(
    'C003',
    '05',
    'Envigado'
),
(
    'C004',
    '81',
    'Arauca'
),
(
    'C005',
    '08',
    'Barranquilla'
),
(
    'C006',
    '11',
    'Bogotá, D.C.'
),
(
    'C007',
    '13',
    'Cartagena'
),
(
    'C008',
    '15',
    'Tunja'
),
(
    'C009',
    '17',
    'Manizales'
),
(
    'C010',
    '18',
    'Florencia'
),
(
    'C011',
    '19',
    'Popayán'
),
(
    'C012',
    '20',
    'Valledupar'
),
(
    'C013',
    '27',
    'Quibdó'
),
(
    'C014',
    '23',
    'Montería'
),
(
    'C016',
    '94',
    'Inírida'
),
(
    'C017',
    '95',
    'San José del Guaviare'
),
(
    'C018',
    '41',
    'Neiva'
),
(
    'C019',
    '44',
    'Riohacha'
),
(
    'C020',
    '47',
    'Santa Marta'
),
(
    'C021',
    '50',
    'Villavicencio'
),
(
    'C022',
    '52',
    'Pasto'
),
(
    'C023',
    '54',
    'Cúcuta'
),
(
    'C024',
    '86',
    'Mocoa'
),
(
    'C025',
    '63',
    'Armenia'
),
(
    'C026',
    '66',
    'Pereira'
),
(
    'C027',
    '88',
    'San Andrés'
),
(
    'C028',
    '68',
    'Bucaramanga'
),
(
    'C029',
    '70',
    'Sincelejo'
),
(
    'C030',
    '73',
    'Ibagué'
),
(
    'C031',
    '76',
    'Cali'
),
(
    'C032',
    '97',
    'Mitú'
),
(
    'C033',
    '99',
    'Puerto Carreño'
);

-- Insertar las direcciones de las sucursales
INSERT INTO PARQUEADERO.DIRECCION(
    K_CIUDAD,
    NOMBRE_DIRECCION,
    EDIFICIO_DIRECCION,
    CODIGO_POSTAL
) VALUES (
    ( SELECT K_CIUDAD FROM PARQUEADERO.CIUDAD WHERE NOMBRE_CIUDAD = 'Bogotá, D.C.'),
    'Carrera 77B # 58C - 41',
    'Edificio Kennedy',
    '111120'
),
(
    ( SELECT K_CIUDAD FROM PARQUEADERO.CIUDAD WHERE NOMBRE_CIUDAD = 'Bogotá, D.C.'),
    'Carrera 7B # 45A - 23',
    'Edificio Javeriana',
    '111136'
),
(
    ( SELECT K_CIUDAD FROM PARQUEADERO.CIUDAD WHERE NOMBRE_CIUDAD = 'Bogotá, D.C.'),
    'Calle 138B # 130A - 85',
    'C.C. Plaza Suba',
    '111158'
),
(
    ( SELECT K_CIUDAD FROM PARQUEADERO.CIUDAD WHERE NOMBRE_CIUDAD = 'Bogotá, D.C.'),
    'Carrera 66B # 56F - 12 Sur',
    'Lote Ciudad Bolivar',
    '111174'
);

-- Insertar una sucursal con su respectiva dirección.
INSERT INTO PARQUEADERO.SUCURSAL(
    K_DIRECCION,
    NOMBRE_SUCURSAL,
    TIPO_SUCURSAL,
    TIEMPO_GRACIA_PREVIO,
    TIEMPO_GRACIA_POS
) VALUES (
    ( SELECT K_DIRECCION FROM PARQUEADERO.DIRECCION WHERE CODIGO_POSTAL = '111120' ),
    'Sucursal Kennedy',
    'Cubierta',
    15,
    0
),
(
    ( SELECT K_DIRECCION FROM PARQUEADERO.DIRECCION WHERE CODIGO_POSTAL = '111136' ),
    'Sucursal Chapinero',
    'Semicubierta',
    15,
    10
),
(
    ( SELECT K_DIRECCION FROM PARQUEADERO.DIRECCION WHERE CODIGO_POSTAL = '111158' ),
    'Sucursal Suba',
    'Descubierta',
    20,
    0
),
(
    ( SELECT K_DIRECCION FROM PARQUEADERO.DIRECCION WHERE CODIGO_POSTAL = '111174' ),
    'Sucursal Ciudad Bolivar',
    'Cubierta',
    0,
    0
);

--Insertar la tarifa de una sucursal
INSERT INTO PARQUEADERO.TARIFA_MINUTO(
    K_SUCURSAL,
    VALOR_MINUTO_SUV,
    VALOR_MINUTO_AUTO,
    VALOR_MINUTO_MOTO,
    ADICION_PARQ_CUBIERTO,
    VALOR_MULTA_CANCELACION,
    FECHA_INICIO_TARIFA,
    FECHA_FIN_TARIFA,
    ESTA_ACTIVA
) VALUES (
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Kennedy'),
    112,
    100,
    85,
    0,
    50000,
    ( SELECT CURRENT_TIMESTAMP AT TIME ZONE 'America/Bogota'),
    NULL,
    TRUE
),
(
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Chapinero'),
    100,
    85,
    67,
    10,
    25000,
    ( SELECT CURRENT_TIMESTAMP AT TIME ZONE 'America/Bogota'),
    NULL,
    TRUE
),
(
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Suba'),
    110,
    95,
    70,
    4,
    35000,
    ( SELECT CURRENT_TIMESTAMP AT TIME ZONE 'America/Bogota'),
    NULL,
    TRUE
),
(
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Ciudad Bolivar'),
    100,
    70,
    50,
    0,
    10000,
    ( SELECT CURRENT_TIMESTAMP AT TIME ZONE 'America/Bogota'),
    NULL,
    TRUE
);

-- Insertar los horarios de una sucursal
INSERT INTO PARQUEADERO.HORARIO_SUCURSAL(
    K_SUCURSAL,
    K_DIA_SEMANA,
    HORA_ABIERTO_SUCURSAL,
    HORA_CERRADO_SUCURSAL,
    ES_HORARIO_COMPLETO,
    ES_CERRADO_COMPLETO
) VALUES (
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Kennedy'),
    'Lunes',
    '08:00',
    '22:00',
    FALSE,
    FALSE
),
(
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Kennedy'),
    'Martes',
    '08:00',
    '22:00',
    FALSE,
    FALSE
),
(
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Kennedy'),
    'Miércoles',
    '08:00',
    '22:00',
    FALSE,
    FALSE
),
(
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Kennedy'),
    'Jueves',
    '08:00',
    '22:00',
    FALSE,
    FALSE
),
(
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Kennedy'),
    'Viernes',
    '08:00',
    '22:00',
    FALSE,
    FALSE
),
(
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Kennedy'),
    'Sábado',
    '08:00',
    '22:00',
    FALSE,
    FALSE
),
(
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Kennedy'),
    'Domingo',
    NULL,
    NULL,
    FALSE,
    TRUE
),
(
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Chapinero'),
    'Lunes',
    '06:00',
    '23:00',
    FALSE,
    FALSE
),
(
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Chapinero'),
    'Martes',
    '06:00',
    '23:00',
    FALSE,
    FALSE
),
(
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Chapinero'),
    'Miércoles',
    '06:00',
    '23:00',
    FALSE,
    FALSE
),
(
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Chapinero'),
    'Jueves',
    '06:00',
    '23:00',
    FALSE,
    FALSE
),
(
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Chapinero'),
    'Viernes',
    '06:00',
    '23:00',
    FALSE,
    FALSE
),
(
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Chapinero'),
    'Sábado',
    NULL,
    NULL,
    TRUE,
    FALSE
),
(
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Chapinero'),
    'Domingo',
    NULL,
    NULL,
    FALSE,
    TRUE
),
(
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Suba'),
    'Lunes',
    '06:00',
    '23:00',
    FALSE,
    FALSE
),
(
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Suba'),
    'Martes',
    '07:00',
    '23:00',
    FALSE,
    FALSE
),
(
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Suba'),
    'Miércoles',
    '12:00',
    '23:00',
    FALSE,
    FALSE
),
(
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Suba'),
    'Jueves',
    '09:00',
    '20:00',
    FALSE,
    FALSE
),
(
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Suba'),
    'Viernes',
    '13:00',
    '22:00',
    FALSE,
    FALSE
),
(
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Suba'),
    'Sábado',
    NULL,
    NULL,
    TRUE,
    FALSE
),
(
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Suba'),
    'Domingo',
    NULL,
    NULL,
    FALSE,
    TRUE
),
(
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Ciudad Bolivar'),
    'Lunes',
    '02:00',
    '23:00',
    FALSE,
    FALSE
),
(
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Ciudad Bolivar'),
    'Martes',
    '06:00',
    '23:00',
    FALSE,
    FALSE
),
(
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Ciudad Bolivar'),
    'Miércoles',
    '05:00',
    '20:00',
    FALSE,
    FALSE
),
(
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Ciudad Bolivar'),
    'Jueves',
    '04:00',
    '19:00',
    FALSE,
    FALSE
),
(
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Ciudad Bolivar'),
    'Viernes',
    '04:00',
    '19:00',
    FALSE,
    FALSE
),
(
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Ciudad Bolivar'),
    'Sábado',
    NULL,
    NULL,
    TRUE,
    FALSE
),
(
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Ciudad Bolivar'),
    'Domingo',
    NULL,
    NULL,
    FALSE,
    TRUE
);

-- Insertar slot de parqueaderos en una sucursal
INSERT INTO PARQUEADERO.SLOT_PARQUEADERO(
    K_SLOT_PARQUEADERO,
    K_SUCURSAL,
    ES_CUBIERTO,
    TIPO_PARQUEADERO
) VALUES (
    'A1',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Kennedy'),
    TRUE,
    'SUV'
),
(
    'A2',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Kennedy'),
    TRUE,
    'SUV'
),
(
    'A3',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Kennedy'),
    TRUE,
    'SUV'
),
(
    'A4',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Kennedy'),
    TRUE,
    'SUV'
),
(
    'A5',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Kennedy'),
    TRUE,
    'SUV'
),
(
    'A6',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Kennedy'),
    TRUE,
    'SUV'
),
(
    'A7',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Kennedy'),
    TRUE,
    'SUV'
),
(
    'A8',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Kennedy'),
    TRUE,
    'SUV'
),
(
    'A9',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Kennedy'),
    TRUE,
    'SUV'
),
(
    'A10',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Kennedy'),
    TRUE,
    'SUV'
),
(
    'A11',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Kennedy'),
    TRUE,
    'SUV'
),
(
    'A12',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Kennedy'),
    TRUE,
    'SUV'
),
(
    'A13',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Kennedy'),
    TRUE,
    'SUV'
),
(
    'A14',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Kennedy'),
    TRUE,
    'SUV'
),
(
    'A15',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Kennedy'),
    TRUE,
    'SUV'
),
(
    'A16',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Kennedy'),
    TRUE,
    'SUV'
),
(
    'A17',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Kennedy'),
    TRUE,
    'SUV'
),
(
    'A18',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Kennedy'),
    TRUE,
    'SUV'
),
(
    'A19',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Kennedy'),
    TRUE,
    'SUV'
),
(
    'A20',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Kennedy'),
    TRUE,
    'SUV'
),
(
    'A21',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Kennedy'),
    TRUE,
    'SUV'
),
(
    'A22',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Kennedy'),
    TRUE,
    'SUV'
),
(
    'A23',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Kennedy'),
    TRUE,
    'SUV'
),
(
    'A24',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Kennedy'),
    TRUE,
    'SUV'
),
(
    'A25',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Kennedy'),
    TRUE,
    'SUV'
),
(
    'A26',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Kennedy'),
    TRUE,
    'SUV'
),
(
    'A27',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Kennedy'),
    TRUE,
    'SUV'
),
(
    'B1',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Kennedy'),
    TRUE,
    'Automóvil'
),
(
    'B2',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Kennedy'),
    TRUE,
    'Automóvil'
),
(
    'B3',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Kennedy'),
    TRUE,
    'Automóvil'
),
(
    'B4',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Kennedy'),
    TRUE,
    'Automóvil'
),
(
    'B5',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Kennedy'),
    TRUE,
    'Automóvil'
),
(
    'B6',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Kennedy'),
    TRUE,
    'Automóvil'
),
(
    'B7',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Kennedy'),
    TRUE,
    'Automóvil'
),
(
    'B8',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Kennedy'),
    TRUE,
    'Automóvil'
),
(
    'B9',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Kennedy'),
    TRUE,
    'Automóvil'
),
(
    'B10',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Kennedy'),
    TRUE,
    'Automóvil'
),
(
    'B11',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Kennedy'),
    TRUE,
    'Automóvil'
),
(
    'B12',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Kennedy'),
    TRUE,
    'Automóvil'
),
(
    'B13',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Kennedy'),
    TRUE,
    'Automóvil'
),
(
    'B14',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Kennedy'),
    TRUE,
    'Automóvil'
),
(
    'B15',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Kennedy'),
    TRUE,
    'Automóvil'
),
(
    'B16',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Kennedy'),
    TRUE,
    'Automóvil'
),
(
    'B17',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Kennedy'),
    TRUE,
    'Automóvil'
),
(
    'B18',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Kennedy'),
    TRUE,
    'Automóvil'
),
(
    'B19',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Kennedy'),
    TRUE,
    'Automóvil'
),
(
    'B20',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Kennedy'),
    TRUE,
    'Automóvil'
),
(
    'B21',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Kennedy'),
    TRUE,
    'Automóvil'
),
(
    'B22',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Kennedy'),
    TRUE,
    'Automóvil'
),
(
    'B23',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Kennedy'),
    TRUE,
    'Automóvil'
),
(
    'B24',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Kennedy'),
    TRUE,
    'Automóvil'
),
(
    'B25',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Kennedy'),
    TRUE,
    'Automóvil'
),
(
    'B26',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Kennedy'),
    TRUE,
    'Automóvil'
),
(
    'B27',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Kennedy'),
    TRUE,
    'Automóvil'
),
(
    'A1',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Chapinero'),
    TRUE,
    'SUV'
),
(
    'A2',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Chapinero'),
    TRUE,
    'SUV'
),
(
    'A3',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Chapinero'),
    TRUE,
    'SUV'
),
(
    'A4',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Chapinero'),
    TRUE,
    'SUV'
),
(
    'A5',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Chapinero'),
    TRUE,
    'SUV'
),
(
    'A6',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Chapinero'),
    TRUE,
    'SUV'
),
(
    'A7',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Chapinero'),
    TRUE,
    'SUV'
),
(
    'A8',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Chapinero'),
    TRUE,
    'SUV'
),
(
    'A9',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Chapinero'),
    TRUE,
    'SUV'
),
(
    'A10',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Chapinero'),
    TRUE,
    'SUV'
),
(
    'A11',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Chapinero'),
    TRUE,
    'SUV'
),
(
    'A12',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Chapinero'),
    TRUE,
    'SUV'
),
(
    'A13',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Chapinero'),
    TRUE,
    'SUV'
),
(
    'A14',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Chapinero'),
    TRUE,
    'SUV'
),
(
    'A15',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Chapinero'),
    TRUE,
    'SUV'
),
(
    'A16',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Chapinero'),
    TRUE,
    'SUV'
),
(
    'A17',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Chapinero'),
    TRUE,
    'SUV'
),
(
    'A18',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Chapinero'),
    TRUE,
    'SUV'
),
(
    'A19',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Chapinero'),
    TRUE,
    'SUV'
),
(
    'A20',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Chapinero'),
    TRUE,
    'SUV'
),
(
    'A21',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Chapinero'),
    TRUE,
    'SUV'
),
(
    'A22',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Chapinero'),
    TRUE,
    'SUV'
),
(
    'A23',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Chapinero'),
    TRUE,
    'SUV'
),
(
    'A24',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Chapinero'),
    TRUE,
    'SUV'
),
(
    'A25',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Chapinero'),
    TRUE,
    'SUV'
),
(
    'A26',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Chapinero'),
    TRUE,
    'SUV'
),
(
    'A27',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Chapinero'),
    TRUE,
    'SUV'
),
(
    'B1',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Chapinero'),
    TRUE,
    'Automóvil'
),
(
    'B2',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Chapinero'),
    TRUE,
    'Automóvil'
),
(
    'B3',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Chapinero'),
    TRUE,
    'Automóvil'
),
(
    'B4',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Chapinero'),
    TRUE,
    'Automóvil'
),
(
    'B5',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Chapinero'),
    TRUE,
    'Automóvil'
),
(
    'B6',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Chapinero'),
    TRUE,
    'Automóvil'
),
(
    'B7',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Chapinero'),
    TRUE,
    'Automóvil'
),
(
    'B8',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Chapinero'),
    TRUE,
    'Automóvil'
),
(
    'B9',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Chapinero'),
    TRUE,
    'Automóvil'
),
(
    'B10',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Chapinero'),
    TRUE,
    'Automóvil'
),
(
    'B11',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Chapinero'),
    TRUE,
    'Automóvil'
),
(
    'B12',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Chapinero'),
    TRUE,
    'Automóvil'
),
(
    'B13',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Chapinero'),
    TRUE,
    'Automóvil'
),
(
    'B14',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Chapinero'),
    TRUE,
    'Automóvil'
),
(
    'B15',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Chapinero'),
    TRUE,
    'Automóvil'
),
(
    'B16',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Chapinero'),
    TRUE,
    'Automóvil'
),
(
    'B17',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Chapinero'),
    TRUE,
    'Automóvil'
),
(
    'B18',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Chapinero'),
    TRUE,
    'Automóvil'
),
(
    'B19',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Chapinero'),
    TRUE,
    'Automóvil'
),
(
    'B20',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Chapinero'),
    TRUE,
    'Automóvil'
),
(
    'B21',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Chapinero'),
    TRUE,
    'Automóvil'
),
(
    'B22',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Chapinero'),
    TRUE,
    'Automóvil'
),
(
    'B23',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Chapinero'),
    TRUE,
    'Automóvil'
),
(
    'B24',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Chapinero'),
    TRUE,
    'Automóvil'
),
(
    'B25',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Chapinero'),
    TRUE,
    'Automóvil'
),
(
    'B26',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Chapinero'),
    TRUE,
    'Automóvil'
),
(
    'B27',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Chapinero'),
    TRUE,
    'Automóvil'
),
(
    'A1',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Suba'),
    TRUE,
    'SUV'
),
(
    'A2',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Suba'),
    TRUE,
    'SUV'
),
(
    'A3',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Suba'),
    TRUE,
    'SUV'
),
(
    'A4',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Suba'),
    TRUE,
    'SUV'
),
(
    'A5',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Suba'),
    TRUE,
    'SUV'
),
(
    'A6',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Suba'),
    TRUE,
    'SUV'
),
(
    'A7',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Suba'),
    TRUE,
    'SUV'
),
(
    'A8',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Suba'),
    TRUE,
    'SUV'
),
(
    'A9',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Suba'),
    TRUE,
    'SUV'
),
(
    'A10',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Suba'),
    TRUE,
    'SUV'
),
(
    'A11',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Suba'),
    TRUE,
    'SUV'
),
(
    'A12',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Suba'),
    TRUE,
    'SUV'
),
(
    'A13',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Suba'),
    TRUE,
    'SUV'
),
(
    'A14',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Suba'),
    TRUE,
    'SUV'
),
(
    'A15',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Suba'),
    TRUE,
    'SUV'
),
(
    'A16',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Suba'),
    TRUE,
    'SUV'
),
(
    'A17',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Suba'),
    TRUE,
    'SUV'
),
(
    'A18',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Suba'),
    TRUE,
    'SUV'
),
(
    'A19',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Suba'),
    TRUE,
    'SUV'
),
(
    'A20',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Suba'),
    TRUE,
    'SUV'
),
(
    'A21',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Suba'),
    TRUE,
    'SUV'
),
(
    'A22',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Suba'),
    TRUE,
    'SUV'
),
(
    'A23',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Suba'),
    TRUE,
    'SUV'
),
(
    'A24',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Suba'),
    TRUE,
    'SUV'
),
(
    'A25',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Suba'),
    TRUE,
    'SUV'
),
(
    'A26',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Suba'),
    TRUE,
    'SUV'
),
(
    'A27',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Suba'),
    TRUE,
    'SUV'
),
(
    'B1',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Suba'),
    TRUE,
    'Automóvil'
),
(
    'B2',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Suba'),
    TRUE,
    'Automóvil'
),
(
    'B3',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Suba'),
    TRUE,
    'Automóvil'
),
(
    'B4',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Suba'),
    TRUE,
    'Automóvil'
),
(
    'B5',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Suba'),
    TRUE,
    'Automóvil'
),
(
    'B6',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Suba'),
    TRUE,
    'Automóvil'
),
(
    'B7',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Suba'),
    TRUE,
    'Automóvil'
),
(
    'B8',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Suba'),
    TRUE,
    'Automóvil'
),
(
    'B9',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Suba'),
    TRUE,
    'Automóvil'
),
(
    'B10',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Suba'),
    TRUE,
    'Automóvil'
),
(
    'B11',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Suba'),
    TRUE,
    'Automóvil'
),
(
    'B12',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Suba'),
    TRUE,
    'Automóvil'
),
(
    'B13',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Suba'),
    TRUE,
    'Automóvil'
),
(
    'B14',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Suba'),
    TRUE,
    'Automóvil'
),
(
    'B15',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Suba'),
    TRUE,
    'Automóvil'
),
(
    'B16',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Suba'),
    TRUE,
    'Automóvil'
),
(
    'B17',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Suba'),
    TRUE,
    'Automóvil'
),
(
    'B18',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Suba'),
    TRUE,
    'Automóvil'
),
(
    'B19',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Suba'),
    TRUE,
    'Automóvil'
),
(
    'B20',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Suba'),
    TRUE,
    'Automóvil'
),
(
    'B21',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Suba'),
    TRUE,
    'Automóvil'
),
(
    'B22',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Suba'),
    TRUE,
    'Automóvil'
),
(
    'B23',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Suba'),
    TRUE,
    'Automóvil'
),
(
    'B24',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Suba'),
    TRUE,
    'Automóvil'
),
(
    'B25',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Suba'),
    TRUE,
    'Automóvil'
),
(
    'B26',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Suba'),
    TRUE,
    'Automóvil'
),
(
    'B27',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Suba'),
    TRUE,
    'Automóvil'
),
(
    'A1',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Ciudad Bolivar'),
    TRUE,
    'SUV'
),
(
    'A2',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Ciudad Bolivar'),
    TRUE,
    'SUV'
),
(
    'A3',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Ciudad Bolivar'),
    TRUE,
    'SUV'
),
(
    'A4',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Ciudad Bolivar'),
    TRUE,
    'SUV'
),
(
    'A5',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Ciudad Bolivar'),
    TRUE,
    'SUV'
),
(
    'A6',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Ciudad Bolivar'),
    TRUE,
    'SUV'
),
(
    'A7',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Ciudad Bolivar'),
    TRUE,
    'SUV'
),
(
    'A8',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Ciudad Bolivar'),
    TRUE,
    'SUV'
),
(
    'A9',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Ciudad Bolivar'),
    TRUE,
    'SUV'
),
(
    'A10',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Ciudad Bolivar'),
    TRUE,
    'SUV'
),
(
    'A11',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Ciudad Bolivar'),
    TRUE,
    'SUV'
),
(
    'A12',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Ciudad Bolivar'),
    TRUE,
    'SUV'
),
(
    'A13',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Ciudad Bolivar'),
    TRUE,
    'SUV'
),
(
    'A14',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Ciudad Bolivar'),
    TRUE,
    'SUV'
),
(
    'A15',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Ciudad Bolivar'),
    TRUE,
    'SUV'
),
(
    'A16',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Ciudad Bolivar'),
    TRUE,
    'SUV'
),
(
    'A17',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Ciudad Bolivar'),
    TRUE,
    'SUV'
),
(
    'A18',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Ciudad Bolivar'),
    TRUE,
    'SUV'
),
(
    'A19',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Ciudad Bolivar'),
    TRUE,
    'SUV'
),
(
    'A20',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Ciudad Bolivar'),
    TRUE,
    'SUV'
),
(
    'A21',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Ciudad Bolivar'),
    TRUE,
    'SUV'
),
(
    'A22',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Ciudad Bolivar'),
    TRUE,
    'SUV'
),
(
    'A23',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Ciudad Bolivar'),
    TRUE,
    'SUV'
),
(
    'A24',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Ciudad Bolivar'),
    TRUE,
    'SUV'
),
(
    'A25',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Ciudad Bolivar'),
    TRUE,
    'SUV'
),
(
    'A26',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Ciudad Bolivar'),
    TRUE,
    'SUV'
),
(
    'A27',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Ciudad Bolivar'),
    TRUE,
    'SUV'
),
(
    'B1',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Ciudad Bolivar'),
    TRUE,
    'Automóvil'
),
(
    'B2',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Ciudad Bolivar'),
    TRUE,
    'Automóvil'
),
(
    'B3',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Ciudad Bolivar'),
    TRUE,
    'Automóvil'
),
(
    'B4',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Ciudad Bolivar'),
    TRUE,
    'Automóvil'
),
(
    'B5',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Ciudad Bolivar'),
    TRUE,
    'Automóvil'
),
(
    'B6',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Ciudad Bolivar'),
    TRUE,
    'Automóvil'
),
(
    'B7',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Ciudad Bolivar'),
    TRUE,
    'Automóvil'
),
(
    'B8',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Ciudad Bolivar'),
    TRUE,
    'Automóvil'
),
(
    'B9',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Ciudad Bolivar'),
    TRUE,
    'Automóvil'
),
(
    'B10',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Ciudad Bolivar'),
    TRUE,
    'Automóvil'
),
(
    'B11',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Ciudad Bolivar'),
    TRUE,
    'Automóvil'
),
(
    'B12',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Ciudad Bolivar'),
    TRUE,
    'Automóvil'
),
(
    'B13',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Ciudad Bolivar'),
    TRUE,
    'Automóvil'
),
(
    'B14',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Ciudad Bolivar'),
    TRUE,
    'Automóvil'
),
(
    'B15',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Ciudad Bolivar'),
    TRUE,
    'Automóvil'
),
(
    'B16',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Ciudad Bolivar'),
    TRUE,
    'Automóvil'
),
(
    'B17',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Ciudad Bolivar'),
    TRUE,
    'Automóvil'
),
(
    'B18',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Ciudad Bolivar'),
    TRUE,
    'Automóvil'
),
(
    'B19',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Ciudad Bolivar'),
    TRUE,
    'Automóvil'
),
(
    'B20',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Ciudad Bolivar'),
    TRUE,
    'Automóvil'
),
(
    'B21',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Ciudad Bolivar'),
    TRUE,
    'Automóvil'
),
(
    'B22',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Ciudad Bolivar'),
    TRUE,
    'Automóvil'
),
(
    'B23',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Ciudad Bolivar'),
    TRUE,
    'Automóvil'
),
(
    'B24',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Ciudad Bolivar'),
    TRUE,
    'Automóvil'
),
(
    'B25',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Ciudad Bolivar'),
    TRUE,
    'Automóvil'
),
(
    'B26',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Ciudad Bolivar'),
    TRUE,
    'Automóvil'
),
(
    'B27',
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Ciudad Bolivar'),
    TRUE,
    'Automóvil'
);

-- Insertar un administrador
INSERT INTO PARQUEADERO.EMPLEADO(
    TIPO_IDENTIFICACION_EMPLEADO,
    NUMERO_IDENTIFICACION_EMP,
    NOMBRE1_EMPLEADO,
    NOMBRE2_EMPLEADO,
    APELLIDO1_EMPLEADO,
    APELLIDO2_EMPLEADO,
    TELEFONO_EMPLEADO,
    CORREO_EMPLEADO
) VALUES (
    'CC',
    '1042389654',
    'Andrés',
    'Felipe',
    'Morera',
    'Díaz',
    3001479652,
    'anresxoxo@gnalga.com'
);

INSERT INTO PARQUEADERO.EJERCE(
    K_NOMBRE_CARGO,
    K_EMPLEADO,
    FECHA_INICIO_CARGO,
    FECHA_FIN_CARGO,
    ES_CARGO_ACTIVO
) VALUES (
    'Administrador',
    ( SELECT K_EMPLEADO FROM PARQUEADERO.EMPLEADO WHERE NUMERO_IDENTIFICACION_EMP = '1042389654'),
    TO_DATE('DD/MM/YYYY', '20/02/2023'),
    NULL,
    TRUE
);

-- Insertar el administrador en la sucursal creada
INSERT INTO PARQUEADERO.TRABAJA(
    K_SUCURSAL,
    K_EMPLEADO
) VALUES (
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Kennedy'),
    ( SELECT K_EMPLEADO FROM PARQUEADERO.EMPLEADO WHERE NUMERO_IDENTIFICACION_EMP = '1042389654')
);

-- Insertar una promoción en la sucursal
INSERT INTO PARQUEADERO.PROMOCION(
    K_SUCURSAL,
    FECHA_PROMOCION,
    FECHA_ACTIVA_DESDE,
    FECHA_ACTIVA_HASTA,
    DESCRIPCION_PROMOCION
) VALUES (
    ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Kennedy'),
    ( SELECT CURRENT_TIMESTAMP AT TIME ZONE 'America/Bogota'),
    ( SELECT TO_TIMESTAMP('01/03/2023 08:00', 'DD/MM/YYYY HH24:MI')),
    ( SELECT TO_TIMESTAMP('01/04/2023 08:00', 'DD/MM/YYYY HH24:MI')),
    '¡Obtenga 1000 puntos por cada reserva hecha con SUV!'
);

INSERT INTO PARQUEADERO.PROMOCION_POR_RESERVA(
    K_PROMOCION,
    PUNTOS_POR_RESERVA,
    ADICION_RESERVA_SUV,
    ADICION_RESERVA_AUTO,
    ADICION_RESERVA_MOTO,
    ADICION_PARQ_CUBIERTO,
    ADICION_PARQ_DESCUBIERTO
) VALUES (
    1,
    1,
    1000,
    0,
    0,
    0,
    0
);

-- Insertar un cliente
INSERT INTO PARQUEADERO.CLIENTE(
    TIPO_IDENTIFICACION_CLIENTE,
    NUMERO_IDENTIFICACION_CLIENTE,
    NOMBRE1_CLIENTE,
    NOMBRE2_CLIENTE,
    APELLIDO1_CLIENTE,
    APELLIDO2_CLIENTE,
    TELEFONO_CLIENTE,
    CORREO_CLIENTE
) VALUES (
    'CC',
    '1325478632',
    'Violet',
    NULL,
    'Valmont',
    'Azahar',
    3068741232,
    ( SELECT PARQUEADERO.PGP_SYM_ENCRYPT('valmont@hotmail.com'::VARCHAR, 'AES_KEY'::VARCHAR))
);

-- Insertar un método de pago para el cliente
INSERT INTO PARQUEADERO.TARJETA_PAGO(
    K_CLIENTE,
    NOMBRE_DUENIO_TARJETA,
    APELLIDO_DUENIO_TARJETA,
    NUMERO_TARJETA,
    ULTIMOS_CUATRO_DIGITOS,
    MES_VENCIMIENTO,
    ANIO_VENCIMIENTO,
    TIPO_TARJETA
) VALUES (
    ( SELECT K_CLIENTE FROM PARQUEADERO.CLIENTE WHERE NUMERO_IDENTIFICACION_CLIENTE = '1325478632'),
    ( SELECT PARQUEADERO.PGP_SYM_ENCRYPT('Violet', 'AES_KEY')),
    ( SELECT PARQUEADERO.PGP_SYM_ENCRYPT('Valmont', 'AES_KEY')),
    ( SELECT PARQUEADERO.PGP_SYM_ENCRYPT('4124896532107458', 'AES_KEY')),
    ( SELECT PARQUEADERO.PGP_SYM_ENCRYPT('7458', 'AES_KEY')),
    ( SELECT PARQUEADERO.PGP_SYM_ENCRYPT('12', 'AES_KEY')),
    ( SELECT PARQUEADERO.PGP_SYM_ENCRYPT('2028', 'AES_KEY')),
    ( SELECT PARQUEADERO.PGP_SYM_ENCRYPT('Visa', 'AES_KEY'))
);

-- Insertar un vehículo para el cliente
INSERT INTO PARQUEADERO.VEHICULO(
    K_MARCA_VEHICULO,
    K_CLIENTE,
    PLACA_VEHICULO,
    NOMBRE1_PROPIETARIO,
    NOMBRE2_PROPIETARIO,
    APELLIDO1_PROPIETARIO,
    APELLIDO2_PROPIETARIO,
    TIPO_VEHICULO,
    COLOR_VEHICULO
) VALUES (
    'Volkswagen',
    ( SELECT K_CLIENTE FROM PARQUEADERO.CLIENTE WHERE NUMERO_IDENTIFICACION_CLIENTE = '1325478632'),
    'FLS895',
    'Violet',
    NULL,
    'Valmont',
    'Azahar',
    'SUV',
    'Negro'
);

-- Insertar el plan de fidelización de un cliente
INSERT INTO PARQUEADERO.FIDELIZACION_CLIENTE(
    K_CLIENTE,
    CANTIDAD_PUNTOS,
    FECHA_INICIO_PUNTAJE,
    FECHA_FIN_PUNTAJE,
    ES_ACTUAL
) VALUES (
    ( SELECT K_CLIENTE FROM PARQUEADERO.CLIENTE WHERE NUMERO_IDENTIFICACION_CLIENTE = '1325478632'),
    0,
    ( SELECT CURRENT_TIMESTAMP AT TIME ZONE 'America/Bogota'),
    NULL,
    TRUE
);

-- Insertar una reserva
-- INSERT INTO PARQUEADERO.RESERVA(
--     K_CLIENTE,
--     K_PROMOCION,
--     K_FIDELIZACION,
--     K_SUCURSAL,
--     K_SLOT_PARQUEADERO,
--     FECHA_RESERVA,
--     FECHA_INICIO_RESERVA,
--     PUNTOS_USADOS,
--     FECHA_SALIDA_VEHICULO,
--     ESTA_ACTIVA,
--     VALOR_RESERVA,
--     PUNTOS_ACUMULADOS
-- ) VALUES (
--     ( SELECT K_CLIENTE FROM PARQUEADERO.CLIENTE WHERE NUMERO_IDENTIFICACION_CLIENTE = '1325478632'),
--     1,
--     ( SELECT K_FIDELIZACION FROM PARQUEADERO.FIDELIZACION_CLIENTE WHERE K_CLIENTE =( SELECT K_CLIENTE FROM PARQUEADERO.CLIENTE WHERE NUMERO_IDENTIFICACION_CLIENTE = '1325478632')),
--     ( SELECT K_SUCURSAL FROM PARQUEADERO.SUCURSAL WHERE NOMBRE_SUCURSAL = 'Sucursal Kennedy'),
--     'A1',
--     ( SELECT CURRENT_TIMESTAMP AT TIME ZONE 'America/Bogota'),
--     ( SELECT TO_TIMESTAMP('27/04/2023 16:00', 'DD/MM/YYYY HH24:MI')),
--     0,
--     NULL,
--     TRUE,
--     NULL,
--     NULL
-- );