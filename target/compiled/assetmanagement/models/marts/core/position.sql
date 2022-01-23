
with cte as
          (
              select 
                  t.symbol, exchange, t.date, trader, pm,
                  Sum(num_shares) OVER(partition BY t.symbol, exchange, trader ORDER BY t.date rows UNBOUNDED PRECEDING ) num_shares_cumulative,
                  Sum(cash) OVER(partition BY t.symbol, exchange, trader ORDER BY t.date rows UNBOUNDED PRECEDING ) cash_cumulative,
                  s.close
<<<<<<< HEAD
              from analytics.dbt_awong.trade t
              inner join analytics.dbt_awong.stg_stock_history s on t.symbol = s.symbol and s.date = t.date
=======
              from analytics.dbt_achen.trade t
              inner join analytics.dbt_achen.stg_stock_history s on t.symbol = s.symbol and s.date = t.date
>>>>>>> e3efb5f94c1dd747904eb220cc15e11d79383ac5
          )
          select 
            *,
            num_shares_cumulative * close as market_value, 
            (num_shares_cumulative * close) + cash_cumulative as PnL
          from cte