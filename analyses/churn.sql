-- analyses/churn.sql

with journal_entries as (

  select *
  from {{ ref('dim_cartoes') }}

), 

select
  *
from journal_entries