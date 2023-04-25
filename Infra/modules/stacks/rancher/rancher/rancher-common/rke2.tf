# RKE2 cluster for NeuVector
resource "ssh_resource" "rke2_config_dir" {
  host = var.node_public_ip
  commands = [
    "sudo mkdir -p /etc/rancher/rke2",
    "sudo chmod 777 /etc/rancher/rke2"
  ]
  user        = var.node_username
  private_key = var.ssh_private_key_pem
}
resource "ssh_resource" "rke2_config" {
  depends_on = [ssh_resource.rke2_config_dir]

  host        = var.node_public_ip
  user        = var.node_username
  private_key = var.ssh_private_key_pem

  file {
    content     = <<EOT
tls-san:
  - ${var.node_public_ip}
node-external-ip: ${var.node_public_ip}
EOT
    destination = "/etc/rancher/rke2/config.yaml"
    permissions = "0644"
  }
}
resource "ssh_resource" "install_rke2" {
  depends_on = [ssh_resource.rke2_config]
  host       = var.node_public_ip
  commands = [
    "sudo bash -c 'curl https://get.rke2.io | INSTALL_RKE2_VERSION=${var.rancher_kubernetes_version} sh -'",
    "sudo systemctl enable rke2-server",
    "sudo systemctl start rke2-server",
    "sleep 120", # wait until the ingress controller, including the validating webhook is available, otherwise the installation of charts with ingresses may fail
    "sudo /var/lib/rancher/rke2/bin/kubectl --kubeconfig /etc/rancher/rke2/rke2.yaml rollout status daemonset rke2-ingress-nginx-controller -n kube-system"
  ]
  user        = var.node_username
  private_key = var.ssh_private_key_pem
}

resource "ssh_resource" "retrieve_config" {
  depends_on = [
    ssh_resource.install_rke2
  ]
  host = var.node_public_ip
  commands = [
    "sudo sed \"s/127.0.0.1/${var.node_public_ip}/g\" /etc/rancher/rke2/rke2.yaml"
  ]
  user        = var.node_username
  private_key = var.ssh_private_key_pem
}

# Save kubeconfig file for interacting with the RKE cluster on your local machine
# resource "local_file" "kube_config_server_yaml" {
#   filename = format("%s/%s", path.root, "kube_config.yaml")
#   content  = ssh_resource.retrieve_config.result
# }
