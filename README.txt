Descripción del Proyecto:
Se implementó un flujo de transformación de datos (ELT) utilizando Airbyte para la ingesta desde la Brasil API (Bancos y PIX) hacia MotherDuck.

Arquitectura de Modelado:

Capa Staging: Limpieza y normalización de tipos de datos provenientes de JSON anidados.

Capa Intermediate: Resolución de identidad mediante el campo ispb para unir el catálogo bancario con los participantes de PIX.

Capa Mart: Generación de una One Big Table (OBT) para análisis de disponibilidad de servicios financieros.

Nota Técnica: El proyecto utiliza la función {{ source() }} y {{ ref() }} para garantizar el linaje de datos, visible en el DAG adjunto.
