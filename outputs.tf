output "cluster_id" {
  description = "OpenSearch cluster ID"
  value       = yandex_mdb_opensearch_cluster.this.id
}

output "cluster_name" {
  description = "OpenSearch cluster name"
  value       = yandex_mdb_opensearch_cluster.this.name
}

output "cluster_host_names_list" {
  description = "OpenSearch cluster host name"
  value       = [yandex_mdb_opensearch_cluster.this.hosts[*].roles]
}

output "cluster_fqdns_list" {
  description = "OpenSearch cluster nodes FQDN list"
  value       = [yandex_mdb_opensearch_cluster.this.hosts[*].fqdn]
}

output "admin_data" {
  description = "Admin with passwords."
  sensitive   = true
  value       = var.admin_password == null ? random_password.password[0].result : var.admin_password
}
