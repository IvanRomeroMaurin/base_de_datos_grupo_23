USE alquiler_pro;
GO

INSERT INTO inmueble (id_inmueble, descripcion, id_tipo_inmueble, dni, id_direccion, id_disponibilidad, estado) VALUES
(1, 'Departamento 2 ambientes en Centro', 1, 15271231, 1, 1, 1),
(2, 'Casa amplia 3 dormitorios', 2, 15542462, 2, 1, 1),
(3, 'PH 2 ambientes con patio', 3, 15813693, 3, 1, 1),
(4, 'Monoambiente luminoso', 1, 16084924, 4, 1, 1),
(5, 'Casa con pileta y garage', 2, 16356155, 5, 1, 1),
(6, 'Departamento 3 ambientes Microcentro', 1, 16627386, 6, 1, 1),
(7, 'PH interno, 1 dormitorio', 3, 16898617, 7, 1, 1),
(8, 'Casa antigua a refaccionar', 2, 17169848, 8, 1, 1),
(9, 'Departamento 4 ambientes, vista al frente', 1, 17441079, 9, 1, 1),
(10, 'Casa en B° Norte, 2 plantas', 2, 17712310, 10, 1, 1),
(11, 'Monoambiente en Nueva Córdoba', 1, 17983541, 11, 1, 1),
(12, 'PH al fondo, 2 dormitorios', 3, 18254772, 12, 1, 1),
(13, 'Departamento céntrico, 1 amb', 1, 18526003, 13, 1, 1),
(14, 'Casa con fondo grande', 2, 18797234, 14, 1, 1),
(15, 'Departamento 2 amb, contrafrente', 1, 19068465, 15, 1, 1),

-- *** Inmuebles NO DISPONIBLES (Para probar validaciones) ***

-- Ya está Alquilado (id_disponibilidad = 2)
(16, 'Departamento 1 dormitorio (Alquilado)', 1, 19339696, 16, 2, 1),
-- Está Inactivo (estado = 0)
(17, 'Casa en B° Sur (Inactiva)', 2, 19610927, 17, 1, 0),
-- Está Alquilado (id_disponibilidad = 2)
(18, 'PH en Nueva Córdoba (Alquilado)', 3, 19882158, 18, 2, 1),
-- Está Inactivo (estado = 0)
(19, 'Departamento B° Oeste (Inactivo)', 1, 20153389, 19, 1, 0),
-- Está Alquilado e Inactivo (Debe fallar por ambas)
(20, 'Casa céntrica (Alquilada e Inactiva)', 2, 20424620, 20, 2, 0),

-- *** Otros disponibles para usar ***
(21, 'Casa 4 ambientes Sur', 2, 20695851, 21, 1, 1),
(22, 'PH en B° Norte', 3, 20967082, 22, 1, 1);
GO

PRINT '✅ Inserciones en tabla inmueble completadas (22 registros).';
GO