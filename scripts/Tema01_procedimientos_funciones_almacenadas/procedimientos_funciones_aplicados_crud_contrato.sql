--------------------------------------------------------------------------------------------
--                       PROCEDIMIENTOS ALMACENADOS CRUD CONTRATO
--------------------------------------------------------------------------------------------


-----------------------------------------------
-- Procedimiento almacenado para dar de alta un contrato y sus cuotas
-- Crea el contrato, calcula y crea las cuotas segun el intervalo de fechas
-- y cambia el estado del inmueble a ocupado
----------------------------------------------
GO
CREATE PROCEDURE sp_crear_contrato
    @id_contrato   INT,
    @fecha_inicio  DATE,
    @fecha_fin     DATE,
    @monto_total   DECIMAL(12,2),
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

        -- VALIDACIONES PREVIAS

        -- Obtenemos los IDs de disponibilidad
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

        -- CALCULAMOS LAS CANTIDAD DE CUOTAS DEL CONTRATO

        DECLARE @cant_meses INT;

        SET @cant_meses = DATEDIFF(MONTH, @fecha_inicio, @fecha_fin) + 1;

        IF @cant_meses <= 0
        BEGIN
            RAISERROR('El intervalo de fechas no permite generar cuotas mensuales.', 16, 1);
        END;

        -- INSERTAMOS EL NUEVO CONTRATO

        INSERT INTO contrato_alquiler
        (id_contrato, fecha_inicio, fecha_fin , monto, condiciones, cant_cuotas, id_inmueble,
        dni, id_usuario, estado)
        VALUES
        (@id_contrato, @fecha_inicio, @fecha_fin, @monto_total, @condiciones, @cant_meses,
        @id_inmueble, @dni_inquilino, @id_usuario, 1);

        -- GENERAMOS LAS CUOTAS MENSUALES

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

        -- CAMBIAMOS LA DISPONIBILIDAD DEL INMUEBLE A 'Alquilado'

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

---------------------------------------------------
-- Procedimiento almacenado para editar un contrato
-- Permite cambiar el inquilino, condiciones, actualiza el monto del contrato y las cuotas pendientes a pagar
-- y si se modifica el inmueble actualiza el estado del inmueble antiguo y el nuevo
---------------------------------------------------
GO
CREATE PROCEDURE sp_editar_contrato
    @id_contrato   INT,
    @condiciones   VARCHAR(200),
    @monto_total   DECIMAL(12,2),
    @id_inmueble   INT,
    @dni_inquilino NUMERIC(8)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Se inicia la transaccion, asegurando que se ejecute el procedimieto completo y evitando incosistencias
        -- en la base de datos.
        BEGIN TRANSACTION;

        -- OBTENEMOS DATOS PARA LA VALIDACION

        DECLARE @id_inmueble_actual INT;
        DECLARE @id_disp_disponible INT, @id_disp_alquilado INT;

        -- Obtener IDs de disponibilidad
        SELECT @id_disp_disponible = id_disponibilidad 
        FROM disponibilidad WHERE nombre = 'Disponible';
        
        SELECT @id_disp_alquilado = id_disponibilidad 
        FROM disponibilidad WHERE nombre = 'Alquilado';

        -- Obtener el ID del inmueble actual del contrato
        SELECT @id_inmueble_actual = id_inmueble
        FROM contrato_alquiler
        WHERE id_contrato = @id_contrato;


        --  VALIDAMOS LOS NUEVOS DATOS

        -- Validamos el nuevo inmueble
        IF @id_inmueble_actual != @id_inmueble
        BEGIN
            IF NOT EXISTS (
                SELECT 1 FROM inmueble
                WHERE id_inmueble = @id_inmueble
                  AND estado = 1
                  AND id_disponibilidad = @id_disp_disponible
            )
            BEGIN
                RAISERROR('El nuevo inmueble no está activo o no se encuentra disponible.', 16, 1);
            END;
        END;

        -- ACTUALIZAMOS EL CONTRATO CON LOS NUEVOS DATOS

        UPDATE contrato_alquiler
        SET 
            condiciones = @condiciones,
            monto = @monto_total,       
            id_inmueble = @id_inmueble, 
            dni = @dni_inquilino    
        WHERE id_contrato = @id_contrato;

        -- ACTUALIZAMOS EL ESTADO DE LOS INMUEBLES
        IF @id_inmueble_actual != @id_inmueble
        BEGIN
            -- Liberamos el inmueble ANTIGUO
            UPDATE inmueble
            SET id_disponibilidad = @id_disp_disponible
            WHERE id_inmueble = @id_inmueble_actual;

            -- Cambiamos la disponibildad del nuevo como 'Alquilado'
            UPDATE inmueble
            SET id_disponibilidad = @id_disp_alquilado
            WHERE id_inmueble = @id_inmueble;
        END;

        -- ACTUALIZAMOS EL IMPORTE DE CUOTAS PENDIENTES
        UPDATE cuota
        SET importe = @monto_total
        WHERE id_contrato = @id_contrato
          AND estado = 'pendiente';

        -- Si todo salió bien, confirma la transacción.
        COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH
        -- Revisa si hay una transacción abierta.
        IF @@TRANCOUNT > 0
            ROLLBACK; -- Deshace todo si algo falló

        DECLARE @msg NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR('Error en sp_editar_contrato: %s', 16, 1, @msg);
    END CATCH
END;
GO

------------------------------------------------
-- Procedimiento almacenado para anular un contrato
-- Se cambia el estado del contrato a 0 (anulado)
-- Se anulan todas la cuotas pendientes a pagar
-- Se libera el inmueble asociado al contrato
----------------------------S--------------------
GO
CREATE PROCEDURE sp_anular_contrato
    @id_contrato INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Se inicia la transaccion, asegurando que se ejecute el procedimieto completo y evitando incosistencias
        -- en la base de datos.
        BEGIN TRANSACTION;

        DECLARE @id_inmueble_a_liberar INT;
        DECLARE @id_disp_disponible INT;
        DECLARE @estado_contrato_actual BIT;

        -- Obtenemos el ID del inmueble y el estado del contrato
        SELECT 
            @id_inmueble_a_liberar = id_inmueble,
            @estado_contrato_actual = estado
        FROM contrato_alquiler
        WHERE id_contrato = @id_contrato;

        IF @id_inmueble_a_liberar IS NULL
        BEGIN
            RAISERROR('El contrato especificado no existe.', 16, 1);
        END;

        -- Se obtiene el ID de 'Disponible'
        SELECT @id_disp_disponible = id_disponibilidad
        FROM disponibilidad
        WHERE nombre = 'Disponible';
        
        -- Se cambia el estado del contrato a 0 (anulado)
        UPDATE contrato_alquiler
        SET estado = 0
        WHERE id_contrato = @id_contrato;

        -- Se anulan todas las cuotas que tienen estado 'pendientes'
        UPDATE cuota
        SET estado = 'anulado'
        WHERE id_contrato = @id_contrato AND estado = 'pendiente';

        -- Liberaramos el inmueble seteando su disponibilidad a 'Disponible'
        UPDATE inmueble
        SET id_disponibilidad = @id_disp_disponible
        WHERE id_inmueble = @id_inmueble_a_liberar;
        
        -- Si todo salió bien, confirma la transacción.
        COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH
        -- Revisa si hay una transacción abierta.
        IF @@TRANCOUNT > 0
            -- Anula todos los cambios hechos
            ROLLBACK;

        DECLARE @msg NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR('Error en sp_anular_contrato: %s', 16, 1, @msg);
    END CATCH
END;
GO

-- PROCEDIMIENTO PLUS
-- Procedimiento: sp_insertar_persona
-- Descripción: Inserta una nueva persona en la tabla persona, con validación de duplicado
CREATE PROCEDURE sp_insertar_persona
    @dni NUMERIC(8),
    @nombre VARCHAR(200),
    @apellido VARCHAR(200),
    @correo_electronico VARCHAR(200),
    @telefono VARCHAR(50),
    @fecha_nacimiento DATE,
    @id_direccion INT,
    @estado BIT
AS
BEGIN

    -- Verificar si el DNI ya existe
    IF EXISTS (SELECT 1 FROM persona WHERE dni = @dni)
    BEGIN
        PRINT 'Error: Ya existe una persona con ese DNI.';
        RETURN;
    END;

    -- Verificar si el correo ya está en uso
    IF EXISTS (SELECT 1 FROM persona WHERE correo_electronico = @correo_electronico)
    BEGIN
        PRINT 'Error: El correo electrónico ya está registrado.';
        RETURN;
    END;

    INSERT INTO persona (dni, nombre, apellido, correo_electronico, telefono, fecha_nacimiento, id_direccion, estado)
    VALUES (@dni, @nombre, @apellido, @correo_electronico, @telefono, @fecha_nacimiento, @id_direccion, @estado);

    PRINT 'Persona insertada correctamente.';
END;
GO

--------------------------------------------------------------------------------------------------
--                                  FUNCIONES ALMACENADAS                                       
--------------------------------------------------------------------------------------------------


-------------------------------------------------------
-- Funcion almecenada que recibe un id_contrato
-- y calcula el monto pendiente a pagar para completar el contrato 
------------------------------------------------------
GO
CREATE FUNCTION fn_calcular_deuda_pendiente (
    @id_contrato INT
)
RETURNS DECIMAL(12,2) 
AS
BEGIN
    DECLARE @total_pendiente DECIMAL(12,2);

    -- Suma el importe de todas las cuotas de ese contrato
    -- que tengan el estado 'pendiente'
    SELECT @total_pendiente = SUM(importe)
    FROM cuota
    WHERE id_contrato = @id_contrato AND estado = 'pendiente';

    RETURN ISNULL(@total_pendiente, 0.00);
END;
GO


--------------------------------------------------
-- Funcion almacenada que recibe el id_contrato
-- y obtiene su estado actual
-------------------------------------------------
GO
CREATE FUNCTION fn_obtener_estado_contrato (
    @id_contrato INT
)
RETURNS VARCHAR(50)
AS
BEGIN
    DECLARE @estado_calculado VARCHAR(50);
    DECLARE @fecha_inicio DATE, @fecha_fin DATE, @estado_bit BIT;

    -- Se obtiene los datos necesarios del contrato
    SELECT 
        @fecha_inicio = fecha_inicio,
        @fecha_fin = fecha_fin,
        @estado_bit = estado
    FROM contrato_alquiler
    WHERE id_contrato = @id_contrato;

    IF @fecha_inicio IS NULL
    BEGIN
        SET @estado_calculado = 'Contrato Inexistente';
    END
    ELSE
    BEGIN
        SET @estado_calculado = CASE 
            WHEN @estado_bit = 0 THEN 'Anulado'
            WHEN GETDATE() > @fecha_fin THEN 'Finalizado'
            WHEN GETDATE() BETWEEN DATEADD(DAY, -30, @fecha_fin) AND @fecha_fin THEN 'Próximo a Vencer'
            WHEN GETDATE() BETWEEN @fecha_inicio AND @fecha_fin THEN 'Vigente'
            WHEN GETDATE() < @fecha_inicio THEN 'Pendiente de Inicio'
            ELSE 'Estado Indeterminado'
        END;
    END;

    RETURN @estado_calculado;
END;
GO

-------------------------------------------------
-- Funcion almacenada para obtener los contratos
-- que tienen al menos una cuota vencida
-------------------------------------------------
GO
CREATE FUNCTION fn_obtener_contratos_con_mora ()
RETURNS TABLE
AS
RETURN (
    SELECT 
        c.id_contrato,
        c.fecha_inicio,
        c.fecha_fin,
        c.monto,
        c.dni AS dni_inquilino,
        p.nombre +' '+ p.apellido AS nombre_inquilino,
        i.descripcion AS descripcion_inmueble
    FROM contrato_alquiler AS c
    INNER JOIN inmueble AS i ON c.id_inmueble = i.id_inmueble
    INNER JOIN persona AS p ON c.dni = p.dni
    WHERE c.estado = 1 
        AND EXISTS (
            SELECT null
            FROM cuota AS cu
            WHERE cu.id_contrato = c.id_contrato AND cu.estado = 'pendiente' 
            AND cu.fecha_vencimiento < GETDATE() 
        )
);
GO


