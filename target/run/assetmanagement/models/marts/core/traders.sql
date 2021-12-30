

      create or replace transient table finservam.dbt_awong.traders  as
      (
with cte as
      (
          select *,
          row_number() over (partition by trader order by buying_power, PM) num
          from finservam.middleware.temp_trader
      )
      select trader, PM, buying_power
      from cte
      where num = 1
      order by 2,1

      limit 50
      );
    