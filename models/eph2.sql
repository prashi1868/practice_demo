{{
    config(
        materialized='view'

    )
}}


select * from {{ ref('ephmeral_one')}}