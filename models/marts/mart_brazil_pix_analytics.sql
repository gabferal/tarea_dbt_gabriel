{{ config(materialized='table') }}

WITH base_data AS (
    SELECT
        -- Estandarización de nombres y códigos
        ispb AS bank_id,
        UPPER(nome) AS bank_name,
        COALESCE(nome_reduzido, nome) AS bank_short_name,
        
        -- Transformación de Fechas (Importante para gráficos de línea)
        CAST(inicio_operacao AS DATE) AS fecha_inicio,
        
        -- Mapeo de siglas a nombres legibles para Metabase
        CASE 
            WHEN modalidade_participacao = 'PDCT' THEN 'Privado/Comercial'
            WHEN modalidade_participacao = 'LESP' THEN 'Institución Especial'
            WHEN modalidade_participacao = 'GOVE' THEN 'Gubernamental'
            ELSE 'Otro'
        END AS modalidad_desc,

        CASE 
            WHEN tipo_participacao = 'IDRT' THEN 'Indirecto'
            WHEN tipo_participacao = 'DRCT' THEN 'Directo'
            ELSE 'No definido'
        END AS tipo_participacion_desc,

        -- Flag booleano para filtros rápidos
        CASE 
            WHEN inicio_operacao IS NOT NULL THEN TRUE 
            ELSE FALSE 
        END AS is_pix_active

    FROM brazil_pix -- Ajusta el nombre de tu source según tu schema
)

SELECT 
    *,
    -- Cálculo de antigüedad (meses operando en PIX)
    DATE_DIFF('month', fecha_inicio, CURRENT_DATE) AS meses_en_pix
FROM base_data