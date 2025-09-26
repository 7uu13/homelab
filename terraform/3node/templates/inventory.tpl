---
all:
  children:
%{ for role, vms in vms_by_role ~}
    ${role}:
      hosts:
%{ for vm_name, vm_info in vms ~}
        ${vm_name}:
          ansible_host: ${vm_info.ansible_host}
          ansible_user: ${vm_info.ansible_user}
          ansible_ssh_private_key_file: ${vm_info.ssh_key_file}
%{ endfor ~}
%{ endfor ~}
