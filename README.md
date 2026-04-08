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

![image alt](https://github.com/Luzdeyduque/Prueba-T-cnica-Dataknow-F/blob/fe32759e39c78c586d5aeeef941f3c199a0a3b81/docs/DIAGRAMA%20ENTIDAD-RELACI%C3%93N%20(ER).png)

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
# ⚙️ Entregables Fase 3 — Desarrollo del Pipeline de Datos

---

## 📦 1. Código del Pipeline

El código completo de las tres capas del pipeline (Bronze, Silver y Gold) se encuentra en la carpeta:

```
/pipelines
```

Además, la explicación detallada de cada una de las capas y su funcionamiento está documentada en:

```
/pipelines/README.ipynb
```

---

## 🥉🥈🥇 Notebooks por Capa

### Bronze
```
/pipelines/ingesta_transformacion_log.ipynb
```

### Silver
```
/pipelines/TRANSFORMACION_SILVER.ipynb
```

### Gold
```
/pipelines/TRANSFORMACION_GOLD.ipynb
```

---

## ⚠️ 2. Tablas de Errores del Pipeline

Se implementaron tablas de errores independientes por cada capa del pipeline, permitiendo trazabilidad y control de fallos.

Ubicación de evidencias:

```
/docs/tabla de errores bronze.csv
/docs/tabla de errores silver.csv
/docs/tabla de errores gold.csv
```

Cada tabla contiene al menos un registro de prueba que demuestra el correcto funcionamiento del sistema de logging de errores.

---

## 📊 3. Reporte de Calidad de Datos (Silver)

La capa Silver genera un reporte de calidad de datos que incluye métricas de validación en cada ejecución del pipeline.

Este reporte permite:

- Evaluar la calidad de los datos procesados  
- Identificar errores y anomalías  
- Validar reglas de negocio
Ubicación:

```
/pipelines/REGISTRO_CALIDAD.csv
```
---

## 🧩 4. Tablas/Vistas de Agregación (Gold)

Se desarrollaron al menos tres tablas o vistas de agregación en la capa Gold, documentadas en:

```
/pipelines/LINAJE_DATOS.csv
```

Estas tablas incluyen:

- Definición de campos  
- Origen de los datos  
- Transformaciones aplicadas  

---

## 🧪 5. Pruebas de Calidad de Datos

Se implementaron cinco pruebas de calidad de datos para validar la integridad y consistencia del pipeline.

Ubicación:

```
/pipelines/PRUEBA_CALIDAD.ipynb
```

Estas pruebas incluyen:

- Validación de duplicados  
- Validación de nulos  
- Validación de integridad referencial  
- Validación de rangos de fechas  
- Validación de reglas de negocio  

Cada prueba genera un resultado de:

- ✅ Aprobado  
- ❌ Fallido  

---

## 📁 Estructura Relacionada

```
/pipelines
├── README.ipynb
├── ingesta_transformacion_log.ipynb
├── TRANSFORMACION_SILVER.ipynb
├── TRANSFORMACION_GOLD.ipynb
├── PRUEBA_CALIDAD.ipynb
└── LINAJE_DATOS.csv

/docs
├── tabla de errores bronze.csv
├── tabla de errores silver.csv
└── tabla de errores gold.csv
```
---

# 🔄 Entregables Fase 4 — Orquestación y Monitoreo

---

## 📦 1. Definición del DAG / Pipeline Principal

Se implementó el pipeline principal de orquestación que coordina la ejecución de las capas:

- Bronze  
- Silver  
- Gold  

Ubicación del DAG:

```
/orchestration/MAESTRO_CAPAS.json
```

Este DAG define:

- Orden de ejecución de las tareas  
- Dependencias entre capas  
- Control del flujo end-to-end del pipeline  

---

## ✅ 2. Evidencia de Ejecución Exitosa

Se adjunta evidencia de la ejecución exitosa del pipeline, donde se puede observar el estado de cada tarea del DAG.

Ubicación:

```
/docs/DAG EXITOSO.png
```
![image alt](https://github.com/Luzdeyduque/Prueba-T-cnica-Dataknow-F/blob/18df73845707ce1ca4978b28f01a2f5a6ae98676/docs/DAG%20EXITOSO.png)
---

## ❌ 3. Evidencia de Alerta de Fallo

Se incluye evidencia de una ejecución fallida del pipeline, junto con la notificación recibida.

Ubicación:

```
/docs/Correo_Falla.jpeg
```
![image alt](https://github.com/Luzdeyduque/Prueba-T-cnica-Dataknow-F/blob/fc8d884c26eb98635a100a234855890714841914/docs/Correo_Falla.jpeg)

Esta evidencia demuestra:

- Configuración de alertas  
- Notificación automática ante fallos  
- Capacidad de monitoreo del pipeline  

---

## 📩 4. Evidencia de Reporte Diario de Éxito

Se incluye evidencia del reporte automático de ejecución exitosa del pipeline.

Ubicación:

```
/docs/Resumen_Diario_F.png
```
![image alt](https://github.com/Luzdeyduque/Prueba-T-cnica-Dataknow-F/blob/18df73845707ce1ca4978b28f01a2f5a6ae98676/docs/Resumen_Diario_F.png)

Este reporte contiene:

- Estado general del pipeline  
- Resumen de ejecución  
- Confirmación de éxito  

---

## 📊 5. Monitoreo y Logs de Ejecución

Se dispone de un registro histórico de ejecuciones del pipeline, permitiendo trazabilidad y análisis de comportamiento.

Ubicación:

```
/pipelines/log_ejecuciones_pipeline.csv
```

Este log incluye al menos dos ejecuciones y permite:

- Ver historial de ejecuciones  
- Identificar fallos y éxitos  
- Analizar tiempos y estados  

---

## 📁 Estructura Relacionada

```
/orchestration
└── MAESTRO_CAPAS.json

/docs
├── DAG EXITOSO.png
├── Correo_Falla.jpeg
└── Resumen_Diario_F.png

/pipelines
└── log_ejecuciones_pipeline.csv
```

---
# 🔐 Entregables Fase 5 — Seguridad, Gobierno y Control

---

## 👥 1. Definición de Roles y Control de Acceso

Se definieron tres roles dentro de la solución con diferentes niveles de acceso:

- **Administrador**
- **Miembro**
- **Analista**

📁 Evidencia de configuración:

```
/docs/ROLES_ACCESO.jpeg
```
![image alt](https://github.com/Luzdeyduque/Prueba-T-cnica-Dataknow-F/blob/18df73845707ce1ca4978b28f01a2f5a6ae98676/docs/ROLES_ACCESO.jpeg)


### Roles implementados

- **Administrador (Edison Aguilar)**  
  - Control total sobre recursos  
  - Gestión de permisos  
  - Administración de la plataforma  

- **Miembro (Karol Carranza)**  
  - Acceso al área de trabajo  
  - Interacción con recursos del proyecto  

- **Analista (Simulado)**  
  - Acceso restringido únicamente a capa Gold  
  - Sin acceso a datos técnicos ni capas intermedias  

⚠️ Nota:  
El rol de Analista no pudo configurarse completamente debido a limitaciones de acceso a correos requeridos por la plataforma. Sin embargo, su diseño y permisos fueron definidos correctamente.

---

## 🚫 2. Demostración de Acceso Denegado

Se implementó control de acceso a nivel de tabla mediante el rol `analista`, garantizando el principio de **mínimo privilegio**.

### Permisos otorgados (solo capa Gold)

```sql
GRANT SELECT ON dbo.dim_canal TO analista;
GRANT SELECT ON dbo.dim_clientes TO analista;
GRANT SELECT ON dbo.dim_geografia TO analista;
GRANT SELECT ON dbo.dim_productos TO analista;
GRANT SELECT ON dbo.fact_cartera TO analista;
GRANT SELECT ON dbo.fact_rentabilidad_cliente TO analista;
GRANT SELECT ON dbo.fact_transacciones TO analista;
GRANT SELECT ON dbo.kpi_diario_cartera TO analista;
```

### Accesos denegados (tablas técnicas)

```sql
DENY SELECT ON dbo.pipeline_error_log TO analista;
DENY SELECT ON dbo.reporte_pruebas_calidad TO analista;
```

Esto garantiza que el rol Analista:

- ❌ No accede a Bronze  
- ❌ No accede a Silver  
- ❌ No accede a logs ni tablas técnicas  
- ✅ Solo accede a datos de negocio (Gold)  

⚠️ Nota:  
Debido a limitaciones del SQL Endpoint de Microsoft Fabric, no es posible ejecutar pruebas con múltiples usuarios simultáneamente. Sin embargo, la configuración asegura que en un entorno productivo estos accesos serían correctamente restringidos.

---

---

## 🚨 3. Evidencia de Alertas

Se validó el funcionamiento de tres tipos de alertas:

- Alerta de fallo del pipeline  
- Reporte diario de ejecución exitosa  
- Detección de anomalías de volumen  

Estas evidencias se encuentran documentadas en la carpeta:

```
/docs
```
---

## 📁 Estructura Relacionada

```
/docs
├── ROLES_ACCESO.jpeg
```

---

