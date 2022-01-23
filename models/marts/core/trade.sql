{{
  config(
    materialized = 'table',
        post_hook= "
          comment on table {{ this }} is 'Trades made and Cash spend; Unique_key: Trader, symbol, date'"
    )
}}
--buy for all traders except Charles
  select
      c.*,
      round(buying_power/close,0) num_shares, 
      close * round(buying_power/close,0) * -1 cash,
      t.trader, t.PM
  from
  (
    select
        date, h.symbol, w.exchange, 'buy'::varchar(25) action, close
    from {{ ref('stg_stock_history') }} h
    inner join {{ ref('watchlist') }} w on h.symbol = w.symbol and w.trader = 'all_authorized'
    where h.close <> 0 and year(date) between 2010 and 2019
  ) c
  full outer join {{ ref('trader') }} t
union all
--hold for all traders except Charles
  select
      c.*,
      0 num_shares, 
      0 cash,
      t.trader, t.PM
  from
  (
    select
        date, h.symbol, w.exchange, 'hold'::varchar(25) action, close
    from {{ ref('stg_stock_history') }} h
    inner join {{ ref('watchlist') }} w on h.symbol = w.symbol and w.trader = 'all_authorized'
    where h.close <> 0 and year(date) >= 2020
  ) c
  full outer join {{ ref('trader') }} t
union all
  --for Charles buy $100K in value for each ticker in Jan 2019
  select
      date, h.symbol, w.exchange, 'buy'::varchar(25) action, close, round(1000000/close,0) num_shares, 
      close * round(1000000/close,0) * -1 cash,
      'Charles' Trader, 'Warren' PM
  from {{ ref('stg_stock_history') }} h
  inner join {{ ref('watchlist') }} w on h.symbol = w.symbol and w.symbol in ('AMZN','CAT','COF','GE','GOOG','MCK','MSFT','NFLX','SBUX','TSLA','VOO','XOM')
  where h.close <> 0 and year(date) = 2019 and month(date) = 1
union all
  --for Charles sell $10K in value for each ticker in Mar 2019
    select
        date, h.symbol, w.exchange, 'sell' action, close, round(10000/close,0) * -1 num_shares, 
        close * round(10000/close,0) cash,
        'Charles' Trader, 'Warren' PM
    from {{ ref('stg_stock_history') }} h
    inner join {{ ref('watchlist') }} w on h.symbol = w.symbol and w.symbol in ('AMZN','CAT','COF','GE','GOOG','MCK','MSFT','NFLX','SBUX','TSLA','VOO','XOM')
    where h.close <> 0 and year(date) = 2019 and month(date) = 3
union all
  --for Charles hold action so shares and cash don't change
  select
      date, h.symbol, w.exchange, 'hold' action, close, 0, 0 cash,
      'Charles' Trader, 'Warren' PM
  from {{ ref('stg_stock_history') }} h
  inner join {{ ref('watchlist') }} w on h.symbol = w.symbol and w.symbol in ('AMZN','CAT','COF','GE','GOOG','MCK','MSFT','NFLX','SBUX','TSLA','VOO','XOM')
  where (h.close <> 0 and year(date) = 2019 and month(date) not in (1,3)) or (h.close <> 0 and year(date) >= 2020)
order by 8,2,1--Trader, symbol, date