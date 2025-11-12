-- Variables para los datos del nuevo inquilino y contrato

DECLARE @NuevoDNI NUMERIC(8) = 22222222;
DECLARE @InmuebleID INT = 101;
DECLARE @UsuarioID INT = 1;
DECLARE @Disponibilidad_Alquilado INT = 2;
DECLARE @NuevoContratoID INT = 1;

-- Inicia la transacción
BEGIN TRANSACTION;

BEGIN TRY
    -- Se inserta nuevo inquilino
    PRINT 'Intentando insertar persona...';
    INSERT INTO persona (dni, nombre, apellido, correo_electronico, telefono, fecha_nacimiento, id_direccion, estado)
    VALUES (@NuevoDNI, 'Juan', 'Perez', 'juan.perez@email.com', '3794222222', '1995-10-20', 2, 1);
    PRINT '-> Persona insertada.';

    -- Se inserta el nuevo contrato de alquiler
    PRINT 'Intentando insertar contrato...';
    INSERT INTO contrato_alquiler (id_contrato, fecha_inicio, fecha_fin, monto, condiciones, cant_cuotas, id_inmueble, dni, id_usuario, estado)
    VALUES (@NuevoContratoID, GETDATE(), DATEADD(year, 1, GETDATE()), 50000.00, 'Pago del 1 al 10', 12, @InmuebleID, @NuevoDNI, @UsuarioID, 1);
    PRINT '-> Contrato insertado.';

    -- Se actualiza la disponibilidad del inmueble
    PRINT 'Intentando actualizar inmueble...';
    UPDATE inmueble
    SET id_disponibilidad = @Disponibilidad_Alquilado
    WHERE id_inmueble = @InmuebleID;
    PRINT '-> Inmueble actualizado.';

    -- Si todo salió bien, se confirma la transacción
    COMMIT TRANSACTION;
    PRINT 'ÉXITO: Transacción completada y confirmada.';

END TRY
BEGIN CATCH
    -- Si algo falla, revierte todos los cambios
    PRINT 'ERROR DETECTADO: Revirtiendo la transacción...';
    
    IF (@@TRANCOUNT > 0)
    BEGIN
        ROLLBACK TRANSACTION;
        PRINT '-> Transacción revertida.';
    END

    -- Muestra el error que ocurrió
    PRINT 'Mensaje de Error: ' + ERROR_MESSAGE();
END CATCH
GO

-- Verificación post-ejecución exitosa
PRINT '--- Verificación Post-Éxito ---';
SELECT * FROM persona WHERE dni = 22222222;
SELECT * FROM contrato_alquiler WHERE id_contrato = 1;
SELECT id_inmueble, id_disponibilidad FROM inmueble WHERE id_inmueble = 101;
GO

-- Las 3 operaciones se completan y se muestra el inquilino, el nuevo contrato y el inmueble 101 con id_disponibilidad = 2.