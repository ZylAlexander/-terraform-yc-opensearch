variable "folder_id" {
  description = "The ID of the folder that the resource belongs to. If it is not provided, the default provider folder is used."
  type        = string
}

variable "name" {
  description = "Name of the OpenSearch cluster. Provided by the client when the cluster is created."
  type        = string
}

variable "environment" {
  description = "Deployment environment of the OpenSearch cluster. Can be either PRESTABLE or PRODUCTION. Default: PRODUCTION"
  type        = string
  default     = "PRODUCTION"

  validation {
    condition     = contains(["PRODUCTION", "PRESTABLE"], var.environment)
    error_message = "Release channel should be PRODUCTION (stable feature set) or PRESTABLE (early bird feature access)."
  }
}

variable "network_id" {
  description = "ID of the network, to which the OpenSearch cluster belongs."
  type        = string
}

variable "opensearch_version" {
  description = "Version of OpenSearch."
  type        = string

  validation {
    condition     = contains(["2.8", "2.12"], var.opensearch_version)
    error_message = "Version should be 2.8 or 2.12."
  }
  default = "2.12"
}

variable "admin_password" {
  description = "Password for admin user of OpenSearch."
  type        = string
  sensitive   = true
  default     = null
}

variable "description" {
  description = "Description of the OpenSearch cluster."
  type        = string
  default     = ""
}

variable "deletion_protection" {
  description = "Inhibits deletion of the cluster. Can be either true or false."
  type        = bool
  default     = false
}

variable "labels" {
  description = "A set of key/value label pairs to assign to the OpenSearch cluster."
  type        = map(any)
  default     = {}
}

variable "service_account_id" {
  description = "ID of the service account authorized for this cluster."
  default     = null
}

variable "security_group_ids" {
  description = "A set of ids of security groups assigned to hosts of the"
  type        = list(string)
  default     = []
  nullable    = true
}

variable "maintenance_window" {
  description = <<EOF
    (Optional) Maintenance policy of the PostgreSQL cluster.
      - type - (Required) Type of maintenance window. Can be either ANYTIME or WEEKLY. A day and hour of window need to be specified with weekly window.
      - day  - (Optional) Day of the week (in DDD format). Allowed values: "MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"
      - hour - (Optional) Hour of the day in UTC (in HH format). Allowed value is between 0 and 23.
  EOF
  type = object({
    type = string
    day  = optional(string, null)
    hour = optional(string, null)
  })
  default = {
    type = "ANYTIME"
  }
}

variable "opensearch_node_groups" {

  description = <<EOF
    (Optional) A set of named OpenSearch node group configurations. The structure is documented below
      - name - (Required) Name of OpenSearch node group.
      - resources - (Required) Resources allocated to hosts of this OpenSearch node group. The structure is documented below.
      - host_count - (Required) Number of hosts in this node group.
      - zones_ids - (Required) A set of availability zones where hosts of node group may be allocated.
      - subnet_ids - (Optional) A set of the subnets, to which the hosts belongs. The subnets must be a part of the network to which the cluster belongs.
      - assign_public_ip - (Optional) Sets whether the hosts should get a public IP address on creation.
      - roles - (Optional) A set of OpenSearch roles assigned to hosts. Available roles are: DATA, MANAGER. Default: [DATA, MANAGER]
  EOF
  type = map(object({
    assign_public_ip = optional(bool, false)
    hosts_count      = number
    roles            = list(string)
    subnet_ids       = list(string)
    zone_ids         = list(string)

    resources = object({
      disk_size          = number
      disk_type_id       = string
      resource_preset_id = string
    })
  }))

}

variable "dashboards_node_groups" {
  description = <<EOF
    (Optional) A set of named OpenSearch node group configurations. The structure is documented below
      - name - (Required) Name of OpenSearch node group.
      - resources - (Required) Resources allocated to hosts of this OpenSearch node group. The structure is documented below.
      - host_count - (Required) Number of hosts in this node group.
      - zones_ids - (Required) A set of availability zones where hosts of node group may be allocated.
      - subnet_ids - (Optional) A set of the subnets, to which the hosts belongs. The subnets must be a part of the network to which the cluster belongs.
      - assign_public_ip - (Optional) Sets whether the hosts should get a public IP address on creation.      
  EOF
  type = map(object({
    assign_public_ip = optional(bool, false)
    hosts_count      = number
    subnet_ids       = list(string)
    zone_ids         = list(string)

    resources = object({
      disk_size          = number
      disk_type_id       = string
      resource_preset_id = string
    })
  }))

}

