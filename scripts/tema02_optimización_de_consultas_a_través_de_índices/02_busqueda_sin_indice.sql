-- ***************************************************************
-- ARCHIVO: 02_busqueda_sin_indice.sql
-- TAREA: Realizar una búsqueda por período sobre la tabla sin índices.
-- OBJETIVO: Medir la línea base de rendimiento (Table Scan).
-- ***************************************************************

-- Configurar SQL Server Management Studio (SSMS) para la medición
-- 1. Asegúrate de activar "Incluir el Plan de Ejecución Real" (Ctrl+M) antes de ejecutar.
-- 2. Asegúrate de activar "Estadísticas de Cliente" (Shift+Alt+S) para medir los tiempos.
SET STATISTICS IO ON; -- Muestra el número de lecturas de disco
SET STATISTICS TIME ON; -- Muestra el tiempo de CPU y tiempo transcurrido

-- Consulta de búsqueda por un rango de 30 días
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

-- Limpieza (Apaga las estadísticas después de la prueba)
SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
