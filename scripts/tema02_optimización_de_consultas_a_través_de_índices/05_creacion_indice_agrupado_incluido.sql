-- ***************************************************************
-- ARCHIVO: 05_creacion_indice_incluido.sql.
-- TAREA: Borrar índice anterior y definir un Índice NO Agrupado CON COLUMNAS INCLUIDAS (Covering Index).
-- OBJETIVO: Crear un "Covering Index" en PAGO para eliminar Key Lookup en la tabla PAGO.
-- ***************************************************************

USE alquiler_pro;
GO

-- 1. BORRAR el índice agrupado anterior (creado en la medición 2)
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID('pago') AND name = 'IX_CL_Pago_Fecha')
    DROP INDEX IX_CL_Pago_Fecha ON pago;

-- 2. Creación del Índice NO Agrupado Cubridor
------------------------------------------------------------
-- Clave del Índice: fecha_pago (para el WHERE/rango)
-- Columnas Incluidas: monto, periodo, id_contrato, id_pago (columnas necesarias para el SELECT)
CREATE NONCLUSTERED INDEX IX_NC_Pago_Cubridor
ON pago (fecha_pago ASC)
INCLUDE (monto, periodo, id_contrato, id_pago);

-- 3. Verificación
-------------------
SELECT 'Índice Cubridor Creado en PAGO', name, type_desc
FROM sys.indexes 
WHERE object_id = OBJECT_ID('pago')
AND name = 'IX_NC_Pago_Cubridor';
GO
