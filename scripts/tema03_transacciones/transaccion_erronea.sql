-- Prueba de falla para verificar la atomicidad con ROLLBACK en CATCH para que deshaga todo 
--(incluyendo la operacion exitosa) usando el mismo escenario

USE alquiler_pro;
GO

-- Declaracion de variables
DECLARE @NuevoDNI NUMERIC(8) = 33333333; -- DNI para esta prueba
DECLARE @UsuarioID INT = 1;
DECLARE @NuevoContratoID INT = 2; -- ID de contrato para esta prueba
DECLARE @InmuebleID_Inexistente INT = 999; -- Este ID no existe

PRINT '--- Iniciando Prueba de Falla (Violación de FK) ---';
BEGIN TRANSACTION;

BEGIN TRY
    -- Se inserta nuevo inquilino
    PRINT 'Intentando insertar persona (DNI 33333333)...';
    INSERT INTO persona (dni, nombre, apellido, correo_electronico, telefono, fecha_nacimiento, id_direccion, estado)
    VALUES (@NuevoDNI, 'Laura', 'Diaz', 'laura.diaz@email.com', '3794333333', '1998-01-15', 2, 1);
    PRINT '-> Persona insertada (temporalmente).';

    -- Se provoca un error de clave foranea insertando contrato para un inmueble que no existe
    PRINT 'Provocando error...';
    INSERT INTO contrato_alquiler (id_contrato, fecha_inicio, fecha_fin, monto, condiciones, cant_cuotas, id_inmueble, dni, id_usuario, estado)
    VALUES (
        @NuevoContratoID, GETDATE(), DATEADD(year, 1, GETDATE()), 
        50000.00, 'Pago del 1 al 10', 12, 
        @InmuebleID_Inexistente, -- Este inmueble no existe
        @NuevoDNI, 
        @UsuarioID, 
        1
    );

    -- Esta sentencia no se va a ejecutar
    PRINT 'Commit...';
    COMMIT TRANSACTION;

END TRY
BEGIN CATCH
    PRINT '--- ¡ERROR DETECTADO! ---';
    PRINT 'Mensaje: ' + ERROR_MESSAGE(); 
  
    IF (@@TRANCOUNT > 0)
    BEGIN
        PRINT 'Revirtiendo la transacción completa (ROLLBACK)...';
        ROLLBACK TRANSACTION;
        PRINT '-> Transacción revertida. @@TRANCOUNT = ' + CAST(@@TRANCOUNT AS VARCHAR);
    END
END CATCH
GO

-- Se verifica que la persona no se haya insertado, por el error antes hecho no deberia existir
PRINT '--- Verificación Post-Fallo ---';
PRINT 'Buscando a la persona (33333333)';
SELECT * FROM persona WHERE dni = 33333333;
GO