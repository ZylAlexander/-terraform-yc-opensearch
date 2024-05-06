resource "random_password" "password" {
  count            = var.admin_password == null ? 1 : 0
  length           = 16
  special          = true
  min_lower        = 1
  min_numeric      = 1
  min_special      = 1
  min_upper        = 1
  override_special = "-_()[]{}!%^"
}

resource "yandex_mdb_opensearch_cluster" "this" {

  folder_id   = var.folder_id
  environment = var.environment
  network_id  = var.network_id

  name        = var.name
  description = var.description

  labels              = var.labels
  security_group_ids  = var.security_group_ids
  service_account_id  = var.service_account_id
  deletion_protection = var.deletion_protection


  config {

    version        = var.opensearch_version
    admin_password = var.admin_password == null ? random_password.password[0].result : var.admin_password

    dashboards {
      dynamic "node_groups" {
        for_each = var.dashboards_node_groups
        content {
          assign_public_ip = node_groups.value.assign_public_ip
          hosts_count      = node_groups.value.hosts_count
          name             = "nodegroup-dashboards-${node_groups.key}"
          subnet_ids       = node_groups.value.subnet_ids
          zone_ids         = node_groups.value.zone_ids

          resources {
            disk_size          = node_groups.value.resources.disk_size
            disk_type_id       = node_groups.value.resources.disk_type_id
            resource_preset_id = node_groups.value.resources.resource_preset_id
          }
        }
      }
    }
    opensearch {
      dynamic "node_groups" {
        for_each = var.opensearch_node_groups
        content {
          assign_public_ip = node_groups.value.assign_public_ip
          hosts_count      = node_groups.value.hosts_count
          name             = "nodegroup-opensearch-${node_groups.key}"
          roles            = node_groups.value.roles
          subnet_ids       = node_groups.value.subnet_ids
          zone_ids         = node_groups.value.zone_ids

          resources {
            disk_size          = node_groups.value.resources.disk_size
            disk_type_id       = node_groups.value.resources.disk_type_id
            resource_preset_id = node_groups.value.resources.resource_preset_id
          }
        }
      }
    }
  }

  dynamic "maintenance_window" {
    for_each = range(var.maintenance_window == null ? 0 : 1)
    content {
      type = var.maintenance_window.type
      day  = var.maintenance_window.day
      hour = var.maintenance_window.hour
    }
  }

}

