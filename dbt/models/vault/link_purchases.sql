{%- set yaml_metadata -%}
source_model: 'v_stg_purchases'
src_pk: 'PURCHASE_HK'
src_fk: 
    - 'USER_HK'
    - 'PRODUCT_HK'
src_payload:
    - 'PURCHASED_AT'
    - 'ADDED_TO_CART_AT'
    - 'RETURNED_AT'
src_eff: 'EFFECTIVE_FROM'
src_ldts: 'LOAD_DATE'
src_source: 'RECORD_SOURCE'
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ automate_dv.t_link(src_pk=metadata_dict["src_pk"],
                      src_fk=metadata_dict["src_fk"],
                      src_payload=metadata_dict["src_payload"],
                      src_eff=metadata_dict["src_eff"],
                      src_ldts=metadata_dict["src_ldts"],
                      src_source=metadata_dict["src_source"],
                      source_model=metadata_dict["source_model"]) }}
