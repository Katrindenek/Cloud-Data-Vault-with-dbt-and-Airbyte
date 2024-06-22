terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  # Добавьте конфигурацию аутентификации, если необходимо
}

resource "yandex_vpc_network" "default_network" {}

resource "yandex_vpc_subnet" "default_subnet" {
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.default_network.id
  v4_cidr_blocks = ["10.5.0.0/24"]
}

// Create SA
resource "yandex_iam_service_account" "sa" {
  folder_id = var.folder_id
  name      = "airbyte-storage"
}

// Grant permissions
resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
  folder_id = var.folder_id
  role      = "storage.editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

// Create Static Access Keys
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa.id
  description        = "static access key for object storage"
}

resource "yandex_compute_instance" "airbyte" {
  name        = "airbyte"
  platform_id = "standard-v3"
  zone        = yandex_vpc_subnet.default_subnet.zone

  resources {
    cores         = 4
    memory        = 8
    core_fraction = 100
  }

  boot_disk {
    auto_delete = true
    initialize_params {
      image_id = "fd8linvus5t2ielkr8no" // with Airbyte installed
      size     = 30
      type     = "network-ssd"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.default_subnet.id
    ipv4      = true
    nat       = true
  }

  scheduling_policy {
    preemptible = true
  }

  metadata = {
    user-data = "${file("cloud-init.yaml")}"
  }
}

resource "yandex_mdb_postgresql_cluster" "postgresql_cluster" {
  name        = "postgresql-cluster"
  environment = "PRESTABLE"
  network_id  = yandex_vpc_network.default_network.id

  host {
    zone             = "ru-central1-b"
    subnet_id        = yandex_vpc_subnet.default_subnet.id
    assign_public_ip = true
  }

  config {
    version = "14"
    resources {
      resource_preset_id = "s2.micro"
      disk_size          = 10
      disk_type_id       = "network-ssd"
    }
    access {
      web_sql = true
    }
  }
}

resource "yandex_mdb_postgresql_user" "pguser" {
  cluster_id = yandex_mdb_postgresql_cluster.postgresql_cluster.id
  name       = var.postgresql_user
  password   = var.postgresql_password
}

resource "yandex_mdb_postgresql_database" "exampledb" {
  cluster_id = yandex_mdb_postgresql_cluster.postgresql_cluster.id
  name       = "exampledb"
  owner      = yandex_mdb_postgresql_user.pguser.name
  depends_on = [yandex_mdb_postgresql_user.pguser]
}
