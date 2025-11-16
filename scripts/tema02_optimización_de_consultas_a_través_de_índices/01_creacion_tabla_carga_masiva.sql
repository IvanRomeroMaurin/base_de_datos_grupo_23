-- ***************************************************************
-- ARCHIVO: 01_creacion_tabla_carga_masiva.sql
-- TAREA: Carga Masiva (1M+ registros) en la tabla PAGO del sistema ALQUILER_PRO.
-- ***************************************************************

USE alquiler_pro;
GO

-- 1. PREPARACIÓN: INSERCIÓN DE DATOS BASE MÍNIMOS PARA SATISFACER FK
-------------------------------------------------------------------------
-- NOTA: Si tomamos los datos ya presentandos para cargar en la sección de Lote de datos, podemos omitir esta sección.
BEGIN TRANSACTION;

-- Inserción de un registro base por tabla (si no existen)
INSERT INTO provincia (id_provincia, nombre) VALUES (1, 'Corrientes');
INSERT INTO ciudad (id_ciudad, nombre, id_provincia) VALUES (1, 'Capital', 1);
INSERT INTO direccion (id_direccion, calle, numero, id_ciudad) VALUES (1, 'Rivadavia', 100, 1);
INSERT INTO persona (dni, nombre, apellido, correo_electronico, telefono, fecha_nacimiento, id_direccion, estado) VALUES (12345678, 'Juan', 'Perez', 'jp@mail.com', '1234', '1980-01-01', 1, 1);
INSERT INTO rol_usuario (id_rol_usuario, nombre) VALUES (1, 'Admin');
INSERT INTO usuario (id_usuario, contrasena, dni, id_rol_usuario, estado) VALUES (1, 'pass', 12345678, 1, 1);
INSERT INTO tipo_inmueble (id_tipo_inmueble, nombre) VALUES (1, 'Casa');
INSERT INTO disponibilidad (id_disponibilidad, nombre) VALUES (1, 'Disponible');
INSERT INTO inmueble (id_inmueble, descripcion, id_tipo_inmueble, dni, id_direccion, id_disponibilidad, estado) VALUES (1, 'Casa grande', 1, 12345678, 1, 1, 1);
INSERT INTO metodo_pago (id_metodo_pago, tipo_pago, descripcion) VALUES (1, 'Efectivo', 'Pago en ventanilla');
INSERT INTO recibo (id_recibo, nro_comprobante) VALUES (1, 100);

-- 2. Insertar 1 Contrato y 100 Cuotas (para que los pagos masivos tengan a qué referenciar)
IF NOT EXISTS (SELECT 1 FROM contrato_alquiler WHERE id_contrato = 1)
BEGIN
    INSERT INTO contrato_alquiler (id_contrato, fecha_inicio, fecha_fin, monto, condiciones, cant_cuotas, id_inmueble, dni, id_usuario, estado) 
    VALUES (1, '2023-01-01', '2025-01-01', 50000.00, 'Buenas', 24, 1, 12345678, 1, 1);
    
    DECLARE @i INT = 1;
    WHILE @i <= 100 -- Crear 100 cuotas
    BEGIN
        INSERT INTO cuota (nro_cuota, periodo, fecha_vencimiento, importe, estado, id_contrato)
        VALUES (@i, DATEADD(month, @i, '2023-01-01'), DATEADD(day, 10, DATEADD(month, @i, '2023-01-01')), 500.00, 'pendiente', 1);
        SET @i = @i + 1;
    END
END

COMMIT TRANSACTION;
GO

-- 3. CARGA MASIVA DE DATOS EN LA TABLA PAGO (Generando 1,000,000 de filas)
-------------------------------------------------------------------------
-- NOTA: TRUNCATE vacía la tabla PAGO para que el IDENTITY empiece desde 1.
TRUNCATE TABLE pago;

DECLARE @RowCount INT = 1;
DECLARE @TargetRows INT = 1000000; -- 1 millón de registros
DECLARE @StartDate DATE = '2023-01-01';

WHILE @RowCount <= @TargetRows
BEGIN
    -- id_pago se omite porque ahora es IDENTITY
    INSERT INTO pago (fecha_pago, monto, periodo, id_metodo_pago, id_recibo, nro_cuota, id_contrato, id_usuario)
    VALUES (
        DATEADD(day, ABS(CHECKSUM(NEWID())) % 1095, @StartDate), -- Fechas aleatorias en un rango de 3 años
        CAST( (RAND() * 50000.00) AS DECIMAL(12,2) ), 
        DATEADD(month, ABS(CHECKSUM(NEWID())) % 36, '2023-01-01'), 
        1, -- id_metodo_pago
        1, -- id_recibo
        (ABS(CHECKSUM(NEWID())) % 100) + 1, -- Cuota aleatoria entre 1 y 100
        1, -- id_contrato
        1  -- id_usuario
    );
    SET @RowCount = @RowCount + 1;
END
GO

-- 4. VERIFICACIÓN FINAL
-------------------
SELECT 
    'Carga masiva completada en PAGO', 
    COUNT(*) AS TotalPagos 
FROM pago;
