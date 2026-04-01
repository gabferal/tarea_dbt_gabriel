{{ config(materialized='view') }}

SELECT 
    ispb AS bank_ispb,
    code AS bank_code,
    "name" AS bank_name,
    fullname AS bank_full_name
-- Usa la función source con los nombres exactos de tu sources.yml
FROM {{ source('brasil_api', 'brazil_banks') }}