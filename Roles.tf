# NOTE !!
# DONT ASSIGN ROLES TO KUBELET IDENTITY IN PRODUCTION 
    # DONT ASSIGN ROLES TO KUBELET IDENTITY since any pod in the nodepool can use it
    # violates infosec priciple of least privilege

# This is the only role i want to assign to kubelet identity
    # ACR role
resource "azurerm_role_assignment" "aksRoleAssign" {
  principal_id                     = azurerm_kubernetes_cluster.aks_cluster.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.myACR.id
  skip_service_principal_aad_check = true
} 
    
resource "azurerm_role_assignment" "aksRoleAssign-subnetreader" {
  principal_id                     = azurerm_kubernetes_cluster.aks_cluster.kubelet_identity[0].object_id
  role_definition_name             = "Network Contributor"
  scope                            = azurerm_subnet.aks-default.id
}
resource "azurerm_role_assignment" "aksRoleAssign-subnetreader2" {
  principal_id                     = azurerm_kubernetes_cluster.aks_cluster.identity[0].principal_id
  role_definition_name             = "Network Contributor"
  scope                            = azurerm_subnet.aks-default.id
}
