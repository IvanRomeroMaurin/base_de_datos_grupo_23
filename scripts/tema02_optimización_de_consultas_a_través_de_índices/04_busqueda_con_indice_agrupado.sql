-- ***************************************************************
-- ARCHIVO: 04_busqueda_con_indice_agrupado.sql
-- TAREA: Repetir la búsqueda por período sobre la tabla CON Índice Agrupado.
-- OBJETIVO: Medir la mejora de rendimiento.
-- ***************************************************************

-- Configurar SSMS para la medición (Plan de Ejecución Real y Estadísticas de Cliente activadas)
SET STATISTICS IO ON; 
SET STATISTICS TIME ON; 

-- Consulta IDÉNTICA a la línea base
SELECT 
    ID, 
    FechaOperacion, 
    Valor, 
    Descripcion
FROM 
    Pruebas_Rendimiento_Indices
WHERE 
    FechaOperacion BETWEEN '2022-05-01' AND '2022-05-31'
ORDER BY 
    FechaOperacion;

-- Limpieza
SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;

-- *** NOTA DE ANÁLISIS ***
-- Al ejecutar esto en SSMS, se debe observar una reducción drástica en "Logical Reads" 
-- y en el "Tiempo Transcurrido" en comparación con la prueba anterior (02).
