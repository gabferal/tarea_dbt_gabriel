{{ config(materialized='table') }}

SELECT 
    bank_ispb,
    bank_full_name,
    pix_short_name,
    modalidade_participacao,
    is_pix_active
FROM {{ ref('int_banks_pix_joined') }}
ORDER BY bank_full_name ASC