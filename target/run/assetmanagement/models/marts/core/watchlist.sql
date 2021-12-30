

      create or replace transient table finservam.dbt_awong.watchlist  as
      (
select *, 'charles'::varchar(50) Trader
            from finservam.dbt_awong.stg_company_profile
            where symbol in ('AMZN','CAT','COF','GE','GOOG','MCK','MSFT','NFLX','SBUX','TSLA','VOO','XOM')
                union all
            select * from finservam.middleware.temp_watchlist
            order by trader, symbol, exchange
      );
    