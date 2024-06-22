{%- set yaml_metadata -%}
source_model:
  raw: 'purchases'
derived_columns:
  LOAD_DATE: ('{{ run_started_at.strftime("%Y-%m-%d") }}')::DATE
  RECORD_SOURCE: "'AIRBYTE_SAMPLE_DATA'"
  EFFECTIVE_FROM: 'PURCHASED_AT'
hashed_columns:
  PURCHASE_HK:
    - 'USER_ID'
    - 'PRODUCT_ID'
    - 'PURCHASED_AT'
  USER_HK: 'USER_ID'
  PRODUCT_HK: 'PRODUCT_ID'
  PURCHASE_HASHDIFF:
    is_hashdiff: true
    columns:
      - 'RETURNED_AT'
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{% set source_model = metadata_dict['source_model'] %}

{% set derived_columns = metadata_dict['derived_columns'] %}

{% set hashed_columns = metadata_dict['hashed_columns'] %}


{{ automate_dv.stage(include_source_columns=true,
                  source_model=source_model,
                  derived_columns=derived_columns,
                  hashed_columns=hashed_columns,
                  ranked_columns=none) }}

