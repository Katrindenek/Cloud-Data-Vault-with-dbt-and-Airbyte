ARG DBT_VERSION=1.0.0
FROM fishtownanalytics/dbt:${DBT_VERSION}


# Install utilities, yc CLI, and Terraform
RUN apt -y update && apt -y upgrade && \
    apt -y install curl wget gpg unzip && \
    # Install yc CLI
    curl https://storage.yandexcloud.net/yandexcloud-yc/install.sh | bash -s -- -a && \
    # Install Terraform
    curl -sL https://hashicorp-releases.yandexcloud.net/terraform/1.4.6/terraform_1.4.6_linux_amd64.zip -o terraform.zip && \
    unzip terraform.zip && \
    install -o root -g root -m 0755 terraform /usr/local/bin/terraform && \
    rm -rf terraform terraform.zip && \
    # Clean up
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install dbt adapter
RUN set -ex && \
    python -m pip install --upgrade pip setuptools && \
    python -m pip install dbt-postgres==1.5.3 dbt-core==1.5.3

# Set work directory
WORKDIR /usr/app/

# Define environment variables
ENV DBT_PROFILES_DIR=. \
    PATH=$PATH:/root/yandex-cloud/bin

# Keep container running
ENTRYPOINT ["tail", "-f", "/dev/null"]
