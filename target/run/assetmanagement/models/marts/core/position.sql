
  create or replace  view finservam.dbt_awong.position 
  
   as (
    
with cte as
          (
              select 
                  t.symbol, exchange, t.date, trader, pm,
                  Sum(num_shares) OVER(partition BY t.symbol, exchange, trader ORDER BY t.date rows UNBOUNDED PRECEDING ) num_shares_cumulative,
                  Sum(cash) OVER(partition BY t.symbol, exchange, trader ORDER BY t.date rows UNBOUNDED PRECEDING ) cash_cumulative,
                  s.close
              from finservam.dbt_awong.trade t
              inner join finservam.dbt_awong.stg_stock_history s on t.symbol = s.symbol and s.date = t.date
          )
          select 
            *,
            num_shares_cumulative * close as market_value, 
            (num_shares_cumulative * close) + cash_cumulative as PnL
          from cte
  );
