USE alquiler_pro;
GO
-- Declaramos una variable para el ID de usuario que crea los contratos
DECLARE @id_usuario_admin INT = 1;

EXEC sp_crear_contrato
    @id_contrato   = 1001,
    @fecha_inicio  = '2025-12-01',
    @fecha_fin     = '2026-05-31', 
    @monto_total   = 550000.00,
    @condiciones   = 'Depósito en garantía. No se permiten mascotas.',
    @id_inmueble   = 1,
    @dni_inquilino = 25607082,
    @id_usuario    = @id_usuario_admin;

EXEC sp_crear_contrato
    @id_contrato   = 1002,
    @fecha_inicio  = '2026-01-01',
    @fecha_fin     = '2026-12-31', 
    @monto_total   = 720000.00,
    @condiciones   = 'Ajuste semestral s/ IPC. Uso exclusivo vivienda.',
    @id_inmueble   = 2,
    @dni_inquilino = 25848313,
    @id_usuario    = @id_usuario_admin;

EXEC sp_crear_contrato
    @id_contrato   = 1003,
    @fecha_inicio  = '2026-02-01',
    @fecha_fin     = '2027-07-31', 
    @monto_total   = 880000.00,
    @condiciones   = 'El inquilino se hace cargo de servicios e impuestos.',
    @id_inmueble   = 3,
    @dni_inquilino = 25849240,
    @id_usuario    = @id_usuario_admin;

EXEC sp_crear_contrato
    @id_contrato   = 1004,
    @fecha_inicio  = '2025-03-01',
    @fecha_fin     = '2027-02-28', 
    @monto_total   = 950000.00,
    @condiciones   = 'Prohibido subalquilar. Garante propietario.',
    @id_inmueble   = 4,
    @dni_inquilino = 26089544,
    @id_usuario    = @id_usuario_admin;

EXEC sp_crear_contrato
    @id_contrato   = 1005,
    @fecha_inicio  = '2026-01-15',
    @fecha_fin     = '2027-01-14',
    @monto_total   = 1000000.00,
    @condiciones   = 'Mantenimiento de pileta a cargo del inquilino.',
    @id_inmueble   = 5,
    @dni_inquilino = 26120471,
    @id_usuario    = @id_usuario_admin;


EXEC sp_editar_contrato
    @id_contrato   = 1003,
    @condiciones   = 'El inquilino se hace cargo de servicios e impuestos. (MODIFICADO: Se acepta un garante solidario)',
    @monto_total   = 900000.00, -- Monto original era 880000.00
    @id_inmueble   = 6,         -- Inmueble original era 3
    @dni_inquilino = 28743085;  -- Inquilino original era 25849240
GO

EXEC sp_anular_contrato @id_contrato = 1002;