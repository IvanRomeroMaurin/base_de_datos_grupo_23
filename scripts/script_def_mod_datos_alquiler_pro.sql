-- SCRIPT TEMA "Sistema de gestión de Alquileres"
-- DEFINICIÓN DEL MODELO DE DATOS

CREATE DATABASE alquiler_pro;
GO
USE alquiler_pro;
GO

-- ============================
-- 1. PROVINCIA
-- ============================
CREATE TABLE provincia (
  id_provincia INT NOT NULL,
  nombre VARCHAR(200) NOT NULL,
  CONSTRAINT PK_provincia PRIMARY KEY (id_provincia)
);

-- ============================
-- 2. CIUDAD
-- ============================
CREATE TABLE ciudad (
  id_ciudad INT NOT NULL,
  nombre VARCHAR(200) NOT NULL,
  id_provincia INT NOT NULL,
  CONSTRAINT PK_ciudad PRIMARY KEY (id_ciudad),
  CONSTRAINT FK_ciudad_provincia FOREIGN KEY (id_provincia)
      REFERENCES provincia(id_provincia)
);

-- ============================
-- 3. DIRECCIÓN
-- ============================
CREATE TABLE direccion (
  id_direccion INT NOT NULL,
  calle VARCHAR(200) NOT NULL,
  numero INT NULL,
  manzana VARCHAR(10) NULL,
  barrio VARCHAR(200) NULL,
  id_ciudad INT NOT NULL,
  CONSTRAINT PK_direccion PRIMARY KEY (id_direccion),
  CONSTRAINT FK_direccion_ciudad FOREIGN KEY (id_ciudad)
      REFERENCES ciudad(id_ciudad),
  CONSTRAINT CK_direccion_numero CHECK (numero > 0)
);

-- ============================
-- 4. PERSONA
-- ============================
CREATE TABLE persona (
  dni NUMERIC(8) NOT NULL,
  nombre VARCHAR(200) NOT NULL,
  apellido VARCHAR(200) NOT NULL,
  correo_electronico VARCHAR(200) NOT NULL,
  telefono VARCHAR(50) NOT NULL,
  fecha_nacimiento DATE NOT NULL,
  fecha_creacion DATETIME NOT NULL
      CONSTRAINT DF_persona_fecha_creacion DEFAULT (GETDATE()),
  id_direccion INT NOT NULL,
  estado BIT NOT NULL,
  CONSTRAINT PK_persona PRIMARY KEY (dni),
  CONSTRAINT FK_persona_direccion FOREIGN KEY (id_direccion)
      REFERENCES direccion(id_direccion),
  CONSTRAINT UQ_persona_correo UNIQUE (correo_electronico),
  CONSTRAINT UQ_persona_telefono UNIQUE (telefono),
  CONSTRAINT CK_persona_fecha_nacimiento CHECK (fecha_nacimiento <= GETDATE())
);

-- ============================
-- 5. TIPO INMUEBLE
-- ============================
CREATE TABLE tipo_inmueble (
  id_tipo_inmueble INT NOT NULL,
  nombre VARCHAR(100) NOT NULL,
  CONSTRAINT PK_tipo_inmueble PRIMARY KEY (id_tipo_inmueble)
);

-- ============================
-- 6. DISPONIBILIDAD
-- ============================
CREATE TABLE disponibilidad (
  id_disponibilidad INT NOT NULL,
  nombre VARCHAR(200) NOT NULL,
  CONSTRAINT PK_disponibilidad PRIMARY KEY (id_disponibilidad)
);

-- ============================
-- 7. INMUEBLE
-- ============================
CREATE TABLE inmueble (
  id_inmueble INT NOT NULL,
  descripcion VARCHAR(200) NOT NULL,
  fecha_creacion DATETIME NOT NULL
      CONSTRAINT DF_inmueble_fecha_creacion DEFAULT (GETDATE()),
  id_tipo_inmueble INT NOT NULL,
  dni NUMERIC(8) NOT NULL,
  id_direccion INT NOT NULL,
  id_disponibilidad INT NOT NULL,
  estado BIT NOT NULL,
  CONSTRAINT PK_inmueble PRIMARY KEY (id_inmueble),
  CONSTRAINT FK_inmueble_tipo FOREIGN KEY (id_tipo_inmueble)
      REFERENCES tipo_inmueble(id_tipo_inmueble),
  CONSTRAINT FK_inmueble_direccion FOREIGN KEY (id_direccion)
      REFERENCES direccion(id_direccion),
  CONSTRAINT FK_inmueble_disponibilidad FOREIGN KEY (id_disponibilidad)
      REFERENCES disponibilidad(id_disponibilidad),
  CONSTRAINT FK_inmueble_propietario FOREIGN KEY (dni)
      REFERENCES persona(dni),
  CONSTRAINT CK_inmueble_fecha_creacion CHECK (fecha_creacion <= GETDATE())
);

-- ============================
-- 8. ROL USUARIO
-- ============================
CREATE TABLE rol_usuario (
  id_rol_usuario INT NOT NULL,
  nombre VARCHAR(100) NOT NULL,
  CONSTRAINT PK_rol_usuario PRIMARY KEY (id_rol_usuario)
);

-- ============================
-- 9. USUARIO
-- ============================
CREATE TABLE usuario (
  id_usuario INT NOT NULL,
  contrasena VARCHAR(500) NOT NULL,
  fecha_creacion DATETIME NOT NULL
      CONSTRAINT DF_usuario_fecha_creacion DEFAULT (GETDATE()),
  estado BIT NOT NULL,
  dni NUMERIC(8) NOT NULL,
  id_rol_usuario INT NOT NULL,
  CONSTRAINT PK_usuario PRIMARY KEY (id_usuario),
  CONSTRAINT FK_usuario_persona FOREIGN KEY (dni)
      REFERENCES persona(dni),
  CONSTRAINT FK_usuario_rol FOREIGN KEY (id_rol_usuario)
      REFERENCES rol_usuario(id_rol_usuario)
);

-- ============================
-- 10. CONTRATO ALQUILER 
-- ============================
CREATE TABLE contrato_alquiler (
  id_contrato INT NOT NULL,
  fecha_inicio DATE NOT NULL
      CONSTRAINT DF_contrato_fecha_inicio DEFAULT (GETDATE()),
  fecha_fin DATE NOT NULL,
  monto DECIMAL(12,2) NOT NULL,
  condiciones VARCHAR(200) NOT NULL,
  cant_cuotas INT NOT NULL,
  fecha_creacion DATETIME NOT NULL
      CONSTRAINT DF_contrato_fecha_creacion DEFAULT (GETDATE()),
  id_inmueble INT NOT NULL,
  dni NUMERIC(8) NOT NULL,
  id_usuario INT NOT NULL,
  estado BIT NOT NULL,
  CONSTRAINT PK_contrato_alquiler PRIMARY KEY (id_contrato),
  CONSTRAINT FK_contrato_inmueble FOREIGN KEY (id_inmueble)
      REFERENCES inmueble(id_inmueble),
  CONSTRAINT FK_contrato_cliente FOREIGN KEY (dni)
      REFERENCES persona(dni),
  CONSTRAINT FK_contrato_usuario FOREIGN KEY (id_usuario)
      REFERENCES usuario(id_usuario),
  CONSTRAINT CK_contrato_fecha_fin CHECK (fecha_fin > fecha_inicio),
  CONSTRAINT CK_contrato_monto CHECK (monto > 0),
  CONSTRAINT CK_contrato_cuotas CHECK (cant_cuotas > 0)
);

-- ============================
-- 11. MÉTODO DE PAGO
-- ============================
CREATE TABLE metodo_pago (
  id_metodo_pago INT NOT NULL,
  tipo_pago VARCHAR(100) NOT NULL,
  descripcion VARCHAR(200) NOT NULL,
  CONSTRAINT PK_metodo_pago PRIMARY KEY (id_metodo_pago)
);

-- ============================
-- 12. RECIBO
-- ============================
CREATE TABLE recibo (
  id_recibo INT NOT NULL,
  fecha_emision DATETIME NOT NULL
      CONSTRAINT DF_recibo_fecha_emision DEFAULT (GETDATE()),
  nro_comprobante INT NOT NULL,
  CONSTRAINT PK_recibo PRIMARY KEY (id_recibo)
);

-- ============================
-- 13. CUOTA
-- ============================
CREATE TABLE cuota (
  nro_cuota INT NOT NULL,
  periodo DATE NOT NULL,
  fecha_vencimiento DATE NOT NULL,
  importe DECIMAL(12,2) NOT NULL,
  estado VARCHAR(100) NOT NULL,
  fecha_creacion DATETIME NOT NULL
      CONSTRAINT DF_cuota_fecha_creacion DEFAULT (GETDATE()),
  id_contrato INT NOT NULL,
  CONSTRAINT PK_cuota PRIMARY KEY (nro_cuota, id_contrato),
  CONSTRAINT FK_cuota_contrato FOREIGN KEY (id_contrato)
      REFERENCES contrato_alquiler(id_contrato),
  CONSTRAINT CK_cuota_importe CHECK (importe > 0),
  CONSTRAINT CK_cuota_nro_cuota CHECK (nro_cuota > 0),
  CONSTRAINT CK_cuota_estado CHECK (estado IN ('pendiente','pagado','vencido','anulado'))
);

-- ============================
-- 14. PAGO 
-- ============================
CREATE TABLE pago (
  id_pago INT NOT NULL,
  fecha_pago DATE NOT NULL
      CONSTRAINT DF_pago_fecha_pago DEFAULT (GETDATE()),
  monto DECIMAL(12,2) NOT NULL,
  periodo DATE NOT NULL,
  fecha_creacion DATETIME NOT NULL
      CONSTRAINT DF_pago_fecha_creacion DEFAULT (GETDATE()),
  id_metodo_pago INT NOT NULL,
  id_recibo INT NOT NULL,
  nro_cuota INT NOT NULL,
  id_contrato INT NOT NULL,   
  estado VARCHAR(50) NOT NULL CONSTRAINT DF_pago_estado DEFAULT ('pagado'),
  id_usuario INT NOT NULL,
  CONSTRAINT PK_pago PRIMARY KEY (id_pago),
  CONSTRAINT FK_pago_metodo FOREIGN KEY (id_metodo_pago)
      REFERENCES metodo_pago(id_metodo_pago),
  CONSTRAINT FK_pago_recibo FOREIGN KEY (id_recibo)
      REFERENCES recibo(id_recibo),
  CONSTRAINT FK_pago_cuota FOREIGN KEY (nro_cuota, id_contrato)
      REFERENCES cuota(nro_cuota, id_contrato),
  CONSTRAINT FK_pago_usuario FOREIGN KEY (id_usuario)
      REFERENCES usuario(id_usuario),
  CONSTRAINT CK_pago_monto CHECK (monto > 0),
  CONSTRAINT CK_pago_estado CHECK (estado IN ('pagado','anulado'))
);
GO
