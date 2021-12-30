

      create or replace transient table finservam.dbt_awong.stg_stock_latest  as
      (
with cte as
        (
          select *,
          row_number() over (partition by symbol order by symbol) num
          from finservam.dbt_awong.stg_stock_history
          where date = (select max(date) from zepl_us_stocks_daily.public.stock_history where symbol = 'SBUX')
        )
        select symbol, date, open, high, low, close, volume, adjclose
        from cte
        where num = 1
        order by symbol
      );
    