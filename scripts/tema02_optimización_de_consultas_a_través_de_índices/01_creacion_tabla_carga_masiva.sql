-- ***************************************************************
-- ARCHIVO: 01_creacion_tabla_carga_masiva.sql
-- TAREA: Crear tabla y cargar 1,000,000+ registros para pruebas de rendimiento.
-- ***************************************************************

-- 1. CREACIÓN DE LA TABLA DE PRUEBA (Sin Índices Inicialmente)
--------------------------------------------------------------
IF OBJECT_ID('Pruebas_Rendimiento_Indices') IS NOT NULL
    DROP TABLE Pruebas_Rendimiento_Indices;

CREATE TABLE Pruebas_Rendimiento_Indices (
    ID INT IDENTITY(1,1) NOT NULL, -- Columna de identidad (Clave candidata, no es el objetivo de la prueba)
    FechaOperacion DATE NOT NULL,  -- Columna de fecha a ser indexada (OBJETIVO)
    Valor FLOAT NOT NULL,
    Descripcion VARCHAR(100)
);

-- 2. CARGA MASIVA DE DATOS (Generando 1,000,000 de filas)
----------------------------------------------------------
-- NOTA: Este script utiliza un ciclo T-SQL para generar datos de forma simulada.
-- La carga real puede tardar unos segundos dependiendo de la potencia del servidor.

DECLARE @RowCount INT = 1;
DECLARE @TargetRows INT = 1000000; -- 1 millón de registros
DECLARE @StartDate DATE = '2020-01-01';

WHILE @RowCount <= @TargetRows
BEGIN
    INSERT INTO Pruebas_Rendimiento_Indices (FechaOperacion, Valor, Descripcion)
    VALUES (
        DATEADD(day, ABS(CHECKSUM(NEWID())) % 1095, @StartDate), -- Fechas aleatorias en un rango de 3 años (1095 días)
        RAND() * 10000, -- Valor aleatorio
        'Registro de prueba ' + CAST(@RowCount AS VARCHAR(10))
    );
    SET @RowCount = @RowCount + 1;
    
    -- Insertar un registro extra en el ciclo para superar el millón
    IF @RowCount = @TargetRows
    BEGIN
        INSERT INTO Pruebas_Rendimiento_Indices (FechaOperacion, Valor, Descripcion)
        VALUES (DATEADD(day, ABS(CHECKSUM(NEWID())) % 1095, @StartDate), RAND() * 10000, 'Registro extra');
    END
END

-- 3. VERIFICACIÓN
-------------------
SELECT 
    'Carga completada', 
    COUNT(*) AS TotalRegistros 
FROM Pruebas_Rendimiento_Indices;
-- Debería retornar 1,000,001 registros.
