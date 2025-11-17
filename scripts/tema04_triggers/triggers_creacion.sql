------------------------------------------------------------
-- CONTENIDO: Creación de tabla de auditoría y triggers de pago
-- Descripción:
--   Crea la tabla auditoria_pago para registrar el estado anterior de un pago cuando es anulado.
--   Define triggers para:
--     -Auditar anulaciones de pagos.
--     -Bloquear eliminaciones físicas (DELETE) de pagos.
--     -Restringir los UPDATE para que solo se permita la anulación (cambio de estado a 'anulado').

------------------------------------------------------------
-- TABLA DE AUDITORÍA: auditoria_pago
-- Guarda un registro completo de el pago antes
-- de ser anulado, junto con metadatos de auditoría.
------------------------------------------------------------
GO
CREATE TABLE auditoria_pago (
    id_auditoria INT IDENTITY(1,1) PRIMARY KEY,                         -- clave primaria 

    -- Copia del estado anterior del pago
    id_pago_old INT NOT NULL,                                          
    fecha_pago_old DATE NOT NULL,                                       
    monto_old DECIMAL(12,2) NOT NULL,                                   
    periodo_old DATE NOT NULL,                                         
    fecha_creacion_old DATETIME NOT NULL,                              
    id_metodo_pago_old INT NOT NULL,                                   
    id_recibo_old INT NOT NULL,                                         
    nro_cuota_old INT NOT NULL,                                        
    id_contrato_old INT NOT NULL,                                      
    estado_old VARCHAR(50) NOT NULL,                                   
    id_usuario_old INT NOT NULL,                                        

    -- Metadatos de auditoría
    fecha_accion DATETIME NOT NULL                                      -- fecha en que se registró la auditoria
        CONSTRAINT DF_aud_pago_fecha_accion DEFAULT (GETDATE()),        -- por defecto, fecha del sistema
    usuario_bd SYSNAME NOT NULL                                         -- nombre del usuario de base que hizo el cambio
        CONSTRAINT DF_aud_pago_usuario_bd DEFAULT (SUSER_SNAME()),      -- por defecto el nombre de sesion
    accion VARCHAR(20) NOT NULL                                         -- tipo de accion realizada (ej: 'ANULACION')
);
GO


------------------------------------------------------------
-- TRIGGER: TR_pago_auditoria_anulacion
-- Tipo: AFTER UPDATE
-- Objetivo:
--   - Registrar en auditoria_pago el estado anterior de cada pago cuando su estado cambia a 'anulado'.
--   - Solo se auditan transiciones reales hacia 'anulado'.
------------------------------------------------------------
CREATE TRIGGER TR_pago_auditoria_anulacion
ON pago
AFTER UPDATE                                                         -- se ejecuta despues de realizar un UPDATE en la tabla pago
AS
BEGIN
    SET NOCOUNT ON;                                                  -- evita que se devuelvan mensajes de cuenta de filas

    INSERT INTO auditoria_pago (                                     -- inserta un nuevo registro en la tabla de auditoria
        id_pago_old,
        fecha_pago_old,
        monto_old,
        periodo_old,
        fecha_creacion_old,
        id_metodo_pago_old,
        id_recibo_old,
        nro_cuota_old,
        id_contrato_old,
        estado_old,
        id_usuario_old,
        fecha_accion,
        usuario_bd,
        accion
    )
    SELECT                                                           -- selecciona los valores anteriores desde la tabla deleted
        d.id_pago,
        d.fecha_pago,
        d.monto,
        d.periodo,
        d.fecha_creacion,
        d.id_metodo_pago,
        d.id_recibo,
        d.nro_cuota,
        d.id_contrato,
        d.estado,
        d.id_usuario,
        GETDATE(),                                                   -- fecha actual
        SUSER_SNAME(),                                               -- nombre del usuario que ejecuta el update
        'ANULACION'                                                  -- tipo de accion registrada
    FROM deleted d
    INNER JOIN inserted i                                            -- se compara el mismo pago entre las versiones vieja y nueva
        ON d.id_pago = i.id_pago                                    
    -- Solo se audita cuando el estado pasa de no estar anulado a "anulado"
    WHERE d.estado <> 'anulado'
      AND i.estado = 'anulado';                                      
END;
GO


------------------------------------------------------------
-- TRIGGER: TR_pago_bloquear_delete
-- Tipo: INSTEAD OF DELETE
-- Objetivo:
--   - Impedir la eliminacion fisica de registros en la tabla pago.
--   - Forzar el uso del borrado logico (cambio de estado).
------------------------------------------------------------
CREATE TRIGGER TR_pago_bloquear_delete
ON pago
INSTEAD OF DELETE                                                    -- intercepta el intento de eliminar antes de que ocurra
AS
BEGIN
    RAISERROR(                                                       -- genera un mensaje de error 
        'No esta permitido eliminar pagos. Utilice el mecanismo de anulacion mediante estado.',
        16, 1
    );
    ROLLBACK TRANSACTION;                                            -- cancela la operacion de DELETE
END;
GO


------------------------------------------------------------
-- TRIGGER: TR_pago_restringir_updates
-- Tipo: AFTER UPDATE
-- Objetivo:
--   - Restringir las operaciones de UPDATE sobre la tabla pago para que la ÚNICA actualización válida sea:
--        -cambiar el estado desde 'no anulado' a 'anulado',
--        - manteniendo sin cambios todos los demás campos.
--   - Bloquear cualquier intento de modificar un pago que ya se encuentra anulado.
--   - Bloquear cualquier UPDATE que intente alterar otros datos del pago (monto, fechas, método de pago, etc.).
------------------------------------------------------------
CREATE TRIGGER TR_pago_restringir_updates
ON pago
AFTER UPDATE                                                         -- se dispara luego de cada actualizacion en pago
AS
BEGIN
    SET NOCOUNT ON;

    -- 1) Caso especial: intento de anular un pago ya anulado
    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN deleted d ON d.id_pago = i.id_pago
        WHERE d.estado = 'anulado'                                   -- detecta si el pago ya estaba anulado antes del cambio
    )
    BEGIN
        RAISERROR(
          'El pago ya se encuentra anulado y no puede modificarse.', -- mensaje de error si se intenta modificar un pago ya anulado
          16, 1
        );
        ROLLBACK TRANSACTION;
        RETURN;                                                       -- finaliza la ejecucion del trigger
    END;

    -- 2) Restricción general: solo se permite cambiar el estado a "anulado"
    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN deleted d ON d.id_pago = i.id_pago
        WHERE NOT (                                                   -- si NO se cumple esta condicion, se considera una modificacion invalida
            d.estado <> 'anulado' AND                                 -- solo si el pago no estaba anulado antes y ahora su estado nuevo es 'anulado' 
            i.estado = 'anulado'  AND                                 
            d.fecha_pago = i.fecha_pago AND
            d.monto = i.monto AND
            d.periodo = i.periodo AND
            d.fecha_creacion = i.fecha_creacion AND
            d.id_metodo_pago = i.id_metodo_pago AND
            d.id_recibo = i.id_recibo AND
            d.nro_cuota = i.nro_cuota AND
            d.id_contrato = i.id_contrato AND
            d.id_usuario = i.id_usuario                               -- todos los demas campos deben permanecer iguales
        )
    )
    BEGIN
        RAISERROR(
          'Solo se permite actualizar pagos para ANULARLOS (cambiando el estado a ''anulado''). No se pueden modificar otros datos del pago.',
          16, 1
        );
        ROLLBACK TRANSACTION;                                         -- revierte el update si no cumple con la unica forma valida
    END
END;
GO

/*
 CONCLUSIÓN FINAL

 En esta implementacion se desarrollo un esquema completo de control y auditoria sobre la tabla 
 "pago", orientado a preservar la integridad y trazabilidad de los registros más sensibles del 
 sistema.

 - Se creó la tabla "auditoria_pago" para almacenar el estado previo de los pagos anulados, 
   junto con metadatos de usuario y fecha.S

 - Se definieron tres triggers que actúan de forma complementaria:

     1) TR_pago_auditoria_anulacion:
        Registra automáticamente en "auditoria_pago" toda anulación de pago realizada.

     2) TR_pago_bloquear_delete:
        Impide la eliminación física de registros, forzando el uso del borrado lógico mediante
        el campo de estado.

     3) TR_pago_restringir_updates:
        Restringe los UPDATE para que solo se permita anular un pago (cambiar su estado), 
        bloqueando modificaciones indebidas o intentos de reactivación.

 Este esquema garantiza una mayor seguridad y coherencia en la gestión de pagos, reforzando 
 las reglas de negocio y facilitando la auditoría dentro del sistema "alquiler_pro".
*/

