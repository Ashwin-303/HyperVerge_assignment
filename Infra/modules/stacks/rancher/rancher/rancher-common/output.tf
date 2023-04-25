# Outputs

output "rancher_url" {
  value = "https://${var.rancher_server_dns}"
}

# output "custom_cluster_command" {
#   value       = rancher2_cluster_v2.quickstart_workload.cluster_registration_token.0.insecure_node_command
#   description = "Docker command used to add a node to the quickstart cluster"
# }
