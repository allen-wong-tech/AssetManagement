

      create or replace transient table finservam.dbt_awong.stg_company_profile  as
      (

select symbol, exchange, companyname, industry, website, description, ceo, sector, beta, mktcap::number mktcap
        from zepl_us_stocks_daily.public.company_profile
      );
    