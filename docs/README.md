# Pipeline de Datos — Prueba Técnica Dataknow

Pipeline **end-to-end** para el procesamiento de datos financieros desde archivos crudos hasta tablas analíticas listas para dashboards, utilizando arquitectura **Medallion (Bronze → Silver → Gold)** en **Microsoft Fabric**, con procesamiento en **PySpark** y almacenamiento en **Delta Lake**.

Este repositorio documenta de forma unificada:

- La arquitectura general del proyecto
- Las tablas fuente
- Las capas **Bronze**, **Silver** y **Gold**
- Los notebooks y pipelines asociados
- Las reglas de calidad y validación
- El modelo analítico
- El monitoreo y control de errores
- La estructura de lakehouses
- El flujo de ejecución completo

---

## Tabla de contenido

- [1. Resumen del proyecto](#1-resumen-del-proyecto)
- [2. Arquitectura general](#2-arquitectura-general)
- [3. Tablas fuente](#3-tablas-fuente)
- [4. Componentes del repositorio](#4-componentes-del-repositorio)
- [5. Capa Bronze](#5-capa-bronze)
- [6. Capa Silver](#6-capa-silver)
- [7. Capa Gold](#7-capa-gold)
- [8. Pipelines y notebooks](#8-pipelines-y-notebooks)
- [9. Monitoreo y control de errores](#9-monitoreo-y-control-de-errores)
- [10. Flujo de datos](#10-flujo-de-datos)
- [11. Estructura de lakehouses](#11-estructura-de-lakehouses)
- [12. Datos sintéticos](#12-datos-sintéticos)
- [13. Cómo ejecutar el proyecto](#13-cómo-ejecutar-el-proyecto)
- [14. Tecnologías utilizadas](#14-tecnologías-utilizadas)

---

## 1. Resumen del proyecto

El objetivo de este proyecto es construir un pipeline de datos completo para una entidad financiera ficticia, capaz de:

- Ingerir datos crudos desde archivos fuente
- Conservar trazabilidad de carga
- Aplicar validaciones y controles de calidad
- Estandarizar y limpiar la información
- Detectar anomalías sembradas intencionalmente
- Proteger datos sensibles
- Construir un modelo analítico de negocio
- Publicar tablas listas para dashboards y análisis

La solución está organizada en arquitectura **Medallion**, separando responsabilidades por capa:

- **Bronze**: almacenamiento del dato crudo con auditoría
- **Silver**: limpieza, estandarización, validación y control de calidad
- **Gold**: modelo analítico y métricas de negocio

---

## 2. Arquitectura general

~~~text
Archivos CSV / Parquet / Tablas Fuente
│
▼
┌─────────────────┐
│ BRONZE │
│ Dato crudo │
│ + auditoría │
└────────┬────────┘
│
▼
┌─────────────────┐
│ SILVER │
│ Dato limpio │
│ validado │
│ estandarizado │
└────────┬────────┘
│
▼
┌─────────────────┐
│ GOLD │
│ Modelo de datos │
│ analítico │
│ listo negocio │
└─────────────────┘
~~~

---

## 3. Tablas fuente

Las tablas base del proyecto representan información operativa de una entidad financiera colombiana.

| Tabla fuente | Descripción | Volumen|
|---|---|---:|
| `TB_CLIENTES_CORE` | Información de clientes: nombres, documento, segmento y atributos básicos | 10,000 |
| `TB_PRODUCTOS_CAT` | Catálogo de productos financieros | 50 |
| `TB_MOV_FINANCIEROS` | Transacciones financieras: depósitos, retiros, pagos y otros movimientos | 500,100 |
| `TB_OBLIGACIONES` | Créditos y obligaciones de clientes | 30,000 |
| `TB_SUCURSALES_RED` | Red de sucursales, corresponsales y puntos de atención | 200 |
| `TB_COMISIONES_LOG` | Registro histórico de comisiones cobradas | 80,000 |

---

## 4. Componentes del repositorio

Este repositorio está organizado en cuatro componentes principales:

- **Bronze**
- **Silver**
- **Gold**
- **Pipelines**

Cada uno cumple una función específica dentro del flujo de procesamiento, asegurando trazabilidad, calidad y disponibilidad analítica de la información.

---

## 5. Capa Bronze

### 5.1 Propósito

La capa **Bronze** almacena el **dato crudo** tal como llega desde la fuente.
No aplica transformaciones de negocio ni correcciones.
Su objetivo es conservar el historial original e incorporar trazabilidad de carga.

### 5.2 Notebooks / scripts que la generan

| Archivo | Función |
|---|---|
| `SCRIPT_DATOS_SINTETICOS.ipynb` | Generación de datos sintéticos |
| `ingesta_transformacion_log.ipynb` | Ingesta con trazabilidad |

### 5.3 Qué hace esta capa

- Lee archivos o tablas fuente
- Escribe los datos en formato Delta
- Agrega columnas de auditoría
- Conserva el dato original sin alterarlo
- Permite trazabilidad de origen y lote de carga

### 5.4 Columnas de auditoría

| Columna | Descripción |
|---|---|
| `_ingest_timestamp` | Fecha y hora de la ingesta |
| `_source_file` | Nombre del archivo o fuente origen |
| `_batch_id` | Identificador del lote cargado |

### 5.5 Reglas de Bronze

- No modifica datos de negocio
- No elimina registros
- No corrige anomalías
- No aplica reglas analíticas
- Solo agrega metadatos de auditoría
- Es la capa que preserva la fuente de verdad del dato original

### 5.6 Tablas que genera Bronze

| Tabla Bronze | Fuente | Descripción |
|---|---|---|
| `brz_tb_clientes_core` | `TB_CLIENTES_CORE` | Datos crudos de clientes |
| `brz_tb_productos_cat` | `TB_PRODUCTOS_CAT` | Catálogo de productos crudo |
| `brz_tb_mov_financieros` | `TB_MOV_FINANCIEROS` | Movimientos financieros crudos |
| `brz_tb_obligaciones` | `TB_OBLIGACIONES` | Obligaciones financieras crudas |
| `brz_tb_sucursales_red` | `TB_SUCURSALES_RED` | Red de sucursales cruda |
| `brz_tb_comisiones_log` | `TB_COMISIONES_LOG` | Registro de comisiones crudo |

---

## 6. Capa Silver

### 6.1 Propósito

La capa **Silver** transforma el dato crudo en información **limpia, validada, estandarizada y trazable**.
Aquí se implementan las reglas de calidad de datos, el tratamiento de anomalías, la estandarización de formatos, la validación de integridad y el enmascaramiento de información sensible.

### 6.2 Notebooks / scripts que la generan

| Archivo | Función |
|---|---|
| `TRANSFORMACION_SILVER.ipynb` | Transformación y reglas de calidad Silver |

### 6.3 Qué hace esta capa

- Elimina duplicados
- Elimina registros con nulos críticos
- Valida fechas
- Corrige inconsistencias
- Estandariza tipos de datos y formatos
- Valida integridad referencial
- Trata nulos según estrategia definida
- Enmascara datos sensibles
- Detecta transacciones sospechosas
- Genera tablas limpias y tablas de error
- Publica un reporte de calidad

### 6.4 Tablas de entrada a Silver

| Tabla de entrada |
|---|
| `brz_tb_clientes_core` |
| `brz_tb_productos_cat` |
| `brz_tb_mov_financieros` |
| `brz_tb_obligaciones` |
| `brz_tb_sucursales_red` |
| `brz_tb_comisiones_log` |

### 6.5 Tablas limpias generadas en Silver

| Tabla Silver | Descripción |
|---|---|
| `slv_tb_clientes_core` | Clientes limpios y validados |
| `slv_tb_productos_cat` | Productos limpios |
| `slv_tb_mov_financieros` | Movimientos validados y enriquecidos |
| `slv_tb_obligaciones` | Obligaciones corregidas y estandarizadas |
| `slv_tb_sucursales_red` | Red de sucursales limpia |
| `slv_tb_comisiones_log` | Comisiones limpias |
| `slv_reporte_calidad` | Reporte consolidado de calidad |

### 6.6 Tablas de error generadas en Silver

| Tabla de error | Descripción |
|---|---|
| `err_tb_clientes_core` | Registros rechazados de clientes |
| `err_tb_mov_financieros` | Registros rechazados de movimientos |
| `err_tb_obligaciones` | Registros rechazados de obligaciones |
| `err_tb_comisiones_log` | Registros rechazados de comisiones |

### 6.7 Los 9 pasos de validación y limpieza

| Paso | Validación | Qué hace | Ejemplo |
|---|---|---|---|
| 1 | Duplicados | Elimina registros repetidos por llave primaria | Dos movimientos con el mismo `id_mov` |
| 2 | Nulos críticos | Excluye registros con campos obligatorios vacíos | Movimiento sin `id_cli` |
| 3 | Fechas fuera de rango | Detecta fechas inválidas y las anula, conservando valor original | `1900-01-01` o `2099-12-31` |
| 4 | Inconsistencias | Corrige relaciones ilógicas entre campos | `sdo_capital > vr_desembolsado` |
| 5 | Estandarización | Homologa tipos de datos, texto, formatos y casing | `"credito"` → `"CREDITO"` |
| 6 | Integridad referencial | Valida que las llaves foráneas existan | Cliente inexistente en movimientos |
| 7 | Tratamiento de nulos | Imputa valores o genera flags de nulidad | `depto_res = NULL` |
| 8 | Enmascaramiento PII | Protege datos personales sensibles | Documento con hash, nombres parcialmente ocultos |
| 9 | Anomalías | Marca movimientos sospechosos | `vr_mov > promedio + 3σ` |

### 6.8 Detección de anomalías sembradas

El pipeline detecta las tres anomalías que fueron plantadas en los datos sintéticos para validar el funcionamiento de la capa Silver.

| Anomalía | Descripción | Cómo se detecta |
|---|---|---|
| 1 | Transacciones duplicadas exactas | `row_number()` por llave primaria |
| 2 | Fechas fuera de rango | Validación contra rango permitido |
| 3 | Saldo capital mayor que desembolso | Regla lógica `sdo_capital > vr_desembolsado` |

### 6.9 Estrategia de tratamiento de nulos

| Columna | Estrategia | Valor aplicado |
|---|---|---|
| `depto_res` | Imputación por defecto | `"SIN_DEPARTAMENTO"` |
| `canal_adquis` | Imputación por defecto | `"DESCONOCIDO"` |
| `cod_segmento` | Imputación por defecto | `"B"` |
| `dias_mora_act` | Imputación por defecto | `0` |
| `calif_riesgo` | Imputación por defecto | `"E"` |
| `fec_nac`, `fec_mov`, etc. | Flag binario | `_is_null_* = 1` |
| Campos obligatorios | Exclusión | Envío a tablas `err_*` |

### 6.10 Enmascaramiento de datos sensibles

Para cumplir principios de protección de información, Silver implementa enmascaramiento de PII:

| Campo sensible | Tratamiento |
|---|---|
| `num_doc` | Hash SHA-256 |
| `nomb_cli` | Enmascaramiento parcial |
| `apell_cli` | Enmascaramiento parcial |

Ejemplo:

- `num_doc` → valor hasheado
- `nomb_cli = JUAN` → `J***`

### 6.11 Transacciones sospechosas

La detección del indicador `ind_sospechoso` se realiza en Silver porque la prueba técnica exige que el cálculo ocurra antes de Gold.

#### Lógica aplicada

1. Para cada cliente se calcula el promedio y la desviación estándar de sus últimas 30 transacciones
2. Si `vr_mov > promedio_30d + 3 * stddev_30d`
3. Entonces `ind_sospechoso = True`

### 6.12 Columnas adicionales generadas en Silver

| Columna | Descripción |
|---|---|
| `_flag_*` | Indicadores internos de validación o anomalías |
| `_original_*` | Conserva el valor original previo a corrección |
| `_is_null_*` | Flags de nulidad |
| `ind_sospechoso` | Indicador de transacción sospechosa |
| `prom_movil_30d` | Promedio móvil para transacciones |
| `stddev_30d` | Desviación estándar usada en detección |

### 6.13 Estructura de tablas de error

Cada registro rechazado en Silver incorpora información de auditoría del error:

| Columna | Descripción |
|---|---|
| `_error_tipo` | Categoría del error detectado |
| `_error_motivo` | Descripción legible del problema |
| `_fec_deteccion` | Fecha y hora de detección |

Ejemplos de `_error_tipo`:

- `DUPLICADO`
- `NULO_CAMPO_OBLIGATORIO`
- `FECHA_FUERA_RANGO`
- `FK_INVALIDA`
- `INCONSISTENCIA_NEGOCIO`

---

## 7. Capa Gold

### 7.1 Propósito

La capa **Gold** construye el modelo analítico listo para consumo por negocio, dashboards, reporting y análisis.
Su función es transformar los datos limpios de Silver en dimensiones, hechos, KPIs y tablas de linaje.

### 7.2 Notebooks / scripts que la generan

| Archivo | Función |
|---|---|
| `TRANSFORMACION_GOLD.ipynb` | Construcción del modelo analítico |

### 7.3 Qué hace esta capa

- Crea dimensiones
- Crea hechos
- Calcula métricas y KPIs
- Prepara datos para consumo analítico
- Publica tablas de linaje
- Organiza la información bajo modelo estrella

### 7.4 Tablas de entrada a Gold

| Tabla de entrada |
|---|
| `slv_tb_clientes_core` |
| `slv_tb_productos_cat` |
| `slv_tb_mov_financieros` |
| `slv_tb_obligaciones` |
| `slv_tb_sucursales_red` |
| `slv_tb_comisiones_log` |

### 7.5 Modelo de datos

~~~text
┌───────────────┐
│ dim_clientes │
└──────┬────────┘
│
┌───────────────┐ ┌──────┴────────┐ ┌───────────────┐
│ dim_productos │──▶│ HECHOS │◀──│ dim_geografia │
└───────────────┘ │ │ └───────────────┘
│ fact_transacc. │
┌───────────────┐ │ fact_cartera │ ┌───────────────┐
│ dim_canal │──▶│ fact_rentab. │◀──│ kpi_diario... │
└───────────────┘ └────────────────┘ └───────────────┘
~~~

### 7.6 Tablas generadas en Gold

#### Dimensiones

| Tabla | Descripción |
|---|---|
| `dim_clientes` | Clientes enriquecidos |
| `dim_productos` | Productos agrupados y clasificados |
| `dim_geografia` | Ubicación de oficinas y puntos de atención |
| `dim_canal` | Canal de atención |

#### Hechos

| Tabla | Descripción |
|---|---|
| `fact_transacciones` | Movimientos financieros |
| `fact_cartera` | Información de cartera y mora |
| `fact_rentabilidad_cliente` | Rentabilidad e ingresos por cliente |

#### KPIs y soporte analítico

| Tabla | Descripción |
|---|---|
| `kpi_diario_cartera` | Métricas diarias agregadas |
| `gold_linaje_datos` | Linaje funcional de campos calculados |

### 7.7 Detalle de dimensiones

#### `dim_clientes`

Fuente: `slv_tb_clientes_core`

| Campo | Origen / lógica |
|---|---|
| `nombre_completo` | `nomb_cli + " " + apell_cli` |
| `edad` | Cálculo a partir de `fec_nac` |
| `rango_edad` | Buckets etarios |
| `segmento` | Decodificación de segmento |
| `antiguedad_meses` | Meses desde `fec_alta` |

#### Reglas típicas

- `B` → `BASICO`
- `E` → `ESTANDAR`
- `P` → `PREMIUM`
- `S` → `ELITE`

Buckets sugeridos de edad:

- `18-24`
- `25-34`
- `35-44`
- `45-54`
- `55-64`
- `65+`

---

#### `dim_productos`

Fuente: `slv_tb_productos_cat`

| Campo | Origen / lógica |
|---|---|
| `familia_producto` | Clasificación de `tip_prod` |
| `tasa_mensual_equiv` | `((1 + tasa_ea)^(1/12) - 1) * 100` |

Familias posibles:

- `CREDITO`
- `AHORRO`
- `TRANSACCIONAL`

---

#### `dim_geografia`

Fuente: `slv_tb_sucursales_red`

Contiene atributos de ubicación como:

- Ciudad
- Departamento
- Coordenadas
- Estado de actividad

---

#### `dim_canal`

Fuente: `slv_tb_sucursales_red`

Agrupa información relacionada con el tipo de canal:

- Oficina
- Corresponsal
- ATM
- Canal presencial
- Canal corresponsal
- Otros

### 7.8 Detalle de tablas de hechos

#### `fact_transacciones`

Fuente: `slv_tb_mov_financieros`

| Campo | Lógica | Capa de cálculo |
|---|---|---|
| `vr_mov_usd` | `vr_mov / 4150` | Gold |
| `flag_horario` | Hábil si lunes-viernes entre 06:00 y 18:00 | Gold |
| `ind_sospechoso` | `vr_mov > promedio_30d + 3 * stddev_30d` | Silver |
| `prom_movil_30d` | Promedio móvil de transacciones | Silver |

---

#### `fact_cartera`

Fuente: `slv_tb_obligaciones`

| Campo | Lógica |
|---|---|
| `bucket_mora` | Clasificación por días de mora |
| `clasif_regulatoria` | Calificación regulatoria |
| `provision_estimada` | Porcentaje aplicado al saldo capital |

Clasificación sugerida de `bucket_mora`:

| Días de mora | Bucket |
|---:|---|
| 0 | `AL_DIA` |
| 1-30 | `RANGO_1` |
| 31-60 | `RANGO_2` |
| 61-90 | `RANGO_3` |
| >90 | `DETERIORADO` |

Clasificación regulatoria:

| Días de mora | Clasificación |
|---:|---|
| 0 | `A` |
| 1-30 | `B` |
| 31-60 | `C` |
| 61-90 | `D` |
| >90 | `E` |

Provisión estimada:

| Clasificación | Porcentaje |
|---|---:|
| `A` | 1.0% |
| `B` | 3.2% |
| `C` | 10.0% |
| `D` | 20.0% |
| `E` | 50.0% |

---

#### `fact_rentabilidad_cliente`

Fuente: `slv_tb_comisiones_log` + `slv_tb_obligaciones` + `slv_tb_productos_cat`

| Campo | Lógica |
|---|---|
| `ingresos_comisiones` | Suma mensual de comisiones cobradas |
| `ingresos_intereses` | `sdo_capital * tasa_ea / 12` |
| `ingreso_total` | Comisiones + intereses |
| `cltv_12m` | Suma rolling de 12 meses |

### 7.9 KPI diario de cartera

#### `kpi_diario_cartera`

Fuente: `slv_tb_obligaciones` + `slv_tb_clientes_core` + `slv_tb_productos_cat`

Granularidad sugerida:

- Fecha
- Producto
- Segmento
- Ciudad

| Métrica | Descripción |
|---|---|
| `total_obligaciones` | Cantidad de créditos activos |
| `monto_cartera` | Suma del saldo capital |
| `monto_mora` | Saldo de obligaciones en mora |
| `tasa_mora_pct` | `monto_mora / monto_cartera * 100` |
| `clientes_en_mora` | Clientes distintos con mora |

### 7.10 Linaje de datos

La tabla `gold_linaje_datos` documenta la procedencia y transformación de los campos derivados más importantes.

| Campo destino | Origen | Transformación |
|---|---|---|
| `dim_clientes.edad` | `slv_tb_clientes_core` | Cálculo con diferencia de fechas |
| `fact_transacciones.ind_sospechoso` | `slv_tb_mov_financieros` | Regla estadística de 3 desviaciones |
| `fact_cartera.provision_estimada` | `slv_tb_obligaciones` | Aplicación de porcentaje regulatorio |
| `fact_cartera.bucket_mora` | `slv_tb_obligaciones` | Rango de días de mora |
| `fact_rentabilidad_cliente.cltv_12m` | Varias tablas Silver | Suma rolling de 12 meses |
| `dim_productos.tasa_mensual_equiv` | `slv_tb_productos_cat` | Conversión de tasa EA a mensual |

---

## 8. Pipelines y notebooks

### 8.1 Propósito

La sección **Pipelines** agrupa los procesos que ejecutan el flujo completo desde la generación de datos o la ingesta inicial hasta la publicación del modelo analítico final.

### 8.2 Notebooks / scripts del flujo

| Archivo | Función |
|---|---|
| `SCRIPT_DATOS_SINTETICOS.ipynb` | Versión notebook del generador |
| `ingesta_transformacion_log.ipynb` | Versión notebook Bronze |
| `TRANSFORMACION_SILVER.ipynb` | Versión notebook Silver |
| `TRANSFORMACION_GOLD.ipynb` | Versión notebook Gold |
| `RESUMEN_DIARIO.ipynb` | Resumen diario con las ejecuciones realizadas por el pipeline |

### 8.3 Flujo de ejecución

1. Generación de datos sintéticos
2. Ingesta a Bronze
3. Transformación y calidad en Silver
4. Modelado analítico en Gold

---

## 9. Monitoreo y control de errores

### 9.1 Propósito

Cada cuaderno o script de las capas **Bronze**, **Silver** y **Gold** implementa un mecanismo de control de ejecución para registrar el estado de las tareas del pipeline.

Este control permite:

- Auditar la ejecución
- Identificar fallos
- Registrar el detalle técnico de errores
- Dar trazabilidad operativa por capa

### 9.2 Bitácora de ejecución

Cada capa genera un archivo o tabla de seguimiento denominado:

| Capa | Archivo o tabla de log |
|---|---|
| Bronze | `pipeline_error_log` |
| Silver | `pipeline_error_log` |
| Gold | `pipeline_error_log` |

> El nombre funcional del log es el mismo, pero cada capa lo genera dentro de su propio contexto de procesamiento y almacenamiento.

### 9.3 Estructura del log

| Columna | Descripción |
|---|---|
| `pipeline` | Nombre de la capa o pipeline ejecutado |
| `tarea` | Nombre de la tarea ejecutada |
| `estado` | Resultado de ejecución (`OK` o `ERROR`) |
| `mensaje` | Mensaje descriptivo del resultado |
| `detalle_error` | Detalle técnico del error |
| `timestamp` | Fecha y hora del evento |
| `_fec_registro` | Fecha de registro del log |

### 9.4 Qué permite este control

- Trazabilidad operativa
- Auditoría de ejecución
- Diagnóstico de fallas
- Seguimiento por tarea y capa
- Evidencia histórica de errores

---

## 10. Flujo de datos

~~~text
TB_* / archivos fuente
↓
BRZ_* (Bronze: dato crudo + auditoría)
↓
SLV_* (Silver: validación + limpieza + reglas de calidad)
↓
DIM_* / FACT_* / KPI_* (Gold: modelo analítico)
~~~

---

## 11. Estructura de lakehouses

~~~text
LH_BRONZE_PRUEBA/
└── dbo/
    ├── brz_tb_clientes_core
    ├── brz_tb_productos_cat
    ├── brz_tb_mov_financieros
    ├── brz_tb_obligaciones
    ├── brz_tb_sucursales_red
    ├── brz_tb_comisiones_log
    └── pipeline_error_log

LH_SILVER_PRUEBA/
└── dbo/
    ├── slv_tb_clientes_core
    ├── slv_tb_productos_cat
    ├── slv_tb_mov_financieros
    ├── slv_tb_obligaciones
    ├── slv_tb_sucursales_red
    ├── slv_tb_comisiones_log
    ├── slv_reporte_calidad
    ├── err_tb_clientes_core
    ├── err_tb_mov_financieros
    ├── err_tb_obligaciones
    ├── err_tb_comisiones_log
    └── pipeline_error_log

LH_GOLD_PRUEBA/
└── dbo/
    ├── dim_clientes
    ├── dim_productos
    ├── dim_geografia
    ├── dim_canal
    ├── fact_transacciones
    ├── fact_cartera
    ├── fact_rentabilidad_cliente
    ├── kpi_diario_cartera
    ├── gold_linaje_datos
    ├── pipeline_error_log
    ├── log_ejecuciones_pipeline
    └── reporte_pruebas_calidad
~~~

---

## 12. Datos sintéticos

### 12.1 Generador

El archivo `data_generator.py` o su equivalente en notebook genera seis tablas sintéticas con comportamiento realista de una entidad financiera colombiana.

### 12.2 Qué incluye

- Clientes
- Productos
- Movimientos financieros
- Obligaciones
- Sucursales
- Comisiones

### 12.3 Anomalías plantadas intencionalmente

| Anomalía | Qué se plantó | Cantidad aproximada | Dónde |
|---|---|---:|---|
| 1 | Transacciones duplicadas exactas | ~500 | `TB_MOV_FINANCIEROS` |
| 2 | Fechas fuera de rango | ~500 | Varias tablas |
| 3 | Saldo capital mayor que desembolso | ~500 | `TB_OBLIGACIONES` |

Estas anomalías permiten validar que Silver detecta correctamente:

- Duplicados
- Fechas inválidas
- Inconsistencias de negocio

---

## 13. Cómo ejecutar el proyecto

### 13.1 Orden de ejecución recomendado

1. `SCRIPT_DATOS_SINTETICOS.ipynb`
2. `ingesta_transformacion_log.ipynb`
3. `TRANSFORMACION_SILVER.ipynb`
4. `TRANSFORMACION_GOLD.ipynb`
5. `RESUMEN_DIARIO.ipynb`
6. `PRUEBA_CALIDAD.ipynb`

### 13.2 Flujo operativo

~~~text
1. Generar datos
2. Cargar Bronze
3. Limpiar y validar en Silver
4. Publicar modelo analítico en Gold
~~~

---

## 14. Tecnologías utilizadas

| Tecnología | Uso en el proyecto |
|---|---|
| **Microsoft Fabric** | Plataforma principal de datos |
| **PySpark** | Procesamiento distribuido |
| **Delta Lake** | Almacenamiento transaccional |
| **Arquitectura Medallion** | Organización por capas Bronze, Silver y Gold |
| **Lakehouse** | Persistencia estructurada por entorno |

---

## Conclusión

Este repositorio implementa un pipeline de datos robusto y trazable para una prueba técnica orientada a ingeniería de datos, integrando:

- Ingesta controlada
- Calidad y validación
- Gestión de errores
- Protección de datos sensibles
- Modelado analítico
- Trazabilidad funcional y operativa

La solución está diseñada para demostrar buenas prácticas en:

- Arquitectura de datos
- Calidad de información
- Gobierno del dato
- Modelado analítico
- Observabilidad de pipelines

---
