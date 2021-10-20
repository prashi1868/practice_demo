{% snapshot cust_snapshot %}

{{
    config(
      target_database='loan',
      target_schema='dbt_prashi1868',
      unique_key='cust_id',
      strategy='check',
      check_cols=['cust_phn','cust_dob']
    )
}}

select * from {{ ref('cust_detail') }}

{% endsnapshot %}