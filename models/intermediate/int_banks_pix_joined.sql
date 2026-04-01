{{ config(materialized='view') }}

SELECT 
    b.bank_ispb,
    b.bank_code,
    b.bank_full_name,
    p.pix_short_name,
    p.modalidade_participacao,
    -- Identificamos si el banco es un participante activo en PIX
    CASE 
        WHEN p.bank_ispb IS NOT NULL THEN TRUE 
        ELSE FALSE 
    END AS is_pix_active
FROM {{ ref('stg_brazil_banks') }} b
LEFT JOIN {{ ref('stg_brazil_pix') }} p ON b.bank_ispb = p.bank_ispb