resource "azurerm_kubernetes_cluster_node_pool" "user" {
  zones    = [1, 2, 3]
  enable_auto_scaling   = true
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks_cluster.id
  max_count             = 3
  min_count             = 1
  mode                  = "User"
  enable_host_encryption = false
  enable_node_public_ip  = false
  fips_enabled           = false
  vnet_subnet_id        = azurerm_subnet.aks-default.id
  name                  = "userpool"
  orchestrator_version  = data.azurerm_kubernetes_service_versions.current.latest_version
  os_disk_size_gb       = 1024
  vm_size               = "standard_d2ads_v5"
}

# resource "azurerm_kubernetes_cluster_node_pool" "Spot" {
#   # priority = "Regular"

#   priority = "Spot"
#   eviction_policy = "Delete"
#   spot_max_price  = -1
#   node_labels = {
#         "kubernetes.azure.com/scalesetpriority" = "spot"
#       }
#       # pod toleration should match taint
#   node_taints = [
#         "kubernetes.azure.com/scalesetpriority=spot:NoSchedule"
#       ]


#   availability_zones    = [1, 2, 3]

#   node_count = 1
#   # enable_auto_scaling   = true
#   # max_count             = 3
#   # min_count             = 1


#   kubernetes_cluster_id = azurerm_kubernetes_cluster.aks_cluster.id

#   mode                  = "User"
#   enable_host_encryption = false
#   enable_node_public_ip  = false
#   fips_enabled           = false
#   vnet_subnet_id        = azurerm_subnet.aks-default.id
#   name                  = "spotpool"
#   orchestrator_version  = data.azurerm_kubernetes_service_versions.current.latest_version
#   os_disk_size_gb       = 1024

#   # if deploying spot priority, vm size may not be available
#   vm_size               = "standard_d2as_v5"
# }