-- ***************************************************************
-- ARCHIVO: 06_busqueda_con_indice_incluido.sql
-- TAREA: Repetir la búsqueda por período sobre la tabla CON Índice Optimizado.
-- OBJETIVO: Confirmar la máxima mejora de rendimiento.
-- ***************************************************************

-- Configurar SSMS para la medición
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
