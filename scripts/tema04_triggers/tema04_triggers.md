# Tema 4: Triggers (Disparadores)

## Definición general

Un *trigger* (o disparador) es un tipo especial de procedimiento almacenado que se ejecuta automáticamente como respuesta a un evento determinado de modificación de datos o estructura. Su propósito principal es **automatizar la ejecución de instrucciones SQL** ante determinadas acciones (como inserciones, actualizaciones o eliminaciones), sin requerir intervención directa del usuario o de la aplicación.

En términos conceptuales, los triggers permiten implementar reglas de negocio y mecanismos de control de integridad directamente en el nivel del servidor de base de datos. De esta manera, contribuyen a mantener la coherencia de los datos, realizar auditorías o ejecutar procesos automáticos posteriores a una transacción.

De acuerdo con la documentación de Microsoft (Microsoft Learn, *CREATE TRIGGER - Transact-SQL*), un trigger se define como “un tipo especial de procedimiento almacenado que se ejecuta automáticamente cuando ocurre un evento de lenguaje de manipulación de datos (DML) o de definición de datos (DDL) específico en la base de datos” [Microsoft, 2024].

Desde el punto de vista del diseño de sistemas, los triggers complementan a las **restricciones de integridad declarativas** (como `CHECK`, `FOREIGN KEY` o `NOT NULL`) permitiendo controlar reglas más complejas que no pueden expresarse únicamente mediante dichas restricciones.

---

## Estructura y sintaxis general

En SQL Server, la creación de un trigger se realiza mediante la instrucción `CREATE TRIGGER`.  
Su estructura general puede representarse de la siguiente forma:

```sql
-- Fuente: Microsoft Learn - CREATE TRIGGER (Transact-SQL)
CREATE [ OR ALTER ] TRIGGER [ schema_name . ] trigger_name   -- Crea o modifica un trigger existente en un esquema específico
ON { table | view }                                          -- Indica la tabla o vista donde se aplicará el trigger
[ WITH <dml_trigger_option> [ , ...n ] ]                     -- Opciones como ENCRYPTION o EXECUTE AS
{ FOR | AFTER | INSTEAD OF }                                 -- Momento de ejecución: después (AFTER/FOR) o en lugar de (INSTEAD OF) la acción
{ [ INSERT ] [ , ] [ UPDATE ] [ , ] [ DELETE ] }             -- Eventos DML que activan el trigger: inserción, actualización o eliminación
[ WITH APPEND ]                                              -- Permite agregar otro trigger similar sin reemplazar el anterior
[ NOT FOR REPLICATION ]                                      -- Evita que se ejecute durante operaciones de replicación
AS { sql_statement  [ ; ] [ , ...n ] | EXTERNAL NAME <method_specifier [ ; ] > }  -- Define las instrucciones SQL o método externo que ejecutará el trigger

<dml_trigger_option> ::=                                     -- Opciones adicionales del trigger
    [ ENCRYPTION ]                                           -- Cifra el código fuente del trigger
    [ EXECUTE AS Clause ]                                    -- Define el contexto de seguridad en que se ejecutará

<method_specifier> ::=                                       -- Solo se usa con triggers CLR
    assembly_name.class_name.method_name                     -- Especifica la ensambladura y el método externo a ejecutar


````


## Usos comunes
Los triggers son objetos de base de datos que se ejecutan automáticamente en respuesta a eventos específicos sobre una tabla o vista. Sus usos más frecuentes se dan sobre los eventos **INSERT**, **UPDATE** y **DELETE**, permitiendo intervenir en el momento mismo en que se modifica la información.

Entre los casos de uso más habituales se encuentran:

- Validación automática de datos:
Garantizan que los registros cumplan reglas de integridad adicionales a las restricciones declarativas (CHECK, FK). Por ejemplo, impedir actualizar un pago ya procesado o evitar inserciones inválidas.

- Auditoría de cambios:
Registran automáticamente operaciones sensibles, como quién modificó un registro, cuándo y qué valores fueron alterados.

- Sincronización entre tablas relacionadas:
Actualizan o generan información derivada sin requerir que la aplicación ejecute múltiples operaciones.
Ejemplo: actualizar el estado de una cuota cuando se inserta un pago.

- Ejecución automática de reglas de negocio:
Permiten asegurar cálculos o condiciones que deben cumplirse sin excepción (mora, vigencia de contratos, restricciones internas).

- Prevención de operaciones no permitidas:
Utilizados para bloquear acciones que violarían una regla de negocio.
Por ejemplo, con un trigger INSTEAD OF evitar un DELETE no autorizado.

## Ventajas y desventajas
**Ventajas**

- Automatización completa:
Ejecutan lógica sin depender del código de la aplicación.

- Mayor integridad y consistencia:
Refuerzan reglas de negocio que no pueden garantizarse solo con restricciones estándar.

- Auditoría nativa:
Permiten un registro consistente de operaciones sin cambios en la aplicación.

- Centralización de reglas críticas:
Mantienen la lógica obligatoria dentro del motor de la base de datos.

**Desventajas**

- Dificultad para depurar:
Su ejecución automática puede generar efectos inesperados si no están documentados.

- Impacto en el rendimiento:
Triggers complejos pueden ralentizar operaciones de inserción, actualización o borrado.

- Dependencia del motor de base de datos:
Reducen la portabilidad del sistema hacia otros motores SQL.

- Complejidad en sistemas grandes:
Un uso excesivo puede generar cuellos de botella en entornos concurridos.

## Implementación real y conclusiónes
El análisis realizado permite concluir que los triggers constituyen un mecanismo esencial para reforzar la integridad, seguridad y trazabilidad de los datos en sistemas donde las operaciones poseen impacto económico y administrativo. Su ejecución automática, independiente de la lógica de aplicación, los convierte en una herramienta confiable para garantizar que ningún cambio crítico pase inadvertido.

En el contexto de un sistema de gestión de alquileres, la tabla pago representa uno de los puntos más sensibles del modelo, ya que interviene directamente en el registro histórico de transacciones económicas. El estudio evidencia que el uso de triggers de auditoría permite conservar una copia exacta del estado anterior de un pago ante cualquier modificación, preservando así evidencia objetiva de su evolución temporal. Esto aporta transparencia, facilita el control interno y habilita procesos de verificación posteriores.
Asimismo, el análisis muestra que la incorporación de triggers para evitar eliminaciones físicas contribuye significativamente a la protección del modelo de datos, obligando a que las operaciones sigan las reglas de negocio formales (por ejemplo, el uso de anulaciones o estados lógicos en lugar de borrado definitivo). Este enfoque fortalece la coherencia del sistema y reduce riesgos derivados de manipulaciones indebidas, errores humanos o accesos no autorizados.

En síntesis, los triggers no solo complementan las restricciones, procedimientos y funciones existentes, sino que proporcionan un nivel adicional de seguridad que no puede ser garantizado únicamente desde la aplicación. Su correcta utilización mejora la confiabilidad del sistema, garantiza consistencia histórica y aporta valor en escenarios que requieren auditoría, control y responsabilidad sobre la información registrada.

## Referencias bibliográficas
- Microsoft Learn. (2024). CREATE TRIGGER (Transact-SQL). Recuperado de: https://learn.microsoft.com/en-us/sql/t-sql/statements/create-trigger-transact-sql

- Elmasri, R., & Navathe, S. (2016). Fundamentals of Database Systems (7th ed.). Pearson Education.
