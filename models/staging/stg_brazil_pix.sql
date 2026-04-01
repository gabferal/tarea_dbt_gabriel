{{ config(materialized='view') }}

SELECT 
    ispb AS bank_ispb,
    nome AS pix_pax_name,
    nome_reduzido AS pix_short_name,
    tipo_participacao,
    modalidade_participacao,
    inicio_operacao::TIMESTAMP AS inicio_operacion_pix
FROM {{ source('brasil_api', 'brazil_pix') }}