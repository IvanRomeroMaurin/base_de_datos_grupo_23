-- ***************************************************************
-- ARCHIVO: 03_creacion_indice_agrupado_simple.sql (Versión de Máxima Seguridad)
-- TAREA: Definir un índice agrupado (Clustered) sobre la columna fecha_pago en la tabla PAGO.
-- ***************************************************************

USE alquiler_pro;
GO

-- 1. Borrar cualquier índice anterior que pudiera interferir (Mantenemos esta línea)
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID('pago') AND name = 'IX_CL_Pago_Fecha')
    DROP INDEX IX_CL_Pago_Fecha ON pago;

-- 2. Creación del Índice Agrupado (Clustered Index)
------------------------------------------------------
CREATE CLUSTERED INDEX IX_CL_Pago_Fecha
ON pago (fecha_pago ASC)
WITH (DROP_EXISTING = ON, ONLINE = OFF) -- Usamos DROP_EXISTING = ON para ser explícitos si quisiéramos cambiar una columna

-- Si tu Primary Key es CLUSTERED, el motor la convertirá a NONCLUSTERED.
-- Esta es la intención de tu prueba: usar la FECHA como ordenación física.

-- 3. Verificación
-------------------
SELECT 
    'Índice Agrupado Creado en PAGO', 
    name, 
    type_desc
FROM 
    sys.indexes 
WHERE 
    object_id = OBJECT_ID('pago')
    AND name = 'IX_CL_Pago_Fecha';
GO
