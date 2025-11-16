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
