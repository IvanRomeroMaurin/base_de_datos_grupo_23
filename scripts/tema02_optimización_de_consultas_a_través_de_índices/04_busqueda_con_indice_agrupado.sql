-- ***************************************************************
-- ARCHIVO: 04_busqueda_con_indice_agrupado.sql.
-- TAREA: Repetir la búsqueda por período sobre la tabla PAGO CON Índice Agrupado.
-- OBJETIVO: Medir la mejora de rendimiento (esperar Index Seek con Key Lookup).
-- ***************************************************************

USE alquiler_pro;
GO

-- Configurar SSMS para la medición (Ctrl+M y Shift+Alt+S activados)
SET STATISTICS IO ON; 
SET STATISTICS TIME ON; 

-- Consulta IDÉNTICA a la línea base (02_busqueda_sin_indice.sql)
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

-- NOTA: El Plan de Ejecución debe mostrar un Index Seek en la tabla PAGO. 
-- El Key Lookup se mantiene porque las columnas (monto, periodo, id_pago) no son clave.
