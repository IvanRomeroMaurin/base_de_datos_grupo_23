-- =====================================================
-- LOTE 1: Inserciones directas en tabla persona (100 registros)
-- DNIs entre 15M y 45M, únicos en este bloque
-- =====================================================
INSERT INTO persona (dni, nombre, apellido, correo_electronico, telefono, fecha_nacimiento, id_direccion, estado) VALUES
(15271231, 'Juan', 'Pérez', 'juan.perez01@mail.com', '3715550001', '1985-04-15', 1, 1),
(15542462, 'María', 'Gómez', 'maria.gomez02@mail.com', '3715550002', '1990-09-10', 2, 1),
(15813693, 'Carlos', 'López', 'carlos.lopez03@mail.com', '3715550003', '1988-02-22', 3, 1),
(16084924, 'Ana', 'Fernández', 'ana.fernandez04@mail.com', '3715550004', '1995-12-05', 4, 1),
(16356155, 'Lucía', 'Martínez', 'lucia.martinez05@mail.com', '3715550005', '1992-03-30', 5, 1),
(16627386, 'Pedro', 'Ramos', 'pedro.ramos06@mail.com', '3715550006', '1980-07-20', 6, 1),
(16898617, 'Sofía', 'Molina', 'sofia.molina07@mail.com', '3715550007', '1989-01-05', 7, 1),
(17169848, 'Gabriel', 'Torres', 'gabriel.torres08@mail.com', '3715550008', '1993-08-23', 8, 1),
(17441079, 'Valentina', 'Sosa', 'valentina.sosa09@mail.com', '3715550009', '1997-10-11', 9, 1),
(17712310, 'Joaquín', 'Romero', 'joaquin.romero10@mail.com', '3715550010', '1994-11-28', 10, 1),
(17983541, 'Martín', 'Aguilar', 'martin.aguilar11@mail.com', '3715550011', '1987-03-12', 11, 1),
(18254772, 'Florencia', 'Campos', 'florencia.campos12@mail.com', '3715550012', '1992-05-22', 12, 1),
(18526003, 'Andrés', 'Vega', 'andres.vega13@mail.com', '3715550013', '1986-09-09', 13, 1),
(18797234, 'Natalia', 'Ruiz', 'natalia.ruiz14@mail.com', '3715550014', '1990-10-01', 14, 1),
(19068465, 'Hernán', 'Cruz', 'hernan.cruz15@mail.com', '3715550015', '1985-12-25', 15, 1),
(19339696, 'Camila', 'Juárez', 'camila.juarez16@mail.com', '3715550016', '1998-02-15', 16, 1),
(19610927, 'Santiago', 'Acosta', 'santiago.acosta17@mail.com', '3715550017', '1984-07-03', 17, 1),
(19882158, 'Laura', 'Benítez', 'laura.benitez18@mail.com', '3715550018', '1991-04-10', 18, 1),
(20153389, 'Franco', 'Arias', 'franco.arias19@mail.com', '3715550019', '1983-11-14', 19, 1),
(20424620, 'Carolina', 'Ortiz', 'carolina.ortiz20@mail.com', '3715550020', '1995-05-30', 20, 1),
(20695851, 'Matías', 'Suárez', 'matias.suarez21@mail.com', '3715550021', '1986-06-18', 21, 1),
(20967082, 'Agustina', 'Bravo', 'agustina.bravo22@mail.com', '3715550022', '1994-01-09', 22, 1),
(21238313, 'Leandro', 'Moreno', 'leandro.moreno23@mail.com', '3715550023', '1982-09-24', 23, 1),
(21509544, 'Micaela', 'Carrizo', 'micaela.carrizo24@mail.com', '3715550024', '1997-07-16', 24, 1),
(21780775, 'Rodrigo', 'Figueroa', 'rodrigo.figueroa25@mail.com', '3715550025', '1990-03-28', 25, 1),
(22052006, 'Paula', 'Cáceres', 'paula.caceres26@mail.com', '3715550026', '1992-12-11', 26, 1),
(22323237, 'Tomás', 'Nieto', 'tomas.nieto27@mail.com', '3715550027', '1989-02-05', 27, 1),
(22594468, 'Julieta', 'Giménez', 'julieta.gimenez28@mail.com', '3715550028', '1995-06-17', 28, 1),
(22865699, 'Ignacio', 'Correa', 'ignacio.correa29@mail.com', '3715550029', '1988-08-19', 29, 1),
(23136930, 'Melina', 'Rojas', 'melina.rojas30@mail.com', '3715550030', '1993-11-26', 30, 1),
(23408161, 'Bruno', 'Vargas', 'bruno.vargas31@mail.com', '3715550031', '1987-07-13', 31, 1),
(23679392, 'Carla', 'Navarro', 'carla.navarro32@mail.com', '3715550032', '1996-03-21', 32, 1),
(23950623, 'Fernando', 'Paz', 'fernando.paz33@mail.com', '3715550033', '1985-09-29', 33, 1),
(24221854, 'Lourdes', 'Serrano', 'lourdes.serrano34@mail.com', '3715550034', '1999-10-09', 34, 1),
(24493085, 'Emilio', 'Bustos', 'emilio.bustos35@mail.com', '3715550035', '1984-12-12', 35, 1),
(24764316, 'Rocío', 'Peralta', 'rocio.peralta36@mail.com', '3715550036', '1992-04-18', 36, 1),
(25035547, 'Nicolás', 'Pereyra', 'nicolas.pereyra37@mail.com', '3715550037', '1988-06-23', 37, 1),
(25306778, 'Eliana', 'Silva', 'eliana.silva38@mail.com', '3715550038', '1994-09-15', 38, 1),
(25578009, 'Esteban', 'Maidana', 'esteban.maidana39@mail.com', '3715550039', '1986-02-04', 39, 1),
(25849240, 'Milagros', 'Vera', 'milagros.vera40@mail.com', '3715550040', '1997-01-11', 40, 1),
(26120471, 'Adriana', 'Domínguez', 'adriana.dominguez41@mail.com', '3715550041', '1988-03-12', 41, 1),
(26391702, 'Ramiro', 'Campos', 'ramiro.campos42@mail.com', '3715550042', '1986-06-10', 42, 1),
(26662933, 'Noelia', 'Cruz', 'noelia.cruz43@mail.com', '3715550043', '1990-11-02', 43, 1),
(26934164, 'Hugo', 'Ponce', 'hugo.ponce44@mail.com', '3715550044', '1984-02-08', 44, 1),
(27205395, 'Claudia', 'Soto', 'claudia.soto45@mail.com', '3715550045', '1991-07-20', 45, 1),
(27476626, 'Ricardo', 'Villar', 'ricardo.villar46@mail.com', '3715550046', '1987-12-14', 46, 1),
(27747857, 'Evelyn', 'Paredes', 'evelyn.paredes47@mail.com', '3715550047', '1993-05-19', 47, 1),
(28019088, 'Patricio', 'Ibáñez', 'patricio.ibanez48@mail.com', '3715550048', '1985-10-03', 48, 1),
(28290319, 'Vanesa', 'Cáceres', 'vanesa.caceres49@mail.com', '3715550049', '1997-09-01', 49, 1),
(28561550, 'Julio', 'Roldán', 'julio.roldan50@mail.com', '3715550050', '1983-01-15', 50, 1),
(28832781, 'Diana', 'Leiva', 'diana.leiva51@mail.com', '3715550051', '1992-08-08', 51, 1),
(29104012, 'Mario', 'Méndez', 'mario.mendez52@mail.com', '3715550052', '1984-06-27', 52, 1),
(29375243, 'Lorena', 'Olivera', 'lorena.olivera53@mail.com', '3715550053', '1996-04-19', 53, 1),
(29646474, 'Eduardo', 'Barrera', 'eduardo.barrera54@mail.com', '3715550054', '1989-12-22', 54, 1),
(29917705, 'Tamara', 'Sánchez', 'tamara.sanchez55@mail.com', '3715550055', '1995-05-05', 55, 1),
(30188936, 'Fabián', 'Muñoz', 'fabian.munoz56@mail.com', '3715550056', '1982-09-18', 56, 1),
(30460167, 'Romina', 'Quiroga', 'romina.quiroga57@mail.com', '3715550057', '1993-02-14', 57, 1),
(30731398, 'Daniel', 'González', 'daniel.gonzalez58@mail.com', '3715550058', '1987-07-27', 58, 1),
(31002629, 'Marina', 'Ortiz', 'marina.ortiz59@mail.com', '3715550059', '1999-11-30', 59, 1),
(31273860, 'Cristian', 'Reyes', 'cristian.reyes60@mail.com', '3715550060', '1992-06-09', 60, 1),
(31545091, 'Ailén', 'Juárez', 'ailen.juarez61@mail.com', '3715550061', '1996-03-28', 61, 1),
(31816322, 'Oscar', 'Rivera', 'oscar.rivera62@mail.com', '3715550062', '1984-09-13', 62, 1),
(32087553, 'Victoria', 'Campos', 'victoria.campos63@mail.com', '3715550063', '1990-01-04', 63, 1),
(32358784, 'Alejandro', 'Navarro', 'alejandro.navarro64@mail.com', '3715550064', '1983-10-06', 64, 1),
(32630015, 'Cintia', 'Paz', 'cintia.paz65@mail.com', '3715550065', '1995-08-22', 65, 1),
(32901246, 'Héctor', 'Suárez', 'hector.suarez66@mail.com', '3715550066', '1988-04-11', 66, 1),
(33172477, 'Patricia', 'López', 'patricia.lopez67@mail.com', '3715550067', '1994-12-02', 67, 1),
(33443708, 'Facundo', 'Román', 'facundo.roman68@mail.com', '3715550068', '1985-06-10', 68, 1),
(33714939, 'Daniela', 'Herrera', 'daniela.herrera69@mail.com', '3715550069', '1998-10-19', 69, 1),
(33986170, 'Lucas', 'Cabrera', 'lucas.cabrera70@mail.com', '3715550070', '1983-03-27', 70, 1),
(34257401, 'Milena', 'Guzmán', 'milena.guzman71@mail.com', '3715550071', '1996-07-05', 71, 1),
(34528632, 'Brian', 'Escobar', 'brian.escobar72@mail.com', '3715550072', '1987-12-12', 72, 1),
(34799863, 'Yamila', 'Delgado', 'yamila.delgado73@mail.com', '3715550073', '1993-01-08', 73, 1),
(35071094, 'Rodrigo', 'Bustos', 'rodrigo.bustos74@mail.com', '3715550074', '1984-09-15', 74, 1),
(35342325, 'Juliana', 'Benítez', 'juliana.benitez75@mail.com', '3715550075', '1992-02-22', 75, 1),
(35613556, 'Gonzalo', 'Rivero', 'gonzalo.rivero76@mail.com', '3715550076', '1989-05-05', 76, 1),
(35884787, 'Magalí', 'Coronel', 'magali.coronel77@mail.com', '3715550077', '1997-11-25', 77, 1),
(36156018, 'Federico', 'Ramos', 'federico.ramos78@mail.com', '3715550078', '1985-06-01', 78, 1),
(36427249, 'Brenda', 'Arce', 'brenda.arce79@mail.com', '3715550079', '1994-09-14', 79, 1),
(36698480, 'Sergio', 'Lozano', 'sergio.lozano80@mail.com', '3715550080', '1982-07-21', 80, 1),
(36969711, 'Celeste', 'Maldonado', 'celeste.maldonado81@mail.com', '3715550081', '1991-05-03', 81, 1),
(37240942, 'Cristian', 'León', 'cristian.leon82@mail.com', '3715550082', '1984-08-08', 82, 1),
(37512173, 'Pilar', 'Chávez', 'pilar.chavez83@mail.com', '3715550083', '1995-12-18', 83, 1),
(37783404, 'Matías', 'Ortega', 'matias.ortega84@mail.com', '3715550084', '1987-01-26', 84, 1),
(38054635, 'Carina', 'Ojeda', 'carina.ojeda85@mail.com', '3715550085', '1993-03-15', 85, 1),
(38325866, 'Emanuel', 'Ponce', 'emanuel.ponce86@mail.com', '3715550086', '1988-05-23', 86, 1),
(38597097, 'Nadia', 'Silveyra', 'nadia.silveyra87@mail.com', '3715550087', '1996-09-02', 87, 1),
(38868328, 'Tomás', 'Villalba', 'tomas.villalba88@mail.com', '3715550088', '1989-04-10', 88, 1),
(39139559, 'Malena', 'Pereira', 'malena.pereira89@mail.com', '3715550089', '1995-02-05', 89, 1),
(39410790, 'Ezequiel', 'Bustos', 'ezequiel.bustos90@mail.com', '3715550090', '1986-11-11', 90, 1),
(39682021, 'Nahir', 'Espinoza', 'nahir.espinoza91@mail.com', '3715550091', '1998-04-09', 91, 1),
(39953252, 'Ramón', 'Soria', 'ramon.soria92@mail.com', '3715550092', '1983-08-13', 92, 1),
(40224483, 'Ariadna', 'Pérez', 'ariadna.perez93@mail.com', '3715550093', '1999-12-30', 93, 1),
(40495714, 'Lucas', 'Toloza', 'lucas.toloza94@mail.com', '3715550094', '1985-05-14', 94, 1),
(40766945, 'Martina', 'Aguirre', 'martina.aguirre95@mail.com', '3715550095', '1991-06-27', 95, 1),
(41038176, 'Franco', 'Domínguez', 'franco.dominguez96@mail.com', '3715550096', '1989-03-16', 96, 1),
(41309407, 'Rocío', 'Ocampo', 'rocio.ocampo97@mail.com', '3715550097', '1993-11-08', 97, 1),
(41580638, 'Leonardo', 'Carrizo', 'leonardo.carrizo98@mail.com', '3715550098', '1987-09-21', 98, 1),
(41851869, 'Sabrina', 'Quiroga', 'sabrina.quiroga99@mail.com', '3715550099', '1996-01-19', 99, 1),
(42123100, 'Federica', 'Salinas', 'federica.salinas100@mail.com', '3715550100', '1994-07-12', 100, 1);

PRINT 'Lote 1 completado: 100 registros insertados en persona.';
GO

-- =====================================================
-- LOTE 2: Inserciones usando sp_insertar_persona (100 registros)
-- DNIs entre 15M y 45M, únicos en este bloque
-- =====================================================
EXEC sp_insertar_persona 20541231, 'Agustín', 'Correa', 'agustin.correa101@mail.com', '3715551101', '1992-07-03', 1, 1;
EXEC sp_insertar_persona 20782462, 'Cecilia', 'Arias', 'cecilia.arias102@mail.com', '3715551102', '1988-12-28', 2, 1;
EXEC sp_insertar_persona 21023693, 'Enzo', 'Ramírez', 'enzo.ramirez103@mail.com', '3715551103', '1995-09-11', 3, 1;
EXEC sp_insertar_persona 21264924, 'Sabrina', 'Álvarez', 'sabrina.alvarez104@mail.com', '3715551104', '1989-11-15', 4, 1;
EXEC sp_insertar_persona 21506155, 'Nicolás', 'Maidana', 'nicolas.maidana105@mail.com', '3715551105', '1994-03-10', 5, 1;
EXEC sp_insertar_persona 21747386, 'Carla', 'Navarro', 'carla.navarro106@mail.com', '3715551106', '1987-06-20', 6, 1;
EXEC sp_insertar_persona 21988617, 'Marcos', 'Herrera', 'marcos.herrera107@mail.com', '3715551107', '1993-02-09', 7, 1;
EXEC sp_insertar_persona 22229848, 'Daniela', 'Córdoba', 'daniela.cordoba108@mail.com', '3715551108', '1998-09-27', 8, 1;
EXEC sp_insertar_persona 22471079, 'Ezequiel', 'Ramos', 'ezequiel.ramos109@mail.com', '3715551109', '1991-10-04', 9, 1;
EXEC sp_insertar_persona 22712310, 'Luis', 'Serrano', 'luis.serrano110@mail.com', '3715551110', '1986-01-21', 10, 1;
EXEC sp_insertar_persona 22953541, 'Bárbara', 'Luna', 'barbara.luna111@mail.com', '3715551111', '1997-04-18', 11, 1;
EXEC sp_insertar_persona 23194772, 'Julián', 'Medina', 'julian.medina112@mail.com', '3715551112', '1985-08-03', 12, 1;
EXEC sp_insertar_persona 23436003, 'Cecilia', 'Rossi', 'cecilia.rossi113@mail.com', '3715551113', '1993-03-22', 13, 1;
EXEC sp_insertar_persona 23677234, 'Gustavo', 'Ibarra', 'gustavo.ibarra114@mail.com', '3715551114', '1988-12-01', 14, 1;
EXEC sp_insertar_persona 23918465, 'Iara', 'Sánchez', 'iara.sanchez115@mail.com', '3715551115', '1996-06-07', 15, 1;
EXEC sp_insertar_persona 24159696, 'Santino', 'Quiroga', 'santino.quiroga116@mail.com', '3715551116', '1999-10-30', 16, 1;
EXEC sp_insertar_persona 24400927, 'Priscila', 'Mansilla', 'priscila.mansilla117@mail.com', '3715551117', '1992-01-05', 17, 1;
EXEC sp_insertar_persona 24642158, 'Ulises', 'Godoy', 'ulises.godoy118@mail.com', '3715551118', '1987-05-12', 18, 1;
EXEC sp_insertar_persona 24883389, 'Tamara', 'Vega', 'tamara.vega119@mail.com', '3715551119', '1994-09-25', 19, 1;
EXEC sp_insertar_persona 25124620, 'Sebastián', 'Gallo', 'sebastian.gallo120@mail.com', '3715551120', '1983-02-18', 20, 1;
EXEC sp_insertar_persona 25365851, 'Candela', 'Moyano', 'candela.moyano121@mail.com', '3715551121', '1995-07-14', 21, 1;
EXEC sp_insertar_persona 25607082, 'Tomás', 'Luna', 'tomas.luna122@mail.com', '3715551122', '1991-05-23', 22, 1;
EXEC sp_insertar_persona 25848313, 'Mauro', 'Paredes', 'mauro.paredes123@mail.com', '3715551123', '1986-11-11', 23, 1;
EXEC sp_insertar_persona 26089544, 'Ayelén', 'Cardozo', 'ayelen.cardozo124@mail.com', '3715551124', '1993-01-27', 24, 1;
EXEC sp_insertar_persona 26330775, 'Jazmín', 'Soria', 'jazmin.soria125@mail.com', '3715551125', '1998-03-19', 25, 1;
EXEC sp_insertar_persona 26572006, 'Nahir', 'Aguirre', 'nahir.aguirre126@mail.com', '3715551126', '1996-12-09', 26, 1;
EXEC sp_insertar_persona 26813237, 'Emanuel', 'Vera', 'emanuel.vera127@mail.com', '3715551127', '1984-06-04', 27, 1;
EXEC sp_insertar_persona 27054468, 'Sabrina', 'Maidana', 'sabrina.maidana128@mail.com', '3715551128', '1997-08-08', 28, 1;
EXEC sp_insertar_persona 27295699, 'Gisela', 'Leiva', 'gisela.leiva129@mail.com', '3715551129', '1989-09-01', 29, 1;
EXEC sp_insertar_persona 27536930, 'Damián', 'Navarro', 'damian.navarro130@mail.com', '3715551130', '1992-12-30', 30, 1;
EXEC sp_insertar_persona 27778161, 'Rocío', 'Báez', 'rocio.baez131@mail.com', '3715551131', '1995-02-12', 31, 1;
EXEC sp_insertar_persona 28019392, 'Nahuel', 'Arce', 'nahuel.arce132@mail.com', '3715551132', '1991-09-09', 32, 1;
EXEC sp_insertar_persona 28260623, 'Julieta', 'Coronel', 'julieta.coronel133@mail.com', '3715551133', '1994-04-28', 33, 1;
EXEC sp_insertar_persona 28501854, 'Iván', 'Peralta', 'ivan.peralta134@mail.com', '3715551134', '1987-01-19', 34, 1;
EXEC sp_insertar_persona 28743085, 'Milena', 'Guzmán', 'milena.guzman135@mail.com', '3715551135', '1996-11-30', 35, 1;
EXEC sp_insertar_persona 28984316, 'Thiago', 'Juárez', 'thiago.juarez136@mail.com', '3715551136', '1999-05-17', 36, 1;
EXEC sp_insertar_persona 29225547, 'Santiago', 'Bustos', 'santiago.bustos137@mail.com', '3715551137', '1988-07-06', 37, 1;
EXEC sp_insertar_persona 29466778, 'Ariana', 'Paz', 'ariana.paz138@mail.com', '3715551138', '1993-10-22', 38, 1;
EXEC sp_insertar_persona 29708009, 'Lucas', 'Ortiz', 'lucas.ortiz139@mail.com', '3715551139', '1985-03-03', 39, 1;
EXEC sp_insertar_persona 29949240, 'Valeria', 'Núñez', 'valeria.nunez140@mail.com', '3715551140', '1992-06-26', 40, 1;
EXEC sp_insertar_persona 30190471, 'Agustina', 'Silveyra', 'agustina.silveyra141@mail.com', '3715551141', '1997-12-05', 41, 1;
EXEC sp_insertar_persona 30431702, 'Jonás', 'Villar', 'jonas.villar142@mail.com', '3715551142', '1994-02-27', 42, 1;
EXEC sp_insertar_persona 30672933, 'Micaela', 'Domínguez', 'micaela.dominguez143@mail.com', '3715551143', '1991-11-14', 43, 1;
EXEC sp_insertar_persona 30914164, 'Leandro', 'Salinas', 'leandro.salinas144@mail.com', '3715551144', '1986-05-01', 44, 1;
EXEC sp_insertar_persona 31155395, 'Martina', 'García', 'martina.garcia145@mail.com', '3715551145', '1995-09-28', 45, 1;
EXEC sp_insertar_persona 31396626, 'Camilo', 'Vega', 'camilo.vega146@mail.com', '3715551146', '1983-01-23', 46, 1;
EXEC sp_insertar_persona 31637857, 'Paula', 'Barrera', 'paula.barrera147@mail.com', '3715551147', '1996-10-09', 47, 1;
EXEC sp_insertar_persona 31879088, 'Hernán', 'Paz', 'hernan.paz148@mail.com', '3715551148', '1984-04-04', 48, 1;
EXEC sp_insertar_persona 32120319, 'Carolina', 'Roldán', 'carolina.roldan149@mail.com', '3715551149', '1993-07-19', 49, 1;
EXEC sp_insertar_persona 32361550, 'Sofía', 'Toloza', 'sofia.toloza150@mail.com', '3715551150', '1998-01-07', 50, 1;
EXEC sp_insertar_persona 32602781, 'Bruno', 'León', 'bruno.leon151@mail.com', '3715551151', '1992-03-29', 51, 1;
EXEC sp_insertar_persona 32844012, 'Rocío', 'Arias', 'rocio.arias152@mail.com', '3715551152', '1991-12-18', 52, 1;
EXEC sp_insertar_persona 33085243, 'Pilar', 'Ortiz', 'pilar.ortiz153@mail.com', '3715551153', '1988-02-02', 53, 1;
EXEC sp_insertar_persona 33326474, 'Bautista', 'Maldonado', 'bautista.maldonado154@mail.com', '3715551154', '1997-06-21', 54, 1;
EXEC sp_insertar_persona 33567705, 'Gabriela', 'Ramos', 'gabriela.ramos155@mail.com', '3715551155', '1985-10-31', 55, 1;
EXEC sp_insertar_persona 33808936, 'Jazmín', 'Escobar', 'jazmin.escobar156@mail.com', '3715551156', '1993-05-06', 56, 1;
EXEC sp_insertar_persona 34050167, 'Ramiro', 'Guzmán', 'ramiro.guzman157@mail.com', '3715551157', '1990-09-13', 57, 1;
EXEC sp_insertar_persona 34291398, 'Elena', 'Soria', 'elena.soria158@mail.com', '3715551158', '1996-11-02', 58, 1;
EXEC sp_insertar_persona 34532629, 'Ezequiel', 'Pereyra', 'ezequiel.pereyra159@mail.com', '3715551159', '1984-03-08', 59, 1;
EXEC sp_insertar_persona 34773860, 'Nadia', 'Ibáñez', 'nadia.ibanez160@mail.com', '3715551160', '1995-01-25', 60, 1;
EXEC sp_insertar_persona 35015091, 'Sergio', 'Correa', 'sergio.correa161@mail.com', '3715551161', '1987-12-30', 61, 1;
EXEC sp_insertar_persona 35256322, 'Luciana', 'Juárez', 'luciana.juarez162@mail.com', '3715551162', '1999-08-08', 62, 1;
EXEC sp_insertar_persona 35497553, 'Julián', 'Paz', 'julian.paz163@mail.com', '3715551163', '1992-10-05', 63, 1;
EXEC sp_insertar_persona 35738784, 'Nicolás', 'Campos', 'nicolas.campos164@mail.com', '3715551164', '1986-06-01', 64, 1;
EXEC sp_insertar_persona 35980015, 'Valentina', 'Delgado', 'valentina.delgado165@mail.com', '3715551165', '1994-12-19', 65, 1;
EXEC sp_insertar_persona 36221246, 'Axel', 'Suárez', 'axel.suarez166@mail.com', '3715551166', '1991-07-07', 66, 1;
EXEC sp_insertar_persona 36462477, 'Brenda', 'Lozano', 'brenda.lozano167@mail.com', '3715551167', '1993-09-29', 67, 1;
EXEC sp_insertar_persona 36703708, 'Santino', 'Vargas', 'santino.vargas168@mail.com', '3715551168', '1998-02-24', 68, 1;
EXEC sp_insertar_persona 36944939, 'Antonella', 'Carrizo', 'antonella.carrizo169@mail.com', '3715551169', '1996-05-15', 69, 1;
EXEC sp_insertar_persona 37186170, 'Matías', 'Benítez', 'matias.benitez170@mail.com', '3715551170', '1987-04-04', 70, 1;
EXEC sp_insertar_persona 37427401, 'Mora', 'Cáceres', 'mora.caceres171@mail.com', '3715551171', '1995-03-03', 71, 1;
EXEC sp_insertar_persona 37668632, 'Emilia', 'Domínguez', 'emilia.dominguez172@mail.com', '3715551172', '1999-01-10', 72, 1;
EXEC sp_insertar_persona 37909863, 'Lautaro', 'Sánchez', 'lautaro.sanchez173@mail.com', '3715551173', '1992-05-18', 73, 1;
EXEC sp_insertar_persona 38151094, 'Abril', 'Maidana', 'abril.maidana174@mail.com', '3715551174', '1990-12-12', 74, 1;
EXEC sp_insertar_persona 38392325, 'Gonzalo', 'Ibarra', 'gonzalo.ibarra175@mail.com', '3715551175', '1986-08-20', 75, 1;
EXEC sp_insertar_persona 38633556, 'Catalina', 'Paredes', 'catalina.paredes176@mail.com', '3715551176', '1997-03-09', 76, 1;
EXEC sp_insertar_persona 38874787, 'Ariel', 'Ortiz', 'ariel.ortiz177@mail.com', '3715551177', '1985-10-16', 77, 1;
EXEC sp_insertar_persona 39116018, 'Tiziano', 'Gómez', 'tiziano.gomez178@mail.com', '3715551178', '1994-07-29', 78, 1;
EXEC sp_insertar_persona 39357249, 'Ciro', 'Rojas', 'ciro.rojas179@mail.com', '3715551179', '1993-06-06', 79, 1;
EXEC sp_insertar_persona 39598480, 'Zoe', 'Leiva', 'zoe.leiva180@mail.com', '3715551180', '1998-11-22', 80, 1;
EXEC sp_insertar_persona 39839711, 'Elías', 'Ponce', 'elias.ponce181@mail.com', '3715551181', '1984-02-02', 81, 1;
EXEC sp_insertar_persona 40080942, 'Uma', 'Olivera', 'uma.olivera182@mail.com', '3715551182', '1996-04-14', 82, 1;
EXEC sp_insertar_persona 40322173, 'Francesca', 'Ramos', 'francesca.ramos183@mail.com', '3715551183', '1999-08-01', 83, 1;
EXEC sp_insertar_persona 40563404, 'Benjamín', 'Soto', 'benjamin.soto184@mail.com', '3715551184', '1992-01-20', 84, 1;
EXEC sp_insertar_persona 40804635, 'Aitana', 'Peralta', 'aitana.peralta185@mail.com', '3715551185', '1995-05-29', 85, 1;
EXEC sp_insertar_persona 41045866, 'Amanda', 'Villar', 'amanda.villar186@mail.com', '3715551186', '1997-09-04', 86, 1;
EXEC sp_insertar_persona 41287097, 'Jaziel', 'Campos', 'jaziel.campos187@mail.com', '3715551187', '1990-03-17', 87, 1;
EXEC sp_insertar_persona 41528328, 'Franco', 'Salinas', 'franco.salinas188@mail.com', '3715551188', '1988-12-29', 88, 1;
EXEC sp_insertar_persona 41769559, 'Micaela', 'Roldán', 'micaela.roldan189@mail.com', '3715551189', '1996-06-25', 89, 1;
EXEC sp_insertar_persona 42010790, 'Brisa', 'Cruz', 'brisa.cruz190@mail.com', '3715551190', '1998-10-18', 90, 1;
EXEC sp_insertar_persona 42252021, 'Tomás', 'Silva', 'tomas.silva191@mail.com', '3715551191', '1994-01-08', 91, 1;
EXEC sp_insertar_persona 42493252, 'Luna', 'Vega', 'luna.vega192@mail.com', '3715551192', '1995-02-26', 92, 1;
EXEC sp_insertar_persona 42734483, 'Ignacio', 'Gallo', 'ignacio.gallo193@mail.com', '3715551193', '1987-07-30', 93, 1;
EXEC sp_insertar_persona 42975714, 'Mora', 'Juárez', 'mora.juarez194@mail.com', '3715551194', '1991-11-09', 94, 1;
EXEC sp_insertar_persona 43216945, 'Lola', 'Cáceres', 'lola.caceres195@mail.com', '3715551195', '1993-09-03', 95, 1;
EXEC sp_insertar_persona 43458176, 'Guido', 'Figueroa', 'guido.figueroa196@mail.com', '3715551196', '1990-06-12', 96, 1;
EXEC sp_insertar_persona 43699407, 'Paz', 'Moreno', 'paz.moreno197@mail.com', '3715551197', '1996-08-28', 97, 1;
EXEC sp_insertar_persona 43940638, 'Felipe', 'Rossi', 'felipe.rossi198@mail.com', '3715551198', '1985-10-07', 98, 1;
EXEC sp_insertar_persona 44181869, 'Juana', 'Giménez', 'juana.gimenez199@mail.com', '3715551199', '1997-12-31', 99, 1;
EXEC sp_insertar_persona 44423100, 'Ludmila', 'Vera', 'ludmila.vera200@mail.com', '3715551200', '1993-04-11', 100, 1;

PRINT 'Lote 2 completado: 100 registros insertados con sp_insertar_persona.';
GO

