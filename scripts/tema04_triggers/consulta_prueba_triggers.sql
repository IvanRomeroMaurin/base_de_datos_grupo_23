------------------------------------------------------------
-- PRUEBAS DE TRIGGERS SOBRE LA TABLA "pago"

-- Este script asume que la base de datos ya cuenta con:
--   * Datos cargados previamente (contratos, cuotas, usuarios,
--     recibos, métodos de pago, etc.).
--   * Al menos dos pagos existentes con estado 'pagado'.
--   * Los triggers de auditoría, restricción y bloqueo ya creados.
--
-- Se puede ajustar los ID de los pagos según su entorno.
------------------------------------------------------------

USE alquiler_pro;
GO

-- Ajustar según los ID reales en la base de datos
-- PAGO A: se anula y luego se intenta modificar
-- PAGO B: se intenta cambiar el monto y eliminarlo
------------------------------------------------------------
-- id_pago = 1   .PAGO A (modificar si corresponde)
-- id_pago = 2   .PAGO B (modificar si corresponde)

SELECT * FROM pago
------------------------------------------------------------
-- PRUEBA 1: Anulación válida del PAGO A
------------------------------------------------------------
UPDATE pago
SET estado = 'anulado'
WHERE id_pago = 1;

--Verificar si el pago se anuló y se guardo su respectiva copia de auditoria
SELECT * FROM pago WHERE id_pago = 1;
SELECT * FROM auditoria_pago WHERE id_pago_old = 1 ORDER BY id_auditoria DESC;


------------------------------------------------------------
-- PRUEBA 2: Intentar modificar un pago ya anulado (PAGO A)
------------------------------------------------------------
UPDATE pago
SET estado = 'pagado'
WHERE id_pago = 1;

-- Verificar que no se modificó
SELECT * FROM pago WHERE id_pago = 1;


------------------------------------------------------------
-- PRUEBA 3: Intentar cambiar el monto del PAGO B
------------------------------------------------------------
UPDATE pago
SET monto = monto + 1000
WHERE id_pago = 2;


-- Verificar que no se modificó
SELECT * FROM pago WHERE id_pago = 2;


------------------------------------------------------------
-- PRUEBA 4: Intentar eliminar físicamente el PAGO B
------------------------------------------------------------
DELETE FROM pago
WHERE id_pago = 2;


-- Verificar que no se realizó la baja fisica
SELECT * FROM pago WHERE id_pago = 2;


------------------------------------------------------------
-- PRUEBA 5: Consultar el historial completo de auditoría
------------------------------------------------------------
SELECT * FROM auditoria_pago ORDER BY id_auditoria DESC;

/*
Conclusión:

Las pruebas realizadas permiten verificar el correcto funcionamiento 
de los triggers implementados sobre la tabla pago. Los disparadores cumplen
adecuadamente sus objetivos: registran auditoría, evitan modificaciones 
indebidas, impiden la alteración del monto original y bloquean la eliminación física de registros.

De acuerdo con los resultados obtenidos, 
el sistema garantiza la integridad lógica del historial de pagos anulados
y preserva la trazabilidad completa de cada operación realizada,
asegurando que ninguna acción crítica pueda ejecutarse fuera de las reglas establecidas por la capa de negocio.
+/