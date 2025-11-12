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

-- Prueba de error para manejar ROLLBACKS parciales con SAVEPOINT'S

USE alquiler_pro;
GO

-- Declaracion de variables
DECLARE @NuevoDNI NUMERIC(8) = 44444444; -- DNI para esta prueba
DECLARE @InmuebleID INT = 101;
DECLARE @UsuarioID INT = 1;
DECLARE @NuevoContratoID INT = 3; -- ID de contrato para esta prueba

PRINT '--- Iniciando Prueba de SAVEPOINT (Rollback Parcial) ---';
BEGIN TRANSACTION;
PRINT 'Transacción principal iniciada. @@TRANCOUNT = ' + CAST(@@TRANCOUNT AS VARCHAR);

-- Limpia la prueba anterior si es necesario
DELETE FROM cuota WHERE id_contrato = @NuevoContratoID;
DELETE FROM contrato_alquiler WHERE id_contrato = @NuevoContratoID;
DELETE FROM persona WHERE dni = @NuevoDNI;

BEGIN TRY
    -- Se inserta nuevo inquilino
    PRINT 'Intentando insertar persona (DNI 44444444)...';
    INSERT INTO persona (dni, nombre, apellido, correo_electronico, telefono, fecha_nacimiento, id_direccion, estado)
    VALUES (@NuevoDNI, 'Carlos', 'Sanchez', 'carlos.sanchez@email.com', '3794444444', '1990-03-30', 2, 1);
    PRINT '-> Persona insertada.';

    -- Se crea un punto de guardado para revertir solamente una parte de la transaccion en lugar de toda
    SAVE TRANSACTION InquilinoCreado;
    PRINT 'SAVEPOINT creado';

    -- Se inserta un contrato 
    PRINT 'Intentando insertar contrato...';
    INSERT INTO contrato_alquiler (id_contrato, fecha_inicio, fecha_fin, monto, condiciones, cant_cuotas, id_inmueble, dni, id_usuario, estado)
    VALUES (@NuevoContratoID, GETDATE(), DATEADD(year, 1, GETDATE()), 60000.00, 'Condiciones', 12, @InmuebleID, @NuevoDNI, @UsuarioID, 1);
    PRINT '-> Contrato insertado';

    -- Se provoca el error violando la restriccion de cuota cuyo nro debe ser mayor a 0
    PRINT 'Provocando error... (Insertando cuota 0)';
    INSERT INTO cuota (nro_cuota, periodo, fecha_vencimiento, importe, estado, id_contrato)
    VALUES (0, GETDATE(), DATEADD(month, 2, GETDATE()), 60000.00, 'pendiente', @NuevoContratoID);

    -- Si no hubiera error, confirmaría todo pero no llega hasta este punto
    PRINT 'Confirmando todo...';
    COMMIT TRANSACTION;

END TRY
BEGIN CATCH
    PRINT '--- ¡ERROR DETECTADO! ---';
    PRINT 'Mensaje: ' + ERROR_MESSAGE();
    
    -- Verificamos si la transacción sigue activa
    IF (@@TRANCOUNT > 0)
    BEGIN
        -- Se revierte solo hasta el SAVEPOINT
        PRINT 'Revirtiendo al SAVEPOINT...';
        ROLLBACK TRANSACTION InquilinoCreado;
        PRINT '-> Rollback parcial completado.';

        -- Se guarda la persona, o sea se realizan las operaciones antes del SAVEPOINT
        PRINT 'Confirmando el resto de la transacción...';
        COMMIT TRANSACTION;
        PRINT 'COMMIT realizado. @@TRANCOUNT = ' + CAST(@@TRANCOUNT AS VARCHAR);
    END
END CATCH
GO

-- Verificación final
PRINT '--- Verificación Post-Savepoint ---';
-- Debe existir el inquilino agregado
SELECT * FROM persona WHERE dni = 44444444;

--No debe existir el contrato con id = 3 porque fue despues del SAVEPOINT
SELECT * FROM contrato_alquiler WHERE id_contrato = 3;

-- Las cuotas del contrato 3 no deben existir
SELECT * FROM cuota WHERE id_contrato = 3;
GO