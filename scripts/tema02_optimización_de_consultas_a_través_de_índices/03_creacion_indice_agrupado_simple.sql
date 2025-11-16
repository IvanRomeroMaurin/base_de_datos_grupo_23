-- ***************************************************************
-- ARCHIVO: 03_creacion_indice_agrupado_simple.sql.
-- TAREA: Definir un índice agrupado (Clustered) sobre la columna fecha_pago en la tabla PAGO.
-- OBJETIVO: Ordenar físicamente los datos por fecha de pago.
-- ***************************************************************

USE alquiler_pro;
GO

-- 1. Borrar cualquier índice anterior que pudiera interferir
-- Nota: Solo puede haber un índice CLUSTERED. Si el Primary Key (PK) ya es CLUSTERED, esto fallará.
-- Asumimos que la PK id_pago (IDENTITY) es NONCLUSTERED o que la tabla es un Heap.
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID('pago') AND name = 'IX_CL_Pago_Fecha')
    DROP INDEX IX_CL_Pago_Fecha ON pago;

-- 2. Creación del Índice Agrupado (Clustered Index)
------------------------------------------------------
CREATE CLUSTERED INDEX IX_CL_Pago_Fecha
ON pago (fecha_pago ASC);

-- 3. Verificación
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
