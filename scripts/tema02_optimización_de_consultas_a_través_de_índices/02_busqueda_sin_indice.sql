-- ***************************************************************
-- ARCHIVO: 02_busqueda_sin_indice.sql.
-- TAREA: Medición 1 - Búsqueda de Reporte de Pagos sin índice en fecha_pago.
-- OBJETIVO: Medir la línea base de rendimiento (Table Scan).
-- ***************************************************************
USE alquiler_pro;
GO

-- Activar estadísticas para medición en SSMS
SET STATISTICS IO ON; 
SET STATISTICS TIME ON; 

-- Consulta de reporte real (JOINs y WHERE por rango)
SELECT
    P.id_pago,
    P.fecha_pago,
    P.monto,
    P.periodo,
    C.id_contrato,
    PE.nombre + ' ' + PE.apellido AS Cliente
FROM
    pago P -- La tabla grande donde se buscará por índice
INNER JOIN
    contrato_alquiler C ON P.id_contrato = C.id_contrato
INNER JOIN
    persona PE ON C.dni = PE.dni
WHERE
    P.fecha_pago BETWEEN '2023-06-01' AND '2023-06-30' -- Rango de prueba
ORDER BY 
    P.fecha_pago;

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
-- NOTA: El Plan de Ejecución debe mostrar un Table Scan en la tabla PAGO, 
-- lo cual será lento debido al millón de registros.
