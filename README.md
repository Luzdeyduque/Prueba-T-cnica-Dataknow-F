# 📊 Proyecto Fase 1 — Pipeline de Datos Financieros

## 🏦 Sector y Escenario Seleccionado

**Escenario A — Banca y Servicios Financieros**

Se seleccionó este sector debido a la alta complejidad y volumen de datos que manejan las entidades financieras, así como la necesidad crítica de procesar información de forma eficiente para la toma de decisiones en áreas como riesgo crediticio y prevención de fraude.

El escenario plantea un contexto realista de un banco digital con operaciones en múltiples países de Latinoamérica, lo que permite trabajar con datos transaccionales, segmentación de clientes y análisis financiero a gran escala.

---

## ☁️ Plataforma Cloud Seleccionada

**Microsoft Fabric**

Se eligió Microsoft Fabric como plataforma principal debido a que ofrece un ecosistema integral para el manejo de datos en un solo entorno. Esta herramienta permite:

* Ingesta de datos
* Almacenamiento (Lakehouse)
* Transformación de datos
* Análisis y visualización

Todo dentro de una misma plataforma unificada, lo cual reduce la complejidad arquitectónica y mejora la eficiencia en el desarrollo del pipeline de datos.

Además, se utilizó el **SQL Endpoint del Lakehouse**, permitiendo consultar y gestionar los datos de forma estructurada mediante SQL.

---

## 📦 Entregables Fase 1

### 1. Generación de Datos Sintéticos

Se desarrolló un script para la generación de datos dummy con las siguientes características:

* Uso de semilla aleatoria fija para reproducibilidad
* Parámetros configurables
* Generación de múltiples tablas relacionadas

📁 Ubicación del script:

```
/data-generation/SCRIPT_DATOS_SINTETICOS.ipynb
```
---

### 2. Carga de Datos a Base de Datos Relacional

Se implementó un script en SQL/Python para cargar los datos generados en la base de datos relacional dentro del entorno de Microsoft Fabric.

Este proceso asegura:

* Integridad de los datos
* Estructura consistente
* Disponibilidad para consultas analíticas
📁 Ubicación del script:
```
/data-generation/SCRIPT_DATOS_SINTETICOS.ipynb
```
---

### 3. Diagrama Entidad-Relación (ER)

Se diseñó un diagrama ER que representa todas las tablas generadas y sus relaciones.

📁 Ubicación del diagrama:

```
/docs/DIAGRAMA ENTIDAD-RELACIÓN (ER).png
```
![image alt] (https://github.com/Luzdeyduque/Prueba-T-cnica-Dataknow-F/blob/480d41f137f64e9151b7d97544439214ee9950b3/docs/DIAGRAMA%20ENTIDAD-RELACI%C3%93N%20(ER).png)
---

### 4. Evidencia de Carga Exitosa

Se incluye evidencia de la correcta carga de datos mediante:

Esto valida que los datos fueron insertados correctamente en la base de datos.

![image alt](https://github.com/Luzdeyduque/Prueba-T-cnica-Dataknow-F/blob/638d916f416c389b667a637b89999f310774ba87/data-generation/Carga%20Exitosa%20Tablas.png)
---

## 📁 Estructura del Repositorio

```
/data-generation
    └── SCRIPT_DATOS_SINTETICOS.ipynb

/docs
    └── DIAGRAMA ENTIDAD-RELACIÓN (ER).png

README.md
```

---
## 🚀 Entregables Fase 2 — Infraestructura como Código (IaC)

### 📦 1. Código IaC

Se desarrolló la infraestructura como código utilizando Terraform, definiendo de manera declarativa los recursos necesarios para la solución.

Ubicación del código:

```
/infra
```
---

### ☁️ 2. Consideraciones sobre Microsoft Fabric

Para desplegar recursos de Microsoft Fabric mediante Terraform es necesario contar con una **capacidad activa (SKU de pago)**, ya que la versión de prueba no permite este tipo de integraciones.

Debido a esta limitación, **no se realizaron despliegues reales de recursos de Microsoft Fabric**.

Sin embargo, se implementó un **escenario ideal simulado**, en el cual:

- Se definieron los recursos como si el entorno estuviera habilitado  
- Se validó la estructura del código IaC  
- Se ejecutó correctamente el flujo de Terraform  

Esto permite evidenciar cómo sería el aprovisionamiento en un entorno productivo real.

---

### 📸 3. Evidencia de Despliegue

Se adjunta evidencia del despliegue exitoso mediante la ejecución del comando:

```
terraform apply
```

Ubicación de la evidencia:

```
/docs/apply exitoso.png
```
![image alt](https://github.com/Luzdeyduque/Prueba-T-cnica-Dataknow-F/blob/15988dd92d3ca69c5bc461f7642f77d36953bfc6/docs/apply%20exitoso.png)

---

### 🧩 4. Recursos Definidos

El código IaC contempla la definición de los recursos necesarios para soportar la arquitectura de datos, incluyendo:

- Recursos de almacenamiento  
- Componentes de procesamiento  
- Configuración base del entorno  

Cada recurso está definido con:

- Nombre  
- Región  
- Propósito dentro de la solución  

---

### 🔐 5. Manejo de Variables

Se implementó un archivo independiente para la gestión de variables, lo que permite:

- Separación entre configuración y lógica  
- Reutilización del código  
- Mayor seguridad al evitar credenciales expuestas  

---

## 📁 Estructura del Repositorio

```
/infra
├── main.tf
├── variables.tf
├── outputs.tf

/docs
└── apply exitoso.png
```

---


