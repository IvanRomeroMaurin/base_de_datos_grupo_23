-- ***************************************************************
-- ARCHIVO: 06_busqueda_con_indice_incluido.sql.
-- TAREA: Repetir la búsqueda por período sobre la tabla PAGO CON Índice Optimizado.
-- OBJETIVO: Confirmar la máxima mejora de rendimiento (Index Seek Puro).
-- ***************************************************************

USE alquiler_pro;
GO

-- Configurar SSMS para la medición (Ctrl+M y Shift+Alt+S activados)
SET STATISTICS IO ON; 
SET STATISTICS TIME ON; 

-- Consulta IDÉNTICA a la línea base
SELECT
    P.id_pago,
    P.fecha_pago,
    P.monto,
    P.periodo,
    C.id_contrato,
    PE.nombre + ' ' + PE.apellido AS Cliente
FROM
    pago P 
INNER JOIN
    contrato_alquiler C ON P.id_contrato = C.id_contrato
INNER JOIN
    persona PE ON C.dni = PE.dni
WHERE
    P.fecha_pago BETWEEN '2023-06-01' AND '2023-06-30' -- Rango de prueba
ORDER BY 
    P.fecha_pago;

-- Limpieza
SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
GO

-- NOTA: El Plan de Ejecución debe mostrar un Index Seek sin Key Lookup en PAGO.
