-- =====================================================
-- Lote de inserciones directas para tabla ciudad (50 registros)
-- =====================================================
INSERT INTO ciudad (id_ciudad, nombre, id_provincia) VALUES
-- Buenos Aires (1)
(1, 'La Plata', 1),
(2, 'Mar del Plata', 1),
(3, 'Bahía Blanca', 1),

-- CABA (2)
(4, 'Buenos Aires', 2),

-- Catamarca (3)
(5, 'San Fernando del Valle de Catamarca', 3),
(6, 'Belén', 3),

-- Chaco (4)
(7, 'Resistencia', 4),
(8, 'Roque Sáenz Peña', 4),

-- Chubut (5)
(9, 'Rawson', 5),
(10, 'Comodoro Rivadavia', 5),

-- Córdoba (6)
(11, 'Córdoba Capital', 6),
(12, 'Villa Carlos Paz', 6),
(13, 'Río Cuarto', 6),

-- Corrientes (7)
(14, 'Corrientes Capital', 7),
(15, 'Goya', 7),

-- Entre Ríos (8)
(16, 'Paraná', 8),
(17, 'Concordia', 8),
(18, 'Gualeguaychú', 8),

-- Formosa (9)
(19, 'Formosa Capital', 9),

-- Jujuy (10)
(20, 'San Salvador de Jujuy', 10),
(21, 'Palpalá', 10),

-- La Pampa (11)
(22, 'Santa Rosa', 11),
(23, 'General Pico', 11),

-- La Rioja (12)
(24, 'La Rioja Capital', 12),

-- Mendoza (13)
(25, 'Mendoza Capital', 13),
(26, 'San Rafael', 13),
(27, 'Godoy Cruz', 13),

-- Misiones (14)
(28, 'Posadas', 14),
(29, 'Oberá', 14),

-- Neuquén (15)
(30, 'Neuquén Capital', 15),
(31, 'Cutral Có', 15),

-- Río Negro (16)
(32, 'Viedma', 16),
(33, 'Bariloche', 16),

-- Salta (17)
(34, 'Salta Capital', 17),
(35, 'Cafayate', 17),

-- San Juan (18)
(36, 'San Juan Capital', 18),
(37, 'Caucete', 18),

-- San Luis (19)
(38, 'San Luis Capital', 19),
(39, 'Villa Mercedes', 19),

-- Santa Cruz (20)
(40, 'Río Gallegos', 20),
(41, 'Caleta Olivia', 20),

-- Santa Fe (21)
(42, 'Santa Fe Capital', 21),
(43, 'Rosario', 21),
(44, 'Rafaela', 21),

-- Santiago del Estero (22)
(45, 'Santiago del Estero', 22),
(46, 'La Banda', 22),

-- Tierra del Fuego (23)
(47, 'Ushuaia', 23),
(48, 'Río Grande', 23),

-- Tucumán (24)
(49, 'San Miguel de Tucumán', 24),
(50, 'Yerba Buena', 24);

PRINT 'Inserciones en tabla ciudad completadas (50 ciudades).';
GO
