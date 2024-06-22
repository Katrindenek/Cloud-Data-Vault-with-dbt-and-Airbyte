variable "folder_id" {
  description = "Folder ID"
  type        = string
}

variable "postgresql_password" {
  description = "PostgreSQL admin password"
  type        = string
  sensitive   = true
}

variable "postgresql_user" {
  description = "PostgreSQL username"
  type        = string
}

output "postgresql_cluster_id" {
  value = yandex_mdb_postgresql_cluster.postgresql_cluster.id
}

output "postgresql_host" {
  value = yandex_mdb_postgresql_cluster.postgresql_cluster.host[0].fqdn
}

output "postgresql_dbname" {
  value = yandex_mdb_postgresql_database.exampledb.name
}

output "postgresql_user" {
  value = yandex_mdb_postgresql_user.pguser.name
}

output "yandex_compute_instance_nat_ip_address" {
  value = yandex_compute_instance.airbyte.network_interface[0].nat_ip_address
}

output "yandex_iam_service_account_static_access_key" {
  value = yandex_iam_service_account_static_access_key.sa-static-key.access_key
}

output "yandex_iam_service_account_static_secret_key" {
  value     = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  sensitive = true
}
