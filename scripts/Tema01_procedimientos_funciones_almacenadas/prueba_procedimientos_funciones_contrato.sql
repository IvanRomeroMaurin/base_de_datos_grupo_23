
------------------------------------------------------
-- Insercion de datos en la tabla contrato utilizando
-- el procedimiento almacenado sp_crear_contrato
-------------------------------------------------------
DECLARE @id_usuario_admin INT = 1;

EXEC sp_crear_contrato
    @id_contrato = 1001,
    @fecha_inicio = '2025-12-01',
    @fecha_fin = '2026-05-31', 
    @monto_total = 550000.00,
    @condiciones = 'Depósito en garantía. No se permiten mascotas.',
    @id_inmueble = 1,
    @dni_inquilino = 25607082,
    @id_usuario = @id_usuario_admin;

EXEC sp_crear_contrato
    @id_contrato = 1002,
    @fecha_inicio = '2026-01-01',
    @fecha_fin = '2026-12-31', 
    @monto_total = 720000.00,
    @condiciones = 'Ajuste semestral s/ IPC. Uso exclusivo vivienda.',
    @id_inmueble = 2,
    @dni_inquilino = 25848313,
    @id_usuario = @id_usuario_admin;

EXEC sp_crear_contrato
    @id_contrato = 1003,
    @fecha_inicio = '2026-02-01',
    @fecha_fin = '2027-07-31', 
    @monto_total = 880000.00,
    @condiciones = 'El inquilino se hace cargo de servicios e impuestos.',
    @id_inmueble = 3,
    @dni_inquilino = 25849240,
    @id_usuario = @id_usuario_admin;

EXEC sp_crear_contrato
    @id_contrato = 1004,
    @fecha_inicio = '2025-03-01',
    @fecha_fin = '2027-02-28', 
    @monto_total = 950000.00,
    @condiciones = 'Prohibido subalquilar. Garante propietario.',
    @id_inmueble = 4,
    @dni_inquilino = 26089544,
    @id_usuario = @id_usuario_admin;

EXEC sp_crear_contrato
    @id_contrato = 1005,
    @fecha_inicio = '2026-01-15',
    @fecha_fin = '2027-01-14',
    @monto_total = 1000000.00,
    @condiciones = 'Mantenimiento de pileta a cargo del inquilino.',
    @id_inmueble = 5,
    @dni_inquilino = 26120471,
    @id_usuario = @id_usuario_admin;


-- -----------------------------------------------------------------
-- Inserción de datos a la tabla contrato y cuotas con operaciones directas
-- -----------------------------------------------------------------

--  Calculamos la cantidad de cuotas
DECLARE @cant_meses INT;
SET @cant_meses = DATEDIFF(MONTH, '2025-01-01', '2026-12-31') + 1;

-- Insertamos el contrato 
INSERT INTO contrato_alquiler
(id_contrato, fecha_inicio, fecha_fin , monto, condiciones, cant_cuotas, id_inmueble, dni, id_usuario, estado)
VALUES
(1006, '2025-01-01', '2026-12-31', 100000.00, 'Sin depósito. Sin mascotas.', @cant_meses, 21, 20541231, 1, 1);

-- Generamos las cuotas del contrato
DECLARE @nro_cuota    INT = 1,
        @periodo      DATE,
        @vencimiento  DATE;

WHILE @nro_cuota <= @cant_meses
BEGIN
    
    SET @periodo = DATEADD(MONTH, @nro_cuota - 1, '2025-01-01');
    SET @vencimiento = DATEFROMPARTS(YEAR(@periodo), MONTH(@periodo), 10);

    -- Insertamos la cuota
    INSERT INTO cuota
    ( nro_cuota , periodo, fecha_vencimiento, importe, estado, id_contrato )
    VALUES
    (@nro_cuota, @periodo, @vencimiento, 10000.00, 'pendiente', 1006);

    SET @nro_cuota += 1;
END;
-- Actualizamos el estado del inmueble a alquilado
UPDATE inmueble
SET id_disponibilidad = (SELECT id_disponibilidad FROM disponibilidad WHERE nombre = 'Alquilado')
WHERE id_inmueble = 21;

-----------------------------------------------------------------------------------------------------------------

-- Actualizamos un contrato utilizando el procedimiento almacenado sp_editar_contrato
EXEC sp_editar_contrato
    @id_contrato = 1003,
    @condiciones = 'El inquilino se hace cargo de servicios e impuestos. (MODIFICADO: Se acepta un garante solidario)',
    @monto_total = 900000.00, 
    @id_inmueble = 6,         
    @dni_inquilino = 28743085;  
GO

-- Anulamos un contrato con el procedimiento almacenado 
EXEC sp_anular_contrato @id_contrato = 1002;

-------------------------------------------------------------------------------------------------------------------

-- Prueba de funciones almacenadas 

-- Calculamos el monto pendiente a pagar por contrato con el id_contrato = 1003
SELECT dbo.fn_calcular_deuda_pendiente(1003);

-- Obtenemos el estado actual del contrato con id_contrato = 1003
SELECT dbo.fn_obtener_estado_contrato(1003);

-- Obtnemos todos los contratos que tienen al menos una cuota vencida
SELECT * FROM dbo.fn_obtener_contratos_con_mora();


---------------------------------------------------------------------------------------------------------------------
-- COMPARACIÓN DE EFICIENCIA ENTRE OPERACIONES DIRECTAS Y PROCEDIMIENTOS/FUNCIONES

-- PRUEBA COMPARACION DE FUNCION CON OPERACION DIRECTA

SET STATISTICS TIME ON;
GO

-- Prueba A: Ejecución usando la FUNCIÓN
PRINT 'INICIO PRUEBA: Con Función fn_calcular_deuda_pendiente';

SELECT dbo.fn_calcular_deuda_pendiente(1004) AS Deuda_Con_Funcion;

PRINT 'FIN PRUEBA: Con Función';
GO

-- Prueba B: Ejecución con OPERACIÓN DIRECTA
PRINT 'INICIO PRUEBA: Con Operación Directa';

DECLARE @id_contrato_deuda INT = 1004; 
SELECT ISNULL(SUM(importe), 0.00) AS Deuda_Directa
FROM cuota
WHERE id_contrato = @id_contrato_deuda AND estado = 'pendiente';

PRINT 'FIN PRUEBA: Con Operación Directa';
GO

SET STATISTICS TIME OFF;
GO

-- CONCLUSION DE LA PRUEBA: Los tiempos trascurridos son muy similares, con diferencias de milisegundos. Sin embargo una de las
-- ventajas de la funcion radica en que permite reutilzar esta logica en 100 lugares diferentes en un sistema sin tener que copiar y pegar el select.
-- Si algun dia la logica de negocio cambia, solo se modifica en un solo lugar y se actualiza en todas las partes.

-- COMPARACION DE PROCEDIMIENTO ALMACENADO CON OPERACION DIRECTA

SET STATISTICS TIME ON;
SET NOCOUNT ON; 
GO

-- Prueba A: Ejecución usando el PROCEDIMIENTO ALMACENADO
PRINT 'INICIO PRUEBA: Con Procedimiento sp_crear_contrato';

EXEC sp_crear_contrato
    @id_contrato      = 1007,
    @fecha_inicio     = '2025-01-01',
    @fecha_fin        = '2026-12-31',
    @monto_total      = 5000.00,
    @condiciones      = 'Prueba con SP',
    @id_inmueble      = 1,
    @dni_inquilino    = 20424620,
    @id_usuario       = 1;

PRINT 'FIN PRUEBA: Con Procedimiento';
GO

-- Prueba B: Ejecución con OPERACIÓN DIRECTA 
PRINT 'INICIO PRUEBA: Con Operación Directa Script';

DECLARE @id_contrato_directo INT = 1008;
DECLARE @id_inmueble_directo INT = 4;

-- Calculamos la cantidad de cuotas
DECLARE @cant_meses INT;
SET @cant_meses = DATEDIFF(MONTH, '2025-01-01', '2026-12-31') + 1;

-- Insertamos el contrato
INSERT INTO contrato_alquiler
(id_contrato, fecha_inicio, fecha_fin , monto, condiciones, cant_cuotas, id_inmueble, dni, id_usuario, estado)
VALUES
(@id_contrato_directo, '2025-01-01', '2026-12-31', 5000.00, 'Prueba con Script', @cant_meses, @id_inmueble_directo, 20695851, 1, 1);

-- Generamos las cuotas del contrato
DECLARE @nro_cuota    INT = 1,
        @periodo      DATE,
        @vencimiento  DATE;

WHILE @nro_cuota <= @cant_meses
BEGIN
    SET @periodo = DATEADD(MONTH, @nro_cuota - 1, '2025-01-01');
    SET @vencimiento = DATEFROMPARTS(YEAR(@periodo), MONTH(@periodo), 10);
    INSERT INTO cuota
    ( nro_cuota , periodo, fecha_vencimiento, importe, estado, id_contrato )
    VALUES
    (@nro_cuota, @periodo, @vencimiento, 5000.00, 'pendiente', @id_contrato_directo);
    SET @nro_cuota += 1;
END;

-- Actualizamos el estado del inmueble
UPDATE inmueble
SET id_disponibilidad = (SELECT id_disponibilidad FROM disponibilidad WHERE nombre = 'Alquilado')
WHERE id_inmueble = @id_inmueble_directo;

PRINT 'FIN PRUEBA: Con Operación Directa';
GO
SET STATISTICS TIME OFF;
SET NOCOUNT OFF;
GO

-- CONCLUSION DE LA PRUEBA: Los tiempos transcurridos son muy similares otra vez, con diferencias minimos. Sin embargo 
-- los procedimientos almacenados son inmesamente superariores para la logica de negocio compleja, no solo por su velocidad que
-- suelen ser mas rapidos, sino tambien por su seguridad, fiabilidad y facilidad de manteniemiento.