-- ***************************************************************
-- ARCHIVO: 03_creacion_indice_agrupado_simple.sql
-- TAREA: Definir un índice agrupado (Clustered) sobre la columna fecha.
-- ***************************************************************

-- 1. Verificación: Asegurar que no haya ya un índice agrupado (solo puede haber uno)
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID('Pruebas_Rendimiento_Indices') AND type_desc = 'CLUSTERED')
    DROP INDEX [IX_CL_FechaOperacion_Temp] ON Pruebas_Rendimiento_Indices;
    
-- Si la columna ID tuviera un índice primario agrupado por defecto, habría que eliminarlo primero.
-- Aquí asumimos que la tabla es un Heap (sin índice agrupado inicial)

-- 2. Creación del Índice Agrupado (Clustered Index)
------------------------------------------------------
-- Ordena FÍSICAMENTE los datos por fecha, optimizando la búsqueda por rango.
CREATE CLUSTERED INDEX IX_CL_FechaOperacion 
ON Pruebas_Rendimiento_Indices (FechaOperacion ASC);

-- 3. Verificación
-------------------
SELECT 
    'Índice Agrupado Creado', 
    name, 
    type_desc
FROM 
    sys.indexes 
WHERE 
    object_id = OBJECT_ID('Pruebas_Rendimiento_Indices')
    AND name = 'IX_CL_FechaOperacion';
