output "rancher_server_url" {
  value = module.rancher_common.rancher_url
}

output "rancher_node_ip" {
  value = aws_eip.rancher_server_eip.public_ip
}

# output "workload_node_ip" {
#   value = aws_instance.quickstart_node.public_ip
# }
