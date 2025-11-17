#  Informe de Resultados y Conclusiones Finales

## 1. Resumen de Pruebas Realizadas

La investigación se centró en optimizar la consulta de un **Reporte de Pagos por Período** sobre la tabla transaccional **`pago`** (con **1,000,000 de registros**) de la base de datos `alquiler_pro`.

La consulta de prueba utilizada fue idéntica en las tres mediciones:

```sql
SELECT P.id_pago, P.fecha_pago, P.monto, C.id_contrato, PE.nombre + ' ' + PE.apellido AS Cliente
FROM pago P 
INNER JOIN contrato_alquiler C ON P.id_contrato = C.id_contrato 
INNER JOIN persona PE ON C.dni = PE.dni
WHERE P.fecha_pago BETWEEN '2023-06-01' AND '2023-06-30';
```
## 2. Comparativa de Métricas de Rendimiento

Los datos demuestran una mejora sustancial en la eficiencia de I/O (Lecturas Lógicas) al aplicar la indexación adecuada. La **Medición 3 (Índice Cubridor)** logró la mínima I/O.

| Escenario | Operación Clave en `pago` | Tiempo Transcurrido (ms) | Lecturas Lógicas (Páginas) | % Reducción de I/O vs. M1 |
| :--- | :--- | :--- | :--- | :--- |
| **1. Sin Índice** (Línea Base) | Clustered Index Scan | 497 | 8404 | N/A |
| **2. Índice Agrupado Simple** | Index Seek (+ Key Lookup) | 68 | 315 | 96.25% |
| **3. Índice Cubridor** | Index Seek Puro | 176 | 131 | 98.44% |

## 3. Conclusiones y Evaluación de la Mejora

### A. Rendimiento vs. Eficiencia de I/O

El tiempo de ejecución bajó dramáticamente de **497 ms a 68 ms** con solo crear el índice agrupado (M2). Sin embargo, la medida más pura de eficiencia es la **Lectura Lógica (I/O)**.

* **Problema de M2:** El plan de la Medición 2, a pesar del rápido tiempo, aún requirió un acceso secundario a la tabla para obtener las columnas (`monto`, `periodo`, etc.), lo que añade costo residual de CPU/I/O (conocido como **Key Lookup**).
* **Solución Óptima (M3):** El **Índice Cubridor (M3)** resolvió este problema al incluir todas las columnas requeridas en el índice. Esto eliminó cualquier búsqueda secundaria, reduciendo las Lecturas Lógicas a solo **131 páginas**, demostrando una **reducción de I/O del 98.44%** con respecto a la línea base.

### B. Criterios de Evaluación Cumplidos

Se demostró que para consultas de lectura críticas en tablas grandes, el diseño óptimo es un **Índice No Agrupado** que utiliza la cláusula `INCLUDE` para crear un índice que "cubre" la consulta completa.

* **Plan de Ejecución:** Se validó el cambio de **Scan** (ineficiente) a **Seek** (eficiente).
* **Mejora de Rendimiento:** Se cuantificó la reducción de tiempo y la maximización de la eficiencia de I/O.

---

## 📸 Evidencia Visual Requerida

Para sustentar la Medición y el Análisis (Criterio de Evaluación), Adjunto las capturas que muestran la evidencia de la investigación aplicada al sistema.:
**(Captura del resultado de cargar 1M de registros.)**


<img width="354" height="67" alt="Captura de pantalla 2025-11-16 145700" src="https://github.com/user-attachments/assets/fc5036dc-80b8-423f-bd10-4f46312df7f1" />


1. **Captura del Plan de Ejecución (Línea Base) Medición 1.**
    * **El Plan de Ejecución del Script 02 (Medición 1).:**
    * **Elemento Clave:** El operador **Clustered Index Scan** (o Table Scan) sobre la tabla `pago`.
  


<img width="1512" height="360" alt="Captura de pantalla 2025-11-16 152016" src="https://github.com/user-attachments/assets/2ff7e7ce-11a5-428a-a467-96d75bb8de21" />

<img width="1461" height="300" alt="Captura de pantalla 2025-11-16 152143" src="https://github.com/user-attachments/assets/cf2a63d7-5e08-40aa-83a2-9b7a1d87c22c" />


2. **Captura del Plan de Ejecución (Punto de Mejora)**
    * **El Plan de Ejecución del Script 04 (Medición 2):** .
    * **Elemento Clave:** El operador **Index Seek** en `IX_CL_Pago_Fecha` (y visualmente el costo que baja del 90% en la sub-rama).
  

<img width="1406" height="537" alt="10" src="https://github.com/user-attachments/assets/a3a79a1b-c77c-4ab5-aabc-d66088050683" />

<img width="971" height="387" alt="9" src="https://github.com/user-attachments/assets/69d85baf-bee3-4956-8288-61629f971037" />


3. **Captura del Plan de Ejecución (Óptimo)**
    * **El Plan de Ejecución del Script 06 (Medición 3):**.
    * **Elemento Clave:** El operador **Index Seek (NonClustered)** en `IX_NC_Pago_Cubridor`, confirmando la ausencia de operadores costosos como **Key Lookup**.
  
<img width="1139" height="368" alt="13" src="https://github.com/user-attachments/assets/e1c093fc-331a-4b7f-9f74-f5171441d7c9" />



4. **Captura de las Estadísticas de Clientes**
    * **La tabla final de Estadísticas de Clientes que compara la Prueba 1 (**497 ms**), la Prueba 5 (**68 ms**) y la Prueba 8 (**176 ms**), y la tabla de Mensajes que muestra las Lecturas Lógicas:**.
  

<img width="1288" height="402" alt="14" src="https://github.com/user-attachments/assets/53be10e9-0e10-48fc-b94f-6cb35d3974c5" />

<img width="799" height="314" alt="12" src="https://github.com/user-attachments/assets/74806ad8-a3c7-4e61-b0d5-9d6b22b198da" />


