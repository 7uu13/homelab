#f Proxmox provider setup
variable "virtual_environment_endpoint" {
  type        = string
  description = "URL for the Proxmox Virtual Environment"
}

variable "virtual_environment_username" {
  type        = string
  description = "The username and realm for the Proxmox Virtual Environment (example: root@pam)"
}

variable "virtual_environment_password" {
  type        = string
  sensitive   = true
  description = "The password for the Proxmox Virtual Environment"
}

variable "pm_tls_insecure" {
  description = "Set to true to ignore certificate errors"
  type        = bool
  default     = false
}

variable "vms" {
  description = "A map of VMs to create"
  type = map(object({
    name                = string
    disk_file_id        = string
    proxmox_node        = string
    admin_user          = string
    vmid                = number
    memory              = number
    cores               = number
    ip_address          = string
    role                = string
    ssh_public_key_file = string
  }))
}
