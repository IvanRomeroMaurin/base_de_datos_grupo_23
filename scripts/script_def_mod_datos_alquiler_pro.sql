-- SCRIPT TEMA "Sistema de gestio de Alquileres "
-- DEFINNICIÓN DEL MODELO DE DATOS

CREATE DATABASE alquiler_pro

USE alquiler_pro

CREATE TABLE provincia
(
  id_provincia INT NOT NULL,
  nombre VARCHAR(200) NOT NULL,
  CONSTRAINT PK_provincia PRIMARY KEY (id_provincia)
);

CREATE TABLE ciudad
(
  id_ciudad INT NOT NULL,
  nombre VARCHAR(200) NOT NULL,
  id_provincia INT NOT NULL,
  CONSTRAINT PK_ciudad PRIMARY KEY (id_ciudad),
  CONSTRAINT FK_ciudad_provincia FOREIGN KEY (id_provincia) REFERENCES provincia(id_provincia)
);

CREATE TABLE direccion
(
  calle VARCHAR(200) NOT NULL,
  id_direccion INT NOT NULL,
  numero INT NULL,
  manzana VARCHAR(10) NULL,
  barrio VARCHAR(200) NULL,
  id_ciudad INT NOT NULL,
  CONSTRAINT PK_direccion PRIMARY KEY (id_direccion),
  CONSTRAINT FK_direccion_direccion FOREIGN KEY (id_ciudad) REFERENCES ciudad(id_ciudad),
  CONSTRAINT CK_direccion_numero CHECK(numero > 0)
);

CREATE TABLE estado
(
  id_estado INT NOT NULL,
  nombre VARCHAR(200) NOT NULL,
  CONSTRAINT PK_estado PRIMARY KEY (id_estado)
);

CREATE TABLE persona
(
  dni NUMERIC(8) NOT NULL,
  nombre VARCHAR(200) NOT NULL,
  apellido VARCHAR(200) NOT NULL,
  correo_electronico VARCHAR(200) NOT NULL,
  telefono VARCHAR(50) NOT NULL,
  fecha_nacimiento DATE NOT NULL,
  fecha_creacion DATE NOT NULL CONSTRAINT DF_persona_fecha_creacion DEFAULT (GETDATE()),
  id_direccion INT NOT NULL,
  id_estado INT NOT NULL,
  CONSTRAINT PK_persona PRIMARY KEY (dni),
  CONSTRAINT FK_persona_direccion FOREIGN KEY (id_direccion) REFERENCES direccion(id_direccion),
  CONSTRAINT FK_persona_estado FOREIGN KEY (id_estado) REFERENCES estado(id_estado),
  CONSTRAINT UQ_persona_correo UNIQUE (correo_electronico),
  CONSTRAINT UQ_persona_telefono UNIQUE (telefono),
  CONSTRAINT CK_persona_fecha_nacimiento CHECK(fecha_nacimiento <= (GETDATE()))
);

CREATE TABLE rol_cliente
(
  id_rol_cliente INT NOT NULL,
  descripcion_ VARCHAR(200) NOT NULL,
  CONSTRAINT PK_cliente PRIMARY KEY (id_rol_cliente)
);

CREATE TABLE tipo_inmueble
(
  id_tipo_inmueble INT NOT NULL,
  nombre INT NOT NULL,
  CONSTRAINT PK_tipo_inmueble PRIMARY KEY (id_tipo_inmueble)
);

CREATE TABLE persona_rol_cliente
(
  fecha_creacion DATE NOT NULL CONSTRAINT DF_prc_fecha_creacion DEFAULT(GETDATE()),
  id_rol_cliente INT NOT NULL,
  dni NUMERIC(8) NOT NULL,
  CONSTRAINT PK_persona_rol_cliente PRIMARY KEY (id_rol_cliente, dni ),
  CONSTRAINT FK_prc_rol_cliente FOREIGN KEY (id_rol_cliente) REFERENCES rol_cliente(id_rol_cliente),
  CONSTRAINT FK_prc_persona FOREIGN KEY (dni ) REFERENCES persona(dni )
);

CREATE TABLE disponibilidad
(
  id_disponibilidad INT NOT NULL,
  nombre VARCHAR(200) NOT NULL,
  CONSTRAINT PK_disponiblidad PRIMARY KEY (id_disponibilidad)
);

CREATE TABLE inmueble
(
  id_inmueble INT NOT NULL,
  descipcion VARCHAR(200) NOT NULL,
  fecha_creacion DATE NOT NULL CONSTRAINT DF_inmueble_fecha_creacion DEFAULT(GETDATE()),
  id_tipo_inmueble INT NOT NULL,
  id_rol_cliente INT NOT NULL,
  dni NUMERIC(8) NOT NULL,
  id_direccion INT NOT NULL,
  id_disponibilidad INT NOT NULL,
  id_estado INT NOT NULL,
  CONSTRAINT PK_inmueble PRIMARY KEY (id_inmueble),
  CONSTRAINT FK_inmueble_tipo FOREIGN KEY (id_tipo_inmueble) REFERENCES tipo_inmueble(id_tipo_inmueble),
  CONSTRAINT FK_inmueble_rol_cliente FOREIGN KEY (id_rol_cliente, dni ) REFERENCES persona_rol_cliente(id_rol_cliente, dni ),
  CONSTRAINT FK_inmueble_direccion FOREIGN KEY (id_direccion) REFERENCES direccion(id_direccion),
  CONSTRAINT FK_inmueble_disponibilidad FOREIGN KEY (id_disponibilidad) REFERENCES disponibilidad(id_disponibilidad),
  CONSTRAINT FK_inmueble_estado FOREIGN KEY (id_estado) REFERENCES estado(id_estado),
  CONSTRAINT CK_inmueble_fecha_creacion CHECK(fecha_creacion < (GETDATE()))
);

CREATE TABLE contrato_alquiler
(
  id_contrato INT NOT NULL,
  fecha_inicio DATE NOT NULL CONSTRAINT DF_contrato_fecha_inicio DEFAULT(GETDATE()),
  fecha_fin DATE NOT NULL,
  monto DECIMAL NOT NULL,
  condiciones VARCHAR(200) NOT NULL,
  cant_cuotas INT NOT NULL,
  fecha_creacion DATE NOT NULL CONSTRAINT DF_contrato_fecha_creacion DEFAULT(GETDATE()),
  id_inmueble INT NOT NULL,
  id_rol_cliente INT NOT NULL,
  dni NUMERIC(8) NOT NULL,
  CONSTRAINT PK_contrato_alquiler PRIMARY KEY (id_contrato),
  CONSTRAINT FK_contrato_inmueble FOREIGN KEY (id_inmueble) REFERENCES inmueble(id_inmueble),
  CONSTRAINT FK_contrato_cliente FOREIGN KEY (id_rol_cliente, dni ) REFERENCES persona_rol_cliente(id_rol_cliente, dni ),
  CONSTRAINT CK_contrato_fecha_fin CHECK(fecha_fin > fecha_inicio),
  CONSTRAINT CK_contrato_monto CHECK(monto > 0),
  CONSTRAINT CK_contrato_cuotas CHECK(cant_cuotas > 0)
);

CREATE TABLE rol_usuario
(
  id_rol_usuario INT NOT NULL,
  nombre VARCHAR(100) NOT NULL,
  PRIMARY KEY (id_rol_usuario)
);

CREATE TABLE usuario
(
  id_usuario INT NOT NULL,
  contraseña VARCHAR(500) NOT NULL,
  fecha_creacion DATE NOT NULL CONSTRAINT DF_usuario_fecha_creacion DEFAULT(GETDATE()),
  dni NUMERIC(8) NOT NULL,
  id_rol_usuario INT NOT NULL,
  id_estado INT NOT NULL,
  CONSTRAINT PK_usuario PRIMARY KEY (id_usuario),
  CONSTRAINT FK_usuario_persona  FOREIGN KEY (dni) REFERENCES persona(dni),
  CONSTRAINT FK_usuario_rol FOREIGN KEY (id_rol_usuario) REFERENCES rol_usuario(id_rol_usuario),
  CONSTRAINT FK_usuario_estado FOREIGN KEY (id_estado) REFERENCES estado(id_estado)
);

CREATE TABLE metodo_pago
(
  id_metodo_pago INT NOT NULL,
  tipo_pago VARCHAR(100) NOT NULL,
  descripcion_ VARCHAR(200) NOT NULL,
  CONSTRAINT PK_metodo_pago PRIMARY KEY (id_metodo_pago)
);

CREATE TABLE recibo
(
  id_recibo INT NOT NULL,
  fecha_emision DATE NOT NULL CONSTRAINT DF_recibo_fecha_emision DEFAULT(GETDATE()),
  nro_comprobante INT NOT NULL,
  CONSTRAINT PK_recibo PRIMARY KEY (id_recibo)
);

CREATE TABLE pago
(
  id_pago INT NOT NULL,
  fecha_pago DATE NOT NULL CONSTRAINT DF_pago_fecha_pago DEFAULT(GETDATE()),
  monto DECIMAL NOT NULL,
  periodo VARCHAR(50) NOT NULL,
  fecha_creacion DATE NOT NULL CONSTRAINT DF_pago_fecha_creacion DEFAULT(GETDATE()),
  id_metodo_pago INT NOT NULL,
  id_recibo INT NOT NULL,
  CONSTRAINT PK_pago PRIMARY KEY (id_pago),
  CONSTRAINT FK_pago_metodo FOREIGN KEY (id_metodo_pago) REFERENCES metodo_pago(id_metodo_pago),
  CONSTRAINT FK_pago_recibo FOREIGN KEY (id_recibo) REFERENCES recibo(id_recibo),
  CONSTRAINT CK_pago_monto CHECK(monto > 0)
);

CREATE TABLE cuota
(
  nro_cuota INT NOT NULL,
  periodo VARCHAR(20) NOT NULL,
  fecha_vencimiento DATE NOT NULL,
  importe DECIMAL NOT NULL,
  estado VARCHAR(100) NOT NULL,
  fecha_creacion DATE NOT NULL,
  id_contrato INT NOT NULL,
  id_pago INT NOT NULL,
  CONSTRAINT PK_cuota PRIMARY KEY (nro_cuota, id_contrato),
  CONSTRAINT FK_cuota_contrato FOREIGN KEY (id_contrato) REFERENCES contrato_alquiler(id_contrato),
  CONSTRAINT FK_cuota_pago FOREIGN KEY (id_pago) REFERENCES pago(id_pago),
  CONSTRAINT CK_cuota_fecha_vencimiento CHECK(fecha_vencimiento >  fecha_creacion),
  CONSTRAINT CK_cuota_importe CHECK(importe > 0),
  CONSTRAINT CK_cuota_nro_cuota CHECK(nro_cuota > 0)
);