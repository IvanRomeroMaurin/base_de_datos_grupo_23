# Manejo de Transacciones y Transacciones Anidadas en SQL

## 1. Introducción y Propiedades ACID

### Definición de Transacción

> Una transacción es una unidad única de trabajo. Si una transacción tiene éxito, todas las modificaciones de los datos realizadas durante la transacción se confirman y se convierten en una parte permanente de la base de datos. Si una transacción encuentra errores y debe cancelarse o revertirse, se borran todas las modificaciones de los datos.

En la práctica, esto significa que las transacciones se usan para **agrupar múltiples operaciones** (como `INSERT`, `UPDATE` o `DELETE`) que deben ocurrir juntas para que los datos sigan teniendo sentido. Si un solo paso de ese "paquete" falla, la base de datos deshace automáticamente todos los pasos anteriores.

**Por ejemplo:** Una operacion de transferencia bancaria requiere dos pasos que deben ser tratados como una sola unidad de trabajo:
1.  Restar dinero de la cuenta A.
2.  Sumar dinero a la cuenta B.

Si el paso 1 tiene éxito pero el paso 2 falla, la transacción se revierte (`ROLLBACK`) y el dinero vuelve a la cuenta A. Sin la transacción, el dinero simplemente desaparecería.

### Las Propiedades ACID

Las transacciones se rigen por cuatro propiedades críticas, conocidas por el acrónimo **ACID**, que garantizan la integridad de los datos incluso en caso de errores o fallos del sistema.

* #### Atomicidad (Atomicity) 
    Es el principio de "todo o nada". La transacción se trata como una unidad indivisible. O se completan *todas* las operaciones que la componen, o no se completa *ninguna* (se revierten todos los cambios, como si nunca hubieran ocurrido).

* #### Consistencia (Consistency) 
    Asegura que la base de datos solo puede pasar de un estado válido a otro estado válido. La transacción debe respetar todas las reglas, restricciones (`constraints`) e integridad de los datos definidos. Si una transacción viola alguna de estas reglas, se revierte (`ROLLBACK`) para mantener la consistencia.

* #### Aislamiento (Isolation) 
    Garantiza que las operaciones de una transacción no interfieran con las operaciones de otras transacciones que se están ejecutando al mismo tiempo (concurrentes). Desde la perspectiva de una transacción individual, parece que es la única que se está ejecutando en el sistema, evitando problemas como lecturas sucias o actualizaciones perdidas.

* #### Durabilidad (Durability) 
    Una vez que una transacción ha sido confirmada (`COMMIT`), sus cambios son permanentes y deben sobrevivir a cualquier fallo posterior del sistema (como un corte de energía o un reinicio del servidor). Estos cambios se almacenan de forma persistente, generalmente en un log de transacciones, antes de que el sistema confirme el éxito de la operación.

## 2. Control Básico de Transacciones

Para manejar una transacción, el estándar SQL provee comandos esenciales que actúan como un "interruptor" para la base de datos, definiendo el inicio, el éxito, o el fracaso de la unidad de trabajo.

#### `BEGIN TRANSACTION`
*(O simplemente `BEGIN` en algunos dialectos)*

Marca el punto de inicio de una transacción. Todas las operaciones SQL (como `INSERT`, `UPDATE`, `DELETE`) que se ejecuten después de este comando son consideradas parte de una única unidad de trabajo, a la espera de ser confirmadas o revertidas.

#### `COMMIT`
*(O `COMMIT WORK`)*

Se usa para finalizar con éxito la transacción. Le indica a la base de datos que todas las operaciones dentro de la transacción fueron correctas y que los cambios deben hacerse permanentes. Esto cumple con la propiedad de **Durabilidad (D)** de ACID. Una vez que se ejecuta un `COMMIT`, los cambios no se pueden deshacer (salvo con otra transacción que haga lo contrario).

#### `ROLLBACK`
*(O `ROLLBACK WORK`)*

Se usa para cancelar la transacción, usualiamente cuando ocurre un error o la lógica de negocio lo determina. Revierte *todos* los cambios realizados desde el `BEGIN TRANSACTION`, devolviendo la base de datos a su estado original (al punto de inicio de la transacción). Esto cumple con la propiedad de **Atomicidad (A)** de ACID.

## 3. El Concepto de "Anidamiento" vs. "Savepoints"

### La Necesidad de Rollbacks Parciales
El control básico de transacciones (`BEGIN`, `COMMIT`, `ROLLBACK`) es un modelo de "todo o nada". Pero, ¿qué sucede si una transacción es muy larga y compleja, y solo queremos deshacer una pequeña parte de ella sin cancelar todo el trabajo?

Este es el problema que el "anidamiento" intenta resolver. Un desarrollador intuitivamente quiere crear una "sub-transacción" que pueda fallar y revertirse, sin forzar un `ROLLBACK` de la transacción principal.

### El Mecanismo Estándar: `SAVEPOINT` 🚩
En lugar de un verdadero "anidamiento" de transacciones, el estándar SQL proporciona una solución más controlada: los **Savepoints** (Puntos de Guardado).

Un `SAVEPOINT` es un **marcador** o "punto de control" que se coloca *dentENTRO* de una transacción. Si ocurre un error, en lugar de revertir *toda* la transacción, se puede revertir el trabajo solo hasta ese marcador.

#### `SAVEPOINT nombre_punto`
* Establece un marcador con un nombre específico dentro de la transacción actual. No confirma ni revierte nada; solo guarda la posición.

#### `ROLLBACK TO SAVEPOINT nombre_punto`
* Deshace todas las operaciones y bloqueos de la base de datos que ocurrieron *después* de que se estableció ese `SAVEPOINT`.
* **Punto Crucial:** Esto **no** finaliza la transacción. La transacción principal sigue activa y todos los cambios *anteriores* al `SAVEPOINT` se conservan. El trabajo puede continuar, y al final, la transacción completa (incluyendo los cambios pre-savepoint) debe ser confirmada con un `COMMIT` o revertida por completo con un `ROLLBACK`.