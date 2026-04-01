Descripción del Proyecto (Tarea 5):
Se implementó un flujo de transformación de datos (ELT) utilizando Airbyte para la ingesta desde la Brasil API (Bancos y PIX) hacia MotherDuck.

Arquitectura de Modelado:

Capa Staging: Limpieza y normalización de tipos de datos provenientes de JSON anidados.

Capa Intermediate: Resolución de identidad mediante el campo ispb para unir el catálogo bancario con los participantes de PIX.

Capa Mart: Generación de una One Big Table (OBT) para análisis de disponibilidad de servicios financieros.

Nota Técnica: El proyecto utiliza la función {{ source() }} y {{ ref() }} para garantizar el linaje de datos, visible en el DAG adjunto.
***********************************
(Tarea Clase 6)
🛠️ Notas de Implementación y Control de Calidad (Sección: Tests y Validación)
En esta etapa del proyecto, se implementó una robusta capa de observabilidad y validación de datos utilizando dbt-expectations y tests nativos de dbt. A continuación, se detallan los desafíos técnicos encontrados y las soluciones aplicadas:

1. Desafío de Integridad Referencial (ISPB Match)

Durante la ejecución de dbt build, se detectó un fallo masivo (722 registros) en el test de relación entre las fuentes de PIX y Bancos.

Problema: Discrepancia de tipos y formatos (ej. el ISPB 0 interpretado como entero frente al 00000000 como cadena).

Solución: Se aplicó una estandarización agresiva en la capa de Staging utilizando LPAD(TRIM(CAST(ispb AS STRING)), 8, '0'). Esto garantizó que ambos campos fueran comparables como cadenas de 8 caracteres, eliminando errores de unión (joins) y validando la integridad referencial.

2. Tratamiento de Datos Gubernamentales e Institucionales

Se identificó que ciertas instituciones (como el Banco Central do Brasil) o registros específicos de la API carecían de nombres completos (bank_full_name) o presentaban estados inconsistentes.

Ajuste: Se flexibilizaron los tests de not_null en columnas descriptivas no críticas para permitir la ingesta completa de datos de la API de Brasil, priorizando la disponibilidad de la información sobre la rigidez del esquema.

3. Cobertura de Tests Aplicada

Para cumplir con los estándares de calidad, el repositorio cuenta con:

5+ Tests Genéricos: unique y not_null para llaves primarias, y relationships para asegurar que cada registro de PIX pertenezca a un banco válido.

3+ Tests de dbt-expectations: Validación de tipos de datos (expect_column_values_to_be_of_type) y validación de dominios de valores permitidos para estados activos/inactivos.

2 Tests Singulares: * assert_banks_have_ispb_format.sql: Valida que la longitud del identificador sea de 8 caracteres.

assert_pix_data_is_current.sql: Verifica la lógica de negocio sobre la vigencia y activación de las instituciones en el ecosistema PIX.

4. Automatización con dbt build

Todo el linaje de datos, desde la extracción vía Airbyte hasta los modelos finales en MotherDuck, ha sido validado satisfactoriamente. La ejecución de dbt build confirma que tanto las transformaciones como los controles de calidad se ejecutan en un flujo atómico y sin errores.
