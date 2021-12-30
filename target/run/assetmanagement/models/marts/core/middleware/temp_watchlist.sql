

      create or replace transient table finservam.middleware.temp_watchlist  as
      (
select c.*, 'all_authorized' Trader
            from finservam.dbt_awong.stg_company_profile c
            inner join finservam.dbt_awong.stg_stock_latest l on c.symbol = l.symbol     --ensure stock still traded 
            where mktcap is not null
            and exchange like 'N%'
            and c.symbol not in 
            (
                select distinct symbol
                from finservam.dbt_awong.stg_stock_history
                where close < 1 or close > 4500
            )
            order by mktcap desc
      );
    