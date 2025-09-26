# module "docker" {
#   source              = "../modules/vm"
#
#   name                = "master1"
#   disk_file_id        = "tuuninas:iso/rocky.img"
#   vmid                = 5550
#   datastore_id        = "local-lvm"
#   cores               = 4
#   memory              = 4096
#   admin_user          = "johan"
#   role                = "web"
#   ssh_public_key_file = "./keys/rocky.pub"
#   ip_addr             = "10.0.1.201/16"
# }

module "k3s-cluster" {
  source   = "../modules/vm"

  for_each = var.vms

  name                = each.key
  disk_file_id        = each.value.disk_file_id
  proxmox_node        = each.value.proxmox_node
  vmid                = each.value.vmid
  cores               = each.value.cores
  memory              = each.value.memory
  admin_user          = each.value.admin_user
  role                = each.value.role
  ssh_public_key_file = each.value.ssh_public_key_file
  ip_addr             = each.value.ip_address
}

locals {
  # Group VMs by role for Ansible inventory
  vms_by_role = {
    for role in distinct([for vm in var.vms : vm.role]) : role => {
      for vm_name, vm_config in var.vms : vm_name => {
        ansible_host    = replace(vm_config.ip_address, "/16", "")
        ansible_user    = vm_config.admin_user
        role           = vm_config.role
        ssh_key_file   = replace(replace(vm_config.ssh_public_key_file, "./keys/", "~/.ssh/"), ".pub", "")
      } if vm_config.role == role
    }
  }
}
resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/templates/inventory.tpl", {
    vms_by_role = local.vms_by_role
  })
  filename = "${path.module}./../ansible/hosts.yaml"
}
output "ansible_inventory_content" {
  value = templatefile("${path.module}/templates/inventory.tpl", {
    vms_by_role = local.vms_by_role
  })
}
