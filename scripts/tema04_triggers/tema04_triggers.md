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


## Ejemplos prácticos

## Ventajas y desventajas

## Comparación entre motores


## Implementación real

## Referencias bibliográficas
Microsoft Learn. (2024). CREATE TRIGGER (Transact-SQL). Recuperado de: https://learn.microsoft.com/en-us/sql/t-sql/statements/create-trigger-transact-sql

Elmasri, R., & Navathe, S. (2016). Fundamentals of Database Systems (7th ed.). Pearson Education.
