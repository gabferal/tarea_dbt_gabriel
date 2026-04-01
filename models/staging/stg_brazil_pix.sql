{{ config(materialized='view') }}

SELECT 
    LPAD(TRIM(CAST(ispb AS STRING)), 8, '0') AS bank_ispb,
    nome AS pix_pax_name,
    nome_reduzido AS pix_short_name,
    tipo_participacao,
    modalidade_participacao,
    inicio_operacao::TIMESTAMP AS inicio_operacion_pix
FROM {{ source('brasil_api', 'brazil_pix') }}
-- ESTA ES LA CLAVE: Solo traemos los que existen en la tabla de bancos
WHERE LPAD(TRIM(CAST(ispb AS STRING)), 8, '0') IN (
    SELECT LPAD(TRIM(CAST(ispb AS STRING)), 8, '0') 
    FROM {{ source('brasil_api', 'brazil_banks') }}
)