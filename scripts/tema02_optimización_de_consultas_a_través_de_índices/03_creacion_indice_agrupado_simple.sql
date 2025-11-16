-- ***************************************************************
-- ARCHIVO: 03_creacion_indice_agrupado_simple.sql (VERSIÓN FINAL Y SEGURA)
-- TAREA: Definir un índice agrupado (Clustered) sobre la columna fecha_pago en la tabla PAGO.
-- OBJETIVO: Reemplazar la PK agrupada por defecto para usar la fecha como índice agrupado.
-- ***************************************************************

USE alquiler_pro;
GO

-- 1. IDENTIFICAR Y ELIMINAR LA CLAVE PRIMARIA CLUSTERED (PK_pago)
-- Al eliminar la PK CLUSTERED, SQL Server convierte la tabla de nuevo en un HEAP (sin ordenación).
DECLARE @pk_name NVARCHAR(128);

SELECT @pk_name = name 
FROM sys.indexes 
WHERE object_id = OBJECT_ID('pago') 
AND is_primary_key = 1 
AND type_desc = 'CLUSTERED';

IF @pk_name IS NOT NULL
BEGIN
    EXEC('ALTER TABLE pago DROP CONSTRAINT ' + @pk_name);
    PRINT 'Clave primaria CLUSTERED anterior eliminada: ' + @pk_name;
END
ELSE
BEGIN
    PRINT 'No se encontró PK CLUSTERED para eliminar, continuando...';
END

-- 2. Creación del Índice Agrupado (Clustered Index)
------------------------------------------------------
-- Ordena FÍSICAMENTE los datos por fecha_pago. Esto crea el nuevo índice agrupado.
CREATE CLUSTERED INDEX IX_CL_Pago_Fecha
ON pago (fecha_pago ASC);

-- 3. RECREAR la Clave Primaria (PK_pago) como NO AGRUPADA
--------------------------------------------------------------
-- La PK debe seguir existiendo, pero la convertimos a NONCLUSTERED para que no interfiera.
ALTER TABLE pago ADD CONSTRAINT PK_pago PRIMARY KEY NONCLUSTERED (id_pago);

-- 4. Verificación
-------------------
SELECT 
    'Índice Agrupado Creado en PAGO', 
    name, 
    type_desc
FROM 
    sys.indexes 
WHERE 
    object_id = OBJECT_ID('pago')
    AND name = 'IX_CL_Pago_Fecha';
GO
