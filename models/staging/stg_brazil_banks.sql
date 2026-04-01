{{ config(materialized='view') }}

SELECT 
    -- Aplicamos el mismo formato de 8 dígitos que en PIX
    LPAD(TRIM(CAST(ispb AS STRING)), 8, '0') AS bank_ispb,
    TRY_CAST(code AS INTEGER) AS bank_code,
    "name" AS bank_name,
    fullname AS bank_full_name
FROM {{ source('brasil_api', 'brazil_banks') }}