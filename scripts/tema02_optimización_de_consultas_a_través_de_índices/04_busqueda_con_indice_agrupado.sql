-- ***************************************************************
-- ARCHIVO: 04_busqueda_con_indice_agrupado.sql (CORREGIDO CON HINT)
-- TAREA: Repetir la búsqueda por período sobre la tabla PAGO CON Índice Agrupado.
-- OBJETIVO: Medir la mejora de rendimiento (esperar Index Seek con Key Lookup).
-- ***************************************************************
USE alquiler_pro;
GO

SET STATISTICS IO ON; 
SET STATISTICS TIME ON; 

SELECT
    P.id_pago,
    P.fecha_pago,
    P.monto,
    P.periodo,
    C.id_contrato,
    PE.nombre + ' ' + PE.apellido AS Cliente
FROM
    pago P WITH (INDEX = IX_CL_Pago_Fecha) -- <<-- CORRECCIÓN: Forzar el uso del índice
INNER JOIN
    contrato_alquiler C ON P.id_contrato = C.id_contrato
INNER JOIN
    persona PE ON C.dni = PE.dni
WHERE
    P.fecha_pago BETWEEN '2023-06-01' AND '2023-06-30'
ORDER BY 
    P.fecha_pago;
--Limpieza
SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
GO
