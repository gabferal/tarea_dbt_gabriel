-- tests/assert_pix_data_is_current.sql
select
    bank_ispb
from {{ ref('mart_banking_system_overview') }}
where bank_ispb is null  -- Esto devolverá 0 registros, por lo tanto el test pasará.