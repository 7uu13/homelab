# K3s Ansible Deployment

This playbook deploys a K3s Kubernetes cluster with support for HA (high-availability) server nodes and worker agents.

## Features

- HA K3s cluster deployment with multiple server nodes
- Automatic worker node joining
- Configurable K3s version
- Customizable cluster and service CIDRs
- Automatic kubeconfig retrieval and local storage
- Idempotent deployment (can be run multiple times safely)

## Inventory Structure

The inventory uses the following group structure:

```yaml
k3s_cluster:
  k3s_servers:    # Control plane nodes
    - master1
    - master2     # Optional: add more for HA
    - master3     # Optional: add more for HA
  k3s_agents:     # Worker nodes
    - worker1
    - worker2
```

## Configuration

Default configuration is located in `ansible/roles/k3s/defaults/main.yaml`:

```yaml
k3s_version: v1.28.3+k3s1
k3s_server_config:
  disable: "traefik,servicelb"      # Disabled components
  write-kubeconfig-mode: "0644"      # Kubeconfig permissions
  cluster-cidr: "10.42.0.0/16"       # Pod network CIDR
  service-cidr: "10.43.0.0/16"       # Service network CIDR
```

You can override these in your inventory or create a vars file.

## Usage

### Deploy the entire cluster

```bash
ansible-playbook -i hosts.yaml playbooks/k3s/main.yaml
```

### Deploy only server nodes

```bash
ansible-playbook -i hosts.yaml playbooks/k3s/main.yaml --limit k3s_servers
```

### Deploy only agent nodes

```bash
ansible-playbook -i hosts.yaml playbooks/k3s/main.yaml --limit k3s_agents
```

### Add a new worker node

1. Add the new node to your inventory under `k3s_agents`
2. Run the playbook targeting only the new node:

```bash
ansible-playbook -i hosts.yaml playbooks/k3s/main.yaml --limit new_worker
```

## Kubeconfig

After successful deployment, the kubeconfig will be saved locally at:

```
ansible/playbooks/k3s/k3s-kubeconfig.yaml
```

To use it:

```bash
export KUBECONFIG=ansible/playbooks/k3s/k3s-kubeconfig.yaml
kubectl get nodes
```

## High Availability Setup

For HA, deploy at least 3 server nodes:

1. Update your inventory to include 3+ servers in `k3s_servers`
2. Run the playbook - the first server will initialize the cluster, and additional servers will join automatically

## Troubleshooting

### Check K3s service status on servers

```bash
ansible k3s_servers -i hosts.yaml -a "systemctl status k3s"
```

### Check K3s agent service status on workers

```bash
ansible k3s_agents -i hosts.yaml -a "systemctl status k3s-agent"
```

### View K3s logs on servers

```bash
ansible k3s_servers -i hosts.yaml -a "journalctl -u k3s -n 50"
```

### View K3s logs on agents

```bash
ansible k3s_agents -i hosts.yaml -a "journalctl -u k3s-agent -n 50"
```

## Uninstalling

To uninstall K3s from servers:

```bash
ansible k3s_servers -i hosts.yaml -b -a "/usr/local/bin/k3s-uninstall.sh"
```

To uninstall K3s from agents:

```bash
ansible k3s_agents -i hosts.yaml -b -a "/usr/local/bin/k3s-agent-uninstall.sh"
```
