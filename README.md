# Cloud Data Vault with dbt and Airbyte




export POSTGRES_HOST=$(terraform output -raw postgresql_host)
export DBT_HOST=${POSTGRES_HOST}
export DBT_DBNAME=$(terraform output -raw postgresql_dbname)
export POSTGRES_USER=$(terraform output -raw postgresql_user)
export DBT_USER=${POSTGRES_USER}
export DBT_PASSWORD=${TF_VAR_postgresql_password}