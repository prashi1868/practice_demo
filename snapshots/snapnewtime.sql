{% snapshot custtm_snapshot %}

{{
    config(
      target_database='loan',
      target_schema='public',
      unique_key='c_id',
      strategy='timestamp',
      updated_at='inserted_dt'
    )
}}

select * from {{ source('dbt_prashi1868', 'cust_src') }}

{% endsnapshot %}