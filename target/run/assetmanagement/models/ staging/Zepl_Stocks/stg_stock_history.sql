

      create or replace transient table finservam.dbt_awong.stg_stock_history  as
      (


with cte as
        (
          select *,
          row_number() over (partition by symbol,date order by date) num
          from zepl_us_stocks_daily.public.stock_history
        )
        select symbol, date, open, high, low, close, volume, adjclose
        from cte
        where num = 1
        order by date
      );
    