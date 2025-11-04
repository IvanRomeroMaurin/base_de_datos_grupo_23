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