# create IP in node resource group
resource "azurerm_public_ip" "ingressIP" {
  name                = "ingressIP"
  resource_group_name = azurerm_kubernetes_cluster.aks_cluster.node_resource_group
  location            = azurerm_kubernetes_cluster.aks_cluster.location
  allocation_method   = "Static"
  sku = "Standard"  # must use Standard sku for ingress ip
}
