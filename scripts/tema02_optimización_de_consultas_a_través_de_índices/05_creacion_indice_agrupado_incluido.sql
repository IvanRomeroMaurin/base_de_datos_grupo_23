-- ***************************************************************
-- ARCHIVO: 05_creacion_indice_agrupado_incluido.sql (CORREGIDO)
-- TAREA: Borrar índice anterior y definir un Índice NO Agrupado CON COLUMNAS INCLUIDAS (Covering Index).
-- OBJETIVO: Crear un "Covering Index" para eliminar la operación Key Lookup.
-- ***************************************************************

-- 1. BORRAR el índice agrupado anterior (de la medición 2)
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID('Pruebas_Rendimiento_Indices') AND name = 'IX_CL_FechaOperacion')
    DROP INDEX IX_CL_FechaOperacion ON Pruebas_Rendimiento_Indices;
    
-- Nota: Si tu tabla ID tiene una Primary Key CLUSTERED, omite esta línea o ajusta el nombre.

-- 2. Creación del Índice NO Agrupado (NONCLUSTERED Index)
------------------------------------------------------------
-- Creamos un índice que "cubre" la consulta completa:
-- - Clave del Índice: FechaOperacion (para el WHERE/rango)
-- - Columnas Incluidas: ID, Valor, Descripcion (para el SELECT)

CREATE NONCLUSTERED INDEX IX_NC_FechaOperacion_Cubridor
ON Pruebas_Rendimiento_Indices (FechaOperacion ASC)
INCLUDE (ID, Valor, Descripcion);

-- 3. Verificación
-------------------
SELECT 'Índice Cubridor Creado', name, type_desc
FROM sys.indexes 
WHERE object_id = OBJECT_ID('Pruebas_Rendimiento_Indices')
AND name = 'IX_NC_FechaOperacion_Cubridor';
