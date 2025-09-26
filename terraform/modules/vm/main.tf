resource "proxmox_virtual_environment_vm" "vm" {
  name      = var.name
  node_name = var.proxmox_node
  vm_id = var.vmid

  agent {
    enabled = true
  }

  cpu {
    cores = var.cores
    type  = var.type
  }

  memory {
    dedicated = var.memory
  }

  disk {
    datastore_id = var.datastore_id
    file_id      = var.disk_file_id
    interface    = var.interface
    size         = var.disk_size
    iothread     = true
    discard      = "on"
  }

  initialization {
    ip_config {
      ipv4 {
        address = var.ip_addr
        gateway = "10.0.1.1"
      }
    }
    dns {
      servers = ["10.0.1.1"]
    }
    user_data_file_id = proxmox_virtual_environment_file.vm_user_data.id
  }

  network_device {
    bridge = "vmbr0"
  }
}
