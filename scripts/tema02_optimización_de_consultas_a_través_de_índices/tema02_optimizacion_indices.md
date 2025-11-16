# Tema: Optimización de Consultas a través de Índices en SQL Server

## 🎯 Objetivos de Aprendizaje
* Conocer los tipos de índices y sus aplicaciones.
* Evaluar el impacto de los índices en el rendimiento de las consultas.

---

## 💡 Introducción: Definición y Propiedades

Un **índice** en SQL Server es una estructura de disco asociada a una tabla o vista que está diseñada para mejorar la velocidad de recuperación de datos. Actúa de manera análoga al índice de un libro de texto: en lugar de hojear página por página, el motor de la base de datos utiliza el índice para localizar rápidamente las filas de datos deseadas.

### 📜 Impacto de los Índices
Si bien los índices aceleran las operaciones de lectura (`SELECT`), tienen un costo:

* **Mayor consumo de espacio en disco:** Cada índice, especialmente los no agrupados, requiere almacenamiento adicional.
* **Impacto en la escritura:** Las operaciones de modificación de datos (`INSERT`, `UPDATE`, `DELETE`) se vuelven más lentas, ya que el motor debe mantener la tabla principal **y** todos sus índices asociados actualizados.

---

## 📑 Tipos de Índices y sus Aplicaciones en SQL Server

SQL Server soporta varios tipos de índices, siendo los más fundamentales los **Agrupados** y los **No Agrupados**.

### 1. Índices Agrupados (Clustered Index)

El índice agrupado determina el **orden físico** en el que se almacenan las filas de datos en el disco.

| Característica | Descripción |
| :--- | :--- |
| **Almacenamiento** | La estructura de datos del índice es la tabla misma. Los datos están ordenados físicamente en la base de datos según la clave del índice. |
| **Cantidad** | Una tabla solo puede tener **un** índice agrupado, ya que solo puede estar ordenada físicamente de una única manera. |
| **Uso Ideal** | Se utiliza mejor en columnas que contienen datos de identificación únicos, son accedidas con frecuencia, o se usan en cláusulas `ORDER BY`, `GROUP BY`, o rangos (`WHERE Columna BETWEEN X AND Y`). |
| **Base de Datos** | Una tabla sin un índice agrupado se denomina **Heap**. |

### 2. Índices No Agrupados (Non-Clustered Index)

El índice no agrupado es una estructura separada de la tabla de datos principal.

| Característica | Descripción |
| :--- | :--- |
| **Almacenamiento** | El índice contiene las claves del índice y punteros (marcadores de fila o clave agrupada) a la ubicación real de los datos en la tabla. |
| **Cantidad** | Una tabla puede tener hasta 999 índices no agrupados. |
| **Uso Ideal** | Ideal para columnas utilizadas frecuentemente en búsquedas (`WHERE` y `JOIN`) donde la tabla base ya tiene un índice agrupado en otra columna. |

### 3. Índices con Columnas Incluidas (Included Columns)

Una técnica de optimización muy importante para los índices **no agrupados**.

* Permite añadir columnas que **no forman parte de la clave** del índice, pero que son parte de la lista de columnas seleccionadas (`SELECT ColumnaA, ColumnaB...`).
* Esto crea un **índice de cobertura** (Covering Index), que significa que el motor de la base de datos puede obtener **todos** los datos necesarios directamente del índice sin tener que acceder a la tabla principal.
* **Ventaja:** Reduce las operaciones de "Búsqueda de Clave" (Key Lookup), que son costosas en el rendimiento.

---

## 📊 La Herramienta Crucial: Planes de Ejecución

Para evaluar el impacto de los índices, es fundamental entender los **Planes de Ejecución** de SQL Server.

| Concepto | Descripción |
| :--- | :--- |
| **Plan de Ejecución** | Es la "receta" o el conjunto de pasos que el motor de SQL Server elige para ejecutar una consulta. |
| **Table Scan** | El motor tiene que leer **todas** las filas de la tabla para encontrar los datos, independientemente de la cláusula `WHERE`. **Es la operación más costosa.** |
| **Index Scan** | El motor tiene que leer **todas** las filas del índice (que son menos que la tabla completa). Más rápido que un Table Scan, pero sigue siendo costoso. |
| **Index Seek** | El motor salta directamente a la parte del índice que contiene los datos solicitados. **Es la operación más deseada para el rendimiento.** |

---

##  Tareas Prácticas y Evaluación de Impacto

### 1. Preparación de Datos: Carga Masiva

* **Tarea:** Realizar una carga masiva de por lo menos un millón de registro sobre alguna tabla que contenga un campo fecha (sin índice).
* **Script:** `01_creacion_tabla_carga_masiva.sql`
* **Nota:** Se utilizó la tabla **`pago`** del esquema **`alquiler_pro`** para la prueba.

### 2. Medición 1: Sin Índices (Línea Base)

* **Tarea:** Realizar una búsqueda por período y registrar el plan de ejecución y los tiempos de respuesta.
* **Consulta de Prueba:**
    ```sql
    -- Ver script 02_busqueda_sin_indice.sql
    SELECT P.id_pago, P.fecha_pago, P.monto, P.periodo, C.id_contrato, PE.nombre + ' ' + PE.apellido AS Cliente
    FROM pago P INNER JOIN contrato_alquiler C ON P.id_contrato = C.id_contrato INNER JOIN persona PE ON C.dni = PE.dni
    WHERE P.fecha_pago BETWEEN '2023-06-01' AND '2023-06-30';
    ```
* **Análisis del Plan de Ejecución:**
    * **Operación clave:** **Clustered Index Scan** sobre la `PK_pago`. El motor debe escanear el millón de filas en el orden de la clave primaria, ya que no hay un índice optimizado para la columna `fecha_pago`.
    * **Resultados Obtenidos (Registrar aquí después de ejecutar en SSMS):**
        * **Tiempo transcurrido (Real Time):** **497 ms**
        * **Lecturas lógicas (Logical Reads):** **8404** (Valor usado como línea base de I/O)

---

### 3. Medición 2: Con Índice Agrupado Simple

* **Tarea:** Definir un índice agrupado sobre la columna fecha y repetir la consulta.
* **Scripts:** `03_creacion_indice_agrupado_simple.sql` y `04_busqueda_con_indice_agrupado.sql`
* **Análisis del Plan de Ejecución:**
    * **Operación clave esperada:** **Index Seek** en `IX_CL_Pago_Fecha`. La tabla se ordena físicamente por fecha.
    * **Desventaja (Observada):** Aunque la búsqueda es rápida, el plan implícitamente incluye la necesidad de acceder a las columnas (`monto`, `periodo`, etc.) que no están en la clave del índice, lo que agrega I/O y CPU.
    * **Resultados Obtenidos (Registrar aquí después de ejecutar en SSMS):**
        * **Tiempo transcurrido (Real Time):** **68 ms** (Reducción dramática del 86.3% respecto a la Medición 1)
        * **Lecturas lógicas (Logical Reads):** **315**

---

### 4. Medición 3: Con Índice Cubridor (Covering Index)

* **Tarea:** Borrar el índice creado. Definir un Índice No Agrupado sobre la columna fecha pero además incluir las columnas seleccionadas y repetir la consulta.
* **Scripts:** `05_creacion_indice_incluido.sql` y `06_busqueda_con_indice_incluido.sql`
* **Análisis del Plan de Ejecución:**
    * **Operación clave esperada:** **Index Seek Puro** en el índice `IX_NC_Pago_Cubridor`. Este índice contiene todos los campos requeridos por el `SELECT`.
    * **Resultado Clave:** La eliminación completa del **Key Lookup** y cualquier búsqueda residual en la tabla `pago`.
    * **Resultados Obtenidos (Registrar aquí después de ejecutar en SSMS):**
        * **Tiempo transcurrido (Real Time):** **176 ms**
        * **Lecturas lógicas (Logical Reads):** **131** (El valor más bajo, indicando la mínima I/O necesaria).

---
