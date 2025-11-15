# 🚀 Tema: Optimización de Consultas a través de Índices en SQL Server

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

## 🧪 Tareas Prácticas y Evaluación de Impacto

### 1. Preparación de Datos: Carga Masiva

* **Tarea:** Realizar una carga masiva de por lo menos un millón de registro sobre alguna tabla que contenga un campo fecha (sin índice).
* **Script:** `01_creacion_tabla_carga_masiva.sql`
* **Nota:** Se utilizó la tabla `Pruebas_Rendimiento_Indices` para la prueba.

### 2. Medición 1: Sin Índices (Línea Base)

* **Tarea:** Realizar una búsqueda por período y registrar el plan de ejecución y los tiempos de respuesta.
* **Consulta de Prueba:**
    ```sql
    -- Ver script 02_busqueda_sin_indice.sql
    SELECT ID, FechaOperacion, Valor, Descripcion
    FROM Pruebas_Rendimiento_Indices 
    WHERE FechaOperacion BETWEEN '2022-05-01' AND '2022-05-31';
    ```
* **Análisis del Plan de Ejecución:**
    * **Operación clave:** **Table Scan**. Esto ocurre porque el motor de la base de datos no tiene una estructura ordenada (un índice) para buscar eficientemente, por lo que debe leer *cada* fila de la tabla (más de 1 millón) para encontrar las que coinciden con el rango de fechas.
    * **Resultados Obtenidos (Registrar aquí después de ejecutar en SSMS):**
        * **Tiempo transcurrido (Real Time):** [Tiempo X] ms
        * **Lecturas lógicas (Logical Reads):** [Número Y]

---

### 3. Medición 2: Con Índice Agrupado Simple

* **Tarea:** Definir un índice agrupado sobre la columna fecha y repetir la consulta.
* **Scripts:** `03_creacion_indice_agrupado_simple.sql` y `04_busqueda_con_indice_agrupado.sql`
* **Análisis del Plan de Ejecución:**
    * **Operación clave esperada:** **Index Seek** o **Index Scan**. Dado que la tabla ahora está ordenada físicamente por `FechaOperacion`, el motor no necesita escanear toda la tabla (Table Scan). En su lugar, salta directamente al inicio del rango de fechas buscado.
    * **Desventaja:** Aún puede requerir una operación de **Key Lookup** para obtener las columnas que no están en la clave del índice (es decir, `Valor` y `Descripcion`), si es que el optimizador lo considera.
    * **Resultados Obtenidos (Registrar aquí después de ejecutar en SSMS):**
        * **Tiempo transcurrido (Real Time):** [Tiempo Z] ms
        * **Lecturas lógicas (Logical Reads):** [Número W]

---

### 4. Medición 3: Con Índice Agrupado y Columnas Incluidas (Covering Index)

* **Tarea:** Borrar el índice creado. Definir otro índice agrupado sobre la columna fecha pero además incluir las columnas seleccionadas y repetir la consulta.
* **Scripts:** `05_creacion_indice_agrupado_incluido.sql` y `06_busqueda_con_indice_incluido.sql`
* **Análisis del Plan de Ejecución:**
    * **Operación clave esperada:** **Index Seek puro**. Al incluir las columnas `Valor` y `Descripcion` dentro del índice, el motor puede satisfacer la consulta completa *sin* tener que volver a buscar los datos en la tabla principal. Esto elimina el costoso **Key Lookup** y debería mostrar el mejor tiempo de respuesta y el menor número de lecturas lógicas (`Logical Reads`).
    * **Resultados Obtenidos (Registrar aquí después de ejecutar en SSMS):**
        * **Tiempo transcurrido (Real Time):** [Tiempo A] ms
        * **Lecturas lógicas (Logical Reads):** [Número B]
