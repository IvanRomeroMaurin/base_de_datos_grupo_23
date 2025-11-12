USE alquiler_pro;
GO

-- Datos de provincia
INSERT INTO provincia (id_provincia, nombre) VALUES (1, 'Corrientes');
INSERT INTO ciudad (id_ciudad, nombre, id_provincia) VALUES (1, 'Corrientes Capital', 1);

-- Direcciones
INSERT INTO direccion (id_direccion, calle, numero, barrio, id_ciudad) 
VALUES (1, 'Av. Costanera', 100, 'Centro', 1);
INSERT INTO direccion (id_direccion, calle, numero, barrio, id_ciudad) 
VALUES (2, 'Calle Falsa', 123, 'San Martín', 1);

-- Propietario del inmueble
INSERT INTO persona (dni, nombre, apellido, correo_electronico, telefono, fecha_nacimiento, id_direccion, estado)
VALUES (11111111, 'Ana', 'Gomez', 'ana@email.com', '3794111111', '1980-05-10', 1, 1);

-- Usuario (empleado que registra el contrato)
INSERT INTO rol_usuario (id_rol_usuario, nombre) VALUES (1, 'Administrador');
INSERT INTO usuario (id_usuario, contrasena, estado, dni, id_rol_usuario)
VALUES (1, 'pass123', 1, 11111111, 1);

-- Tipos de inmueble y disponibilidad
INSERT INTO tipo_inmueble (id_tipo_inmueble, nombre) VALUES (1, 'Departamento');
INSERT INTO disponibilidad (id_disponibilidad, nombre) 
VALUES (1, 'Disponible'), (2, 'Alquilado');

-- Inmueble a alquilar
INSERT INTO inmueble (id_inmueble, descripcion, id_tipo_inmueble, dni, id_direccion, id_disponibilidad, estado)
VALUES (101, 'Depto 2 amb c/balcon', 1, 11111111, 1, 1, 1); -- ID Disponibilidad = 1 (Disponible)
GO