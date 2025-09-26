variable "name" {   
  description = "Name of the machine"
  type = string
}

variable "admin_user" {
  type = string
}

variable "role" {
  type = string 
}

variable "ssh_public_key_file" {
  type = string
}

variable "proxmox_node" {   
  description = "Name of the node"
  type = string
  default = "pmox-1"
}

variable "vmid" {   
  description = "ID for the vm"
  type = number
}

variable "cores" {   
  description = "Number of CPU Cores"
  type = number
  default = 2
}

variable "type" {   
  description = "CPU type"
  type = string
  default = "x86-64-v2-AES"
}
variable "memory" {
  description = "RAM in MB"
  type        = number
  default     = 2048
}

variable "disk_file_id" {
  description = "Disk image file to use"
  type        = string
}

variable "disk_size" {
  description = "Disk size in GB"
  type        = number
  default     = 20
}

variable "ip_addr" {
  description = "IpV4 address of the machine"
  type        = string
  default = "dhcp"
}

variable "interface" {
  description = "Disk Interface"
  type        = string
  default = "virtio0"
}

variable "datastore_id" {
  description = "Datasore for ISO"
  type        = string
  default = "local-lvm"
}

