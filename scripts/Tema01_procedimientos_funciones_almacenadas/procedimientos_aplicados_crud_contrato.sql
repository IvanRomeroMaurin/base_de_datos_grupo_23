GO
CREATE OR ALTER PROCEDURE sp_crear_contrato
    @id_contrato   INT,
    @fecha_inicio  DATE,
    @fecha_fin     DATE,
    @monto_total   DECIMAL(12,2), -- Este es el monto mensual del contrato
    @condiciones   VARCHAR(200),
    @id_inmueble   INT,
    @dni_inquilino NUMERIC(8),
    @id_usuario    INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Se inicia la transaccion, asegurando que se ejecute el procedimieto completo y evitando incosistencias
        -- en la base de datos.
        BEGIN TRANSACTION;

        ----------------------------------------------------
        -- 1) VALIDACIONES PREVIAS
        ----------------------------------------------------

        -- Se verifica que el inquilino elegido tenga estado activo = 1
        IF NOT EXISTS (
            SELECT 1
            FROM persona
            WHERE dni = @dni_inquilino
              AND estado = 1
        )
        BEGIN
            RAISERROR('El inquilino no existe o no está activo.', 16, 1);
        END;

        -- Obtener IDs de disponibilidad (VERSIÓN ACTUALIZADA)
        DECLARE @id_disp_disponible INT,
                @id_disp_alquilado  INT;
        
        -- Se busca el ID de 'Disponible'
        SELECT @id_disp_disponible = id_disponibilidad 
        FROM disponibilidad 
        WHERE nombre = 'Disponible';
        
        -- Se busca el ID de 'Alquilado'
        SELECT @id_disp_alquilado = id_disponibilidad 
        FROM disponibilidad 
        WHERE nombre = 'Alquilado';

        -- Se verifica que el inmueble elegido este disponible y su estado sea activo  = 1
        IF NOT EXISTS (
            SELECT 1
            FROM inmueble
            WHERE id_inmueble = @id_inmueble
              AND estado = 1
              AND id_disponibilidad = @id_disp_disponible
        )
        BEGIN
            RAISERROR('El inmueble no está activo o no se encuentra disponible.', 16, 1);
        END;

        -- Se verifica que el rango de fechas sea valido
        IF @fecha_fin <= @fecha_inicio
        BEGIN
            RAISERROR('La fecha de fin debe ser mayor a la fecha de inicio.', 16, 1);
        END;

        ----------------------------------------------------
        -- 2) CALCULAR CANTIDAD DE CUOTAS DEL CONTRATO
        ----------------------------------------------------
        DECLARE @cant_meses INT;

        SET @cant_meses = DATEDIFF(MONTH, @fecha_inicio, @fecha_fin) + 1;

        IF @cant_meses <= 0
        BEGIN
            RAISERROR('El intervalo de fechas no permite generar cuotas mensuales.', 16, 1);
        END;

        ----------------------------------------------------
        -- 3) INSERTAR CONTRATO
        ----------------------------------------------------
        INSERT INTO contrato_alquiler
        (id_contrato, fecha_inicio, fecha_fin , monto, condiciones, cant_cuotas, id_inmueble,
        dni, id_usuario, estado)
        VALUES
        (@id_contrato, @fecha_inicio, @fecha_fin, @monto_total, @condiciones, @cant_meses,
        @id_inmueble, @dni_inquilino, @id_usuario, 1);

        ----------------------------------------------------
        -- 4) GENERAR CUOTAS MENSUALES
        ----------------------------------------------------
        DECLARE 
            @nro_cuota   INT = 1,
            @periodo     DATE,
            @vencimiento DATE;

        WHILE @nro_cuota <= @cant_meses
        BEGIN
            -- Periodo: primer día del mes
            SET @periodo = DATEFROMPARTS(
                                YEAR(DATEADD(MONTH, @nro_cuota - 1, @fecha_inicio)),
                                MONTH(DATEADD(MONTH, @nro_cuota - 1, @fecha_inicio)),
                                1
                            );

            -- Vencimiento: día 10 del mes del período
            SET @vencimiento = DATEFROMPARTS(YEAR(@periodo), MONTH(@periodo), 10);

            -- Se inserte la cuota perteneciente al contrato, con su periodo y fecha de vencimiento
            INSERT INTO cuota
            ( nro_cuota , periodo, fecha_vencimiento, importe, estado, id_contrato )
            VALUES
            (@nro_cuota, @periodo, @vencimiento, @monto_total, 'pendiente', @id_contrato);

            SET @nro_cuota += 1;
        END;

        ----------------------------------------------------
        -- 5) CAMBIAR DISPONIBILIDAD DEL INMUEBLE A 'Alquilado'
        ----------------------------------------------------
        UPDATE inmueble
        SET id_disponibilidad = @id_disp_alquilado
        WHERE id_inmueble = @id_inmueble;

        -- Si todo salió bien, se confirma la transacción.
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Revisa si hay una transacción abierta.
        IF @@TRANCOUNT > 0
            -- Anula todos los cambios hechos desde el 'BEGIN TRANSACTION'
            ROLLBACK;

        DECLARE @msg NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR('Error en sp_crear_contrato: %s', 16, 1, @msg);
    END CATCH
END;
GO


USE alquiler_pro;
GO

-- Declaramos una variable para el ID de usuario (admin) que crea los contratos
DECLARE @id_usuario_admin INT = 1;

-- -----------------------------------------------------------------
-- CONTRATO 1: 6 Meses
-- Inmueble: 1 ('Departamento 2 ambientes en Centro')
-- Inquilino: 25607082
-- -----------------------------------------------------------------
EXEC sp_crear_contrato
    @id_contrato   = 1001,
    @fecha_inicio  = '2025-12-01',
    @fecha_fin     = '2026-05-31', -- 6 meses
    @monto_total   = 550000.00,
    @condiciones   = 'Depósito en garantía. No se permiten mascotas.',
    @id_inmueble   = 1,
    @dni_inquilino = 25607082,
    @id_usuario    = @id_usuario_admin;

-- -----------------------------------------------------------------
-- CONTRATO 2: 1 Año (12 meses)
-- Inmueble: 2 ('Casa amplia 3 dormitorios')
-- Inquilino: 25848313
-- -----------------------------------------------------------------
EXEC sp_crear_contrato
    @id_contrato   = 1002,
    @fecha_inicio  = '2026-01-01',
    @fecha_fin     = '2026-12-31', -- 12 meses
    @monto_total   = 720000.00,
    @condiciones   = 'Ajuste semestral s/ IPC. Uso exclusivo vivienda.',
    @id_inmueble   = 2,
    @dni_inquilino = 25848313,
    @id_usuario    = @id_usuario_admin;

-- -----------------------------------------------------------------
-- CONTRATO 3: 1.5 Años (18 meses)
-- Inmueble: 3 ('PH 2 ambientes con patio')
-- Inquilino: 25849240
-- -----------------------------------------------------------------
EXEC sp_crear_contrato
    @id_contrato   = 1003,
    @fecha_inicio  = '2026-02-01',
    @fecha_fin     = '2027-07-31', -- 18 meses
    @monto_total   = 880000.00,
    @condiciones   = 'El inquilino se hace cargo de servicios e impuestos.',
    @id_inmueble   = 3,
    @dni_inquilino = 25849240,
    @id_usuario    = @id_usuario_admin;

-- -----------------------------------------------------------------
-- CONTRATO 4: 2 Años (24 meses)
-- Inmueble: 4 ('Monoambiente luminoso')
-- Inquilino: 26089544
-- -----------------------------------------------------------------
EXEC sp_crear_contrato
    @id_contrato   = 1004,
    @fecha_inicio  = '2026-03-01',
    @fecha_fin     = '2028-02-29', -- 24 meses (2028 es bisiesto)
    @monto_total   = 950000.00,
    @condiciones   = 'Prohibido subalquilar. Garante propietario.',
    @id_inmueble   = 4,
    @dni_inquilino = 26089544,
    @id_usuario    = @id_usuario_admin;

-- -----------------------------------------------------------------
-- CONTRATO 5: 1 Año (12 meses)
-- Inmueble: 5 ('Casa con pileta y garage')
-- Inquilino: 26120471
-- -----------------------------------------------------------------
EXEC sp_crear_contrato
    @id_contrato   = 1005,
    @fecha_inicio  = '2026-01-15',
    @fecha_fin     = '2027-01-14', -- 12 meses
    @monto_total   = 1000000.00,
    @condiciones   = 'Mantenimiento de pileta a cargo del inquilino.',
    @id_inmueble   = 5,
    @dni_inquilino = 26120471,
    @id_usuario    = @id_usuario_admin;


