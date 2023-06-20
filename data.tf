data "azurerm_resource_group" "NRG" {
  name = azurerm_kubernetes_cluster.aks_cluster.node_resource_group
}

