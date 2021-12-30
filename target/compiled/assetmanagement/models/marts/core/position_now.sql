
select p.*, l.close, l.date,
            num_share_now * close as market_value,
            (num_share_now * close) + cash_now as PnL
        from finservam.dbt_awong.share_now p
        left outer join finservam.dbt_awong.stg_stock_latest l on p.symbol = l.symbol