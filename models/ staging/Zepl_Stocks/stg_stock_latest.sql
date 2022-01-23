{{ config(
        materialized='table',
        post_hook= "
          comment on table {{ this }} is 'latest available stock prices. We use latest date Starbucks (SBUX) is available'"
        )         
}}

with cte as
        (
          select *,
          row_number() over (partition by symbol order by symbol) num
          from {{ ref('stg_stock_history') }}
          where date = (select max(date) from {{ source('zepl_us_stocks_daily', 'stock_history') }} where symbol = 'SBUX')
        )
        select symbol, date, open, high, low, close, volume, adjclose
        from cte
        where num = 1
        order by symbol