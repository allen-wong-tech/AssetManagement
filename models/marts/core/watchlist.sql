{{
  config(
    materialized = 'table',
    post_hook= "
          comment on table {{ this }} is 'what assets we are interested in owning'
          "
    )
}}
select c.*, 'all_authorized' Trader
from {{ ref('stg_company_profile') }} c
inner join {{ ref('stg_stock_latest') }} l on c.symbol = l.symbol     --ensure stock still traded 
where mktcap is not null
and exchange like 'N%'
and c.symbol not in 
(
    select distinct symbol
    from {{ ref('stg_stock_history') }}
    where close < 1 or close > 4500
)
and c.symbol not in ('AMZN','CAT','COF','GE','GOOG','MCK','MSFT','NFLX','SBUX','TSLA','VOO','XOM')  //we will add these in via the union all

union all

select *, 'all_authorized'::varchar(50) Trader
from {{ ref('stg_company_profile') }}
where symbol in ('AMZN','CAT','COF','GE','GOOG','MCK','MSFT','NFLX','SBUX','TSLA','VOO','XOM')

order by mktcap desc
limit 1000