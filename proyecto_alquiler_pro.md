# Proyecto de Estudio!

*Estructura del documento principal:*

# PRESENTACIÓN (Sistema de  Gestión de Alquileres “Alquiler  Pro”)

*Universidad*: Universidad Nacional del Nordeste  
*Facultad*: Facultad de Ciencias Exactas y Naturales y Agrimensura  
*Carrera*: Licenciatura en Sistemas de Información  
*Asignatura*: Base de Datos I  
*Año Lectivo*: 2025

*Sistema*: Sistema de  Gestión de Alquileres “Alquiler  Pro”

*Grupo N°*: 23

*Integrantes*:
 - Gauto Ivan Guillermo
 - Garavaglia Miguel Gustavo
 - Quintana Fabian Gustavo
 - Romero Maurin Ivan

---

## CAPÍTULO I: INTRODUCCIÓN

### Caso de estudio

**Tema — Automatización de la Gestión de Alquileres, Contratos y Pagos en Empresas Inmobiliarias**

En el ámbito inmobiliario, el alquiler de propiedades es uno de los procesos más frecuentes y al mismo tiempo más complejos de gestionar. No solo implica el registro de inmuebles disponibles y ocupados, sino también el seguimiento de contratos, cuotas, clientes, pagos y métodos de pago.

Este trabajo se centra en el diseño de una **base de datos** para un sistema llamado **“Alquiler Pro”** orientado a digitalizar y automatizar la información necesaria para gestionar de manera eficiente todo el ciclo de vida de un contrato de alquiler.

### Definición o planteamiento del problema

La gestión tradicional de alquileres en empresas inmobiliarias pequeñas o medianas que no cuentan con un sistema automatizado suele presentar múltiples dificultades que impactan directamente en la eficiencia y en la relación con los clientes. El uso de planillas de Excel sueltas, carpetas físicas o registros dispersos genera procesos manuales lentos e ineficientes en tareas repetitivas como registrar pagos, verificar deudas o generar recibos. A esto se suman los errores frecuentes en los datos, como la duplicación de clientes, inconsistencias en teléfonos o correos, la omisión de pagos o contratos vencidos sin el debido seguimiento.

La falta de control también es un problema habitual, ya que se pierde visibilidad sobre el estado de los inmuebles (si están disponibles, alquilados o en reparación) y resulta difícil relacionar cada propiedad con su propietario, inquilino y contrato vigente. Asimismo, el control de pagos se ve afectado, con complicaciones para controlar cuotas vencidas/pagadas y dificultades para emitir comprobantes claros y confiables.

En resumen, la ausencia de un sistema unificado y confiable genera costos adicionales en tiempo, reduce la productividad de los empleados y debilita la relación con los clientes, ya que no se les puede brindar información rápida y precisa sobre sus contratos o pagos. Frente a esto surge la necesidad de desarrollar una **base de datos** para un sistema informático que integre todas las áreas críticas (clientes, inmuebles, contratos, cuotas y pagos) para garantizar una gestión ordenada, segura y eficiente.

### Objetivo del Trabajo Práctico

El propósito de este trabajo es **diseñar y documentar una base de datos** que funcione como el núcleo del sistema “Alquiler Pro”, asegurando la correcta representación de los procesos de negocio de una empresa inmobiliaria y sentando las bases para un sistema robusto de gestión de alquileres.

### Preguntas Generales

- ¿Cómo podemos automatizar y optimizar la gestión de alquileres teniendo en cuenta el registro de inquilinos, inmuebles, contratos y llevar un control sobre los pagos de cada contrato?

### Preguntas Específicas

- ¿Cómo diseñar un modelo de base de datos que garantice la integridad de los datos en un sistema de alquileres?
- ¿De qué manera se puede controlar la disponibilidad de un inmueble y evitar que se alquile dos veces en paralelo?
- ¿Qué estructura permite vincular de forma eficiente a clientes con distintos roles (propietario e inquilino)?
- ¿Cómo asegurar la trazabilidad de pagos, desde la generación de cuotas hasta la emisión de recibos?

### Objetivos Generales

Implementar un modelo de base de datos que permita **automatizar y optimizar** la gestión de contratos de alquiler, inmuebles, clientes y pagos, **garantizando la integridad** de la información y reduciendo la posibilidad de errores.

### Objetivos Específicos

- Administrar **contratos de alquiler** detallando fecha de inicio, vencimiento, condiciones, monto y cuotas correspondientes.
- Registrar **pagos** asociados a cuotas y contratos, vinculando cada transacción con un **método de pago** y un **recibo**.
- Emitir **comprobantes y recibos** que respalden las operaciones, garantizando la **trazabilidad** de los pagos.
- Registrar de manera **centralizada** la información de **clientes** (propietarios, inquilinos y usuarios del sistema), evitando duplicados y asegurando datos de contacto válidos.

### Descripción del Sistema

El sistema está diseñado para **empresas inmobiliarias** que administran inmuebles en la provincia de Corrientes, con la posibilidad de gestionar propiedades tanto en la capital como en localidades del interior. Su propósito es brindar una solución integral para registrar, organizar y controlar toda la información relacionada con **clientes, inmuebles, contratos de alquiler, pagos y cuotas**, centralizando los datos y eliminando la dependencia de procesos manuales.

**Módulos principales:**
- **Gestión de clientes y roles:** registro de personas y asignación de roles específicos (propietarios, inquilinos o usuarios internos).
- **Gestión de inmuebles:** administración del inventario de propiedades; estado, disponibilidad y ubicación (provincia, ciudad, dirección).
- **Contratos de alquiler:** registro y gestión de contratos vigentes; fechas, condiciones, cuotas e inmuebles asociados.
- **Pagos y recibos:** registro de pagos de cuotas; métodos de pago y generación de comprobantes.
- **Gestión de usuarios y seguridad:** perfiles de acceso y permisos.

**Roles principales:**
- **Administrador del sistema:** mantenimiento general, seguridad de datos y creación de usuarios.
- **Gerente inmobiliario:** administración completa de clientes, contratos, inmuebles e informes.
- **Operador/administrativo:** registro diario de contratos, pagos y emisión de recibos.

Gracias a esta estructura modular, cada perfil trabaja sobre la información que necesita, asegurando **eficiencia** y **minimizando errores**.

### Alcance

El alcance del presente análisis se centra en la **gestión centralizada de los procesos de alquileres**. Específicamente, se abordan:

- Gestión de **usuarios y roles** (administrador, gerente, operador).
- Gestión de **clientes y roles** (propietario, inquilino).
- Administración de **inmuebles** (ubicación, tipo y estado de disponibilidad).
- **Creación y control** de contratos de alquiler.
- **Generación de cuotas** asociadas a contratos.
- **Registro de pagos** realizados por los inquilinos, vinculados a recibos y métodos de pago.

**No se consideran** dentro del alcance:
- Conexión con **organismos fiscales** o sistemas externos de **facturación electrónica**.
- Funcionalidades avanzadas de **análisis de mercado** o **predicción de demanda**.
- **Gestión jurídica y legalidad** de un contrato real (la validez legal corresponde a un escribano/profesional habilitado).

> En el contexto del sistema, se utiliza el término **“contrato”** para referirse a la **relación** que se establece en la base de datos entre el **inquilino**, el **inmueble** y el **propietario**, junto con las condiciones y cuotas acordadas.

---

## CAPITULO II: MARCO CONCEPTUAL O REFERENCIAL

* Tema 1: ---
* Tema 2: ---
* Tema 3: ---
* Tema 4: ---

## CAPÍTULO III: METODOLOGÍA SEGUIDA

---

## CAPÍTULO IV: DESARROLLO DEL TEMA
En este capítulo se presentan en detalle los datos e información que se recopilaron y organizaron para el diseño del sistema **Alquiler Pro**, cuyo objetivo es optimizar la gestión de inmuebles, contratos, clientes y pagos en una empresa inmobiliaria.  
Se emplearon diversas herramientas y metodologías para lograr el diseño y la administración de la base de datos. Entre ellas, se destacan los **Diagramas Entidad–Relación (DER)**, que permitieron representar de manera gráfica y clara las entidades, atributos y relaciones que conforman el sistema. Gracias a esta representación visual, fue posible identificar la estructura de los datos, su comportamiento y las restricciones de integridad necesarias para asegurar la consistencia de la información.

### Diagrama de Modelo Relacional
El **Diagrama de Modelo Relacional**, también conocido como Diagrama Entidad–Relación (ER), es una representación gráfica que muestra la estructura lógica de la base de datos, destacando las entidades que la componen, sus atributos principales y las relaciones que existen entre ellas.  
A continuación, se presenta el **Modelo Relacional del sistema Alquiler Pro**, el cual refleja las entidades definidas y sus interrelaciones en el dominio de la gestión de alquileres.

![diagrama_relacional](docs/Modelo_relacional.png)

Desarrollo TEMA 1 "Procedimientos y funciones almacenadas"

> Acceder a la siguiente carpeta para la descripción completa del tema [scripts-> Tema01_procedimientos_funciones_almacenadas](scripts/Tema01_procedimientos_funciones_almacenadas/tema01_procedimientos_funciones_almacenadas.md)

Desarrollo TEMA 2 "Optimización de consultas a través de índices"

> Acceder a la siguiente carpeta para la descripción completa del tema [scripts-> tema02_optimización_de_consultas_a_través_de_índices](scripts/tema02_optimización_de_consultas_a_través_de_índices/tema02_optimizacion_indices.md)

Desarrollo TEMA 3 "Manejo de Transacciones"

> Acceder a la siguiente carpeta para la descripción completa del tema [scripts-> tema03_transacciones](scripts/tema03_transacciones/tema03_transacciones.md)

Desarrollo TEMA 4 "Triggers (Disparadores)"

> Acceder a la siguiente carpeta para la descripción completa del tema [scripts-> tema04_triggers](scripts/tema04_triggers/tema04_triggers.md)

## CAPÍTULO V: CONCLUSIONES

...


## BIBLIOGRAFÍA DE CONSULTA

 1. List item
 2. List item
 3. List item
 4. List item
 5. List item
