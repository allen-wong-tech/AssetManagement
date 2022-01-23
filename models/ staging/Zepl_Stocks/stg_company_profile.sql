{{ config(
        materialized='table',
        post_hook= "
          comment on table {{ this }} is 'Beta and Market Cap (mktcap) change daily but we will use these static numbers as a proxy for now'"
        ) 
}}

select symbol, exchange, companyname, industry, website, description, ceo, sector, beta, mktcap::number mktcap
        from {{ source('zepl_us_stocks_daily', 'company_profile') }}