-- ***************************************************************
-- ARCHIVO: 05_creacion_indice_agrupado_incluido.sql
-- TAREA: Borrar índice anterior y definir un Índice Agrupado CON COLUMNAS INCLUIDAS.
-- OBJETIVO: Crear un "Covering Index" para eliminar la operación Key Lookup.
-- ***************************************************************

-- 1. BORRAR el índice anterior (IX_CL_FechaOperacion)
------------------------------------------------------
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID('Pruebas_Rendimiento_Indices') AND name = 'IX_CL_FechaOperacion')
    DROP INDEX IX_CL_FechaOperacion ON Pruebas_Rendimiento_Indices;
    
-- Nota: Si usaste un CLUSTERED INDEX, al eliminarlo la tabla vuelve a ser un HEAP, 
-- o si usas un Primary Key CLUSTERED, lo que se elimina es el CLUSTERED. 
-- Para simplificar, asumiremos que se borra el índice que estaba en FechaOperacion.

-- 2. Creación del Índice Agrupado (Clustered Index)
------------------------------------------------------
-- NOTA: Como la consulta original selecciona ID, Valor y Descripcion, 
-- debemos crear un índice que "cubra" esas columnas, haciendo la búsqueda más eficiente.

CREATE CLUSTERED INDEX IX_CL_FechaOperacion_Incluido
ON Pruebas_Rendimiento_Indices (FechaOperacion ASC)
-- ID debe estar incluido para evitar el Key Lookup, pero ya es parte de la tabla si es PK.
-- Aquí incluiremos las columnas no-clave que seleccionamos.
INCLUDE (Valor, Descripcion);

-- 3. Verificación
-------------------
SELECT 'Índice Optimizado Creado', name, type_desc
FROM sys.indexes 
WHERE object_id = OBJECT_ID('Pruebas_Rendimiento_Indices')
AND name = 'IX_CL_FechaOperacion_Incluido';
