locals {
  base_template_vars = {
    hostname       = var.name
    admin_user     = var.admin_user
    ssh_public_key = file(var.ssh_public_key_file)
  }

  # gotta render the base template inorder to extend it
  base_config = templatefile("${path.root}/templates/cloudinit/base.yaml", local.base_template_vars)

  template_vars = merge(local.base_template_vars, {
    vm_role        = var.role
    proxmox_node   = var.proxmox_node
    base_config = local.base_config
  })

  template_file = var.role != "base" ? "${path.cwd}/templates/cloudinit/${var.role}.yaml" : "${path.cwd}/templates/cloudinit/base.yaml"

  cloud_init_config = templatefile(local.template_file, local.template_vars)
}

resource "proxmox_virtual_environment_file" "vm_user_data" {
  content_type = "snippets"
  datastore_id = "local" 
  node_name    = var.proxmox_node

  source_raw {
    data = local.cloud_init_config
    file_name = "${var.name}-user-data.yaml"
  }
}
