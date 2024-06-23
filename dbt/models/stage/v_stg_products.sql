{%- set yaml_metadata -%}
source_model:
  raw: 'products'
derived_columns:
  LOAD_DATE: ('{{ run_started_at.strftime("%Y-%m-%d %H:%M:%S") }}')::TIMESTAMP
  RECORD_SOURCE: "'AIRBYTE_SAMPLE_DATA'"
  EFFECTIVE_FROM: 'CREATED_AT'
  BRAND_MODEL: "MAKE || '_' || MODEL"
hashed_columns:
  PRODUCT_HK: 'ID'
  PRODUCT_HASHDIFF:
    is_hashdiff: true
    columns:
      - 'MAKE'
      - 'YEAR'
      - 'MODEL'
      - 'PRICE'
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

