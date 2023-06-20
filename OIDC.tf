data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "OIDC_kv" {
  name                        = "OIDC-kv"
  location                    = azurerm_resource_group.onprem-vnet-rg.location
  resource_group_name         = azurerm_resource_group.onprem-vnet-rg.name
  enabled_for_disk_encryption = false
  tenant_id                   = data.azurerm_client_config.current.tenant_id
#   soft_delete_retention_days  = 7  #not enabling soft delete
  purge_protection_enabled    = false  #not enabling purge protect 


  sku_name = "standard"
  enable_rbac_authorization = true

# NO NEED TO USE ACCESS POLICY FOR KV
    # USE RBAC INSTEAD
#   access_policy {
#     tenant_id = data.azurerm_client_config.current.tenant_id
#     object_id = data.azurerm_client_config.current.object_id

#     key_permissions = [
#       "Get",
#     ]

#     secret_permissions = [
#       "Get",
#     ]

#     storage_permissions = [
#       "Get",
#     ]
#   }
}
resource "azurerm_key_vault_secret" "OIDC-secret" {
        # give spn key vault secret officer RBAC role at subscription scope
  name         = "OIDC-secret"
  value        = "@@hello!77&&8"
  key_vault_id = azurerm_key_vault.OIDC_kv.id
}
# az identity federated-credential create 
    # --name oidc_fed_cred 
    # --identity-name "kv-msi" 
    # --resource-group "baseRG" 
    # --issuer "https://oidc-kv.vault.azure.net/" 
    # --subject system:serviceaccount:"wid":"workloadIDsa" 
    # --audience api://AzureADTokenExchange

# az identity federated-credential create --name oidc_fed_cred --identity-name "kv-msi" --resource-group "baseRG" --issuer "https://oidc-kv.vault.azure.net/" --subject system:serviceaccount:"wid":"workloadIDsa" --audience api://AzureADTokenExchange

resource "azurerm_federated_identity_credential" "oidc_fed_cred" {
    # You may need to grant the spn `Directory.ReadWrite.All api permissions 
  parent_id = azurerm_user_assigned_identity.kv-msi.id
  resource_group_name         = azurerm_resource_group.onprem-vnet-rg.name
  name          = "oidc_fed_cred"
#   description           = "my AKS OIDC federated credentials"
  audience             = ["api://AzureADTokenExchange"]
#   issuer                = "https://token.actions.githubusercontent.com"
  issuer =                  azurerm_kubernetes_cluster.aks_cluster.oidc_issuer_url
  subject =           "system:serviceaccount:wid:workloadIDsa"
#   subject               = "repo:my-organization/my-repo:environment:prod"
}

# CREATING MSI for accessing kv
resource "azurerm_user_assigned_identity" "kv-msi" {
  name                = "kv-msi"
  resource_group_name = azurerm_resource_group.onprem-vnet-rg.name
  location            = azurerm_resource_group.onprem-vnet-rg.location
}

resource "azurerm_role_assignment" "kv-msi-kv-role-assign" {
  scope              = azurerm_key_vault.OIDC_kv.id
  role_definition_name = "Key Vault Administrator"
  principal_id       = azurerm_user_assigned_identity.kv-msi.principal_id
}

resource "azurerm_role_assignment" "kv-msi-ACR-role-assign" {
  principal_id                     = azurerm_user_assigned_identity.kv-msi.principal_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.myACR.id
#   skip_service_principal_aad_check = true
} 
