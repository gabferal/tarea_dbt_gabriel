select
    bank_ispb
from {{ ref('stg_brazil_banks') }}
where length(bank_ispb) != 8