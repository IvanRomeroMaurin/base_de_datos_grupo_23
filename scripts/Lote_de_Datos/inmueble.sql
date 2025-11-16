
-- ============================
-- 7. INMUEBLE 
-- ============================
INSERT INTO inmueble (id_inmueble, descripcion, id_tipo_inmueble, dni, id_direccion, id_disponibilidad, estado) VALUES
(1, 'Departamento 2 ambientes en Centro', 1, 15542462, 31, 1, 1),
(2, 'Casa amplia 3 dormitorios', 2, 16084924, 32, 1, 1),
(3, 'PH 2 ambientes con patio', 3, 16084924, 33, 1, 1),
(4, 'Monoambiente luminoso', 1, 16084924, 34, 1, 1),
(5, 'Casa con pileta y garage', 2, 16898617, 35, 1, 1),
(6, 'Departamento 3 ambientes Microcentro', 1, 16898617, 36, 1, 1),
(7, 'PH interno, 1 dormitorio', 3, 16898617, 37, 1, 1),
(8, 'Casa antigua a refaccionar', 2, 17441079, 38, 1, 1),
(9, 'Departamento 4 ambientes, vista al frente', 1, 17441079, 39, 1, 1),
(10, 'Casa en B° Norte, 2 plantas', 2, 17441079, 40, 1, 1),
(11, 'Monoambiente en Nueva Córdoba', 1, 17441079, 41, 1, 1),
(12, 'PH al fondo, 2 dormitorios', 3, 18526003, 42, 1, 1),
(13, 'Departamento céntrico, 1 amb', 1, 18526003, 43, 1, 1),
(14, 'Casa con fondo grande', 2, 18526003, 44, 1, 1),
(15, 'Departamento 2 amb, contrafrente', 1, 18526003, 45, 1, 1),

-- *** Inmuebles NO DISPONIBLES (Para probar validaciones) ***

-- Ya está Alquilado (id_disponibilidad = 2)
(16, 'Departamento 1 dormitorio (Alquilado)', 1, 19068465, 46, 2, 1),
-- Está Inactivo (estado = 0)
(17, 'Casa en B° Sur (Inactiva)', 2, 19068465, 47, 1, 0),
-- Está Alquilado (id_disponibilidad = 2)
(18, 'PH en Nueva Córdoba (Alquilado)', 3, 19068465, 48, 2, 1),
-- Está Inactivo (estado = 0)
(19, 'Departamento B° Oeste (Inactivo)', 1, 19068465, 49, 1, 0),
-- Está Alquilado e Inactivo (Debe fallar por ambas)
(20, 'Casa céntrica (Alquilada e Inactiva)', 2, 20695851, 50, 2, 0),

-- *** Otros disponibles para usar ***
(21, 'Casa 4 ambientes Sur', 2, 20695851, 51, 1, 1),
(22, 'PH en B° Norte', 3, 20695851, 52, 1, 1);
GO

PRINT 'Inserciones en tabla inmueble completadas (22 registros).';
GO