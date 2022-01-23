{{ config(
        materialized='table',
        post_hook= "
          comment on column {{ this }}.close is 'closing price used for all transactions';
          comment on column {{ this }}.adjclose is 'closing price after adjustments for all applicable splits and dividend distributions'"
        ) 
}}

with cte as
        (
          select *,
          row_number() over (partition by symbol,date order by date) num
          from {{ source('zepl_us_stocks_daily', 'stock_history') }}
        )
        select symbol, date, open, high, low, close, volume, adjclose
        from cte
        where num = 1
        order by date
