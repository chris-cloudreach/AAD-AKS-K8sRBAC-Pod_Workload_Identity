# Create Outputs
# 1. Resource Group Location
# 2. Resource Group Id
# 3. Resource Group Name

# Resource Group Outputs
output "rg_location" {
  value = azurerm_resource_group.aks_rg.location
}
output "rg_name" {
  value = azurerm_resource_group.aks_rg.name
}

output "resource_group_id" {
  value = azurerm_resource_group.aks_rg.id
}

output "resource_group_name" {
  value = azurerm_resource_group.aks_rg.name
}

# Azure AKS Versions Datasource
output "versions" {
  value = data.azurerm_kubernetes_service_versions.current.versions
}

output "latest_version" {
  value = data.azurerm_kubernetes_service_versions.current.latest_version
}

# Azure AD Group Object Id
output "azure_ad_group_id" {
  value = azuread_group.aks_administrators.id
}
output "azure_ad_group_objectid" {
  value = azuread_group.aks_administrators.object_id
}


# Azure AKS Outputs

output "aks_cluster_id" {
  value = azurerm_kubernetes_cluster.aks_cluster.id
}

output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.aks_cluster.name
}

output "aks_cluster_kubernetes_version" {
  value = azurerm_kubernetes_cluster.aks_cluster.kubernetes_version
}

resource "local_file" "kubeconfig" {
  depends_on   = [azurerm_kubernetes_cluster.aks_cluster]
  filename     = "kubeconfig"
  content      = azurerm_kubernetes_cluster.aks_cluster.kube_config_raw
}

output "OIDC_url" {
  value = azurerm_kubernetes_cluster.aks_cluster.oidc_issuer_url
}
output "kv_uri" {
  value = azurerm_key_vault.OIDC_kv.vault_uri 
}
output "kv_MSI_clientID" {
  value = azurerm_user_assigned_identity.kv-msi.client_id
}
output "IngressIP" {
  value = azurerm_public_ip.ingressIP.ip_address
}
output "AKS-Id" {
  value = azurerm_kubernetes_cluster.aks_cluster.identity[0].principal_id
   # This is apparently object-id but does not show up in the portal
}
output "AKS-MSI-Id" {
  # This is object-id of the UAI in azzure portal
  value = azurerm_kubernetes_cluster.aks_cluster.kubelet_identity[0].object_id
}
