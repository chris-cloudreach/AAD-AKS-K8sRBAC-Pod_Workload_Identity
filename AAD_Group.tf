# Create Azure AD Group in Active Directory for AKS Admins

# make sure SPN has AAD role - user administrator
# Make sure you add yourself to the admin group
# make sure u specify the correct object id of the grp in the yaml file

resource "azuread_group" "aks_administrators" {
  display_name        = "${azurerm_resource_group.aks_rg.name}-cluster-administrators"
  description = "Azure AKS Kubernetes administrators for the ${azurerm_resource_group.aks_rg.name}-cluster."
  security_enabled = true
}

# resource "azuread_user" "example_user" {
#   # CREATES USER, NOT NEEDED
#   display_name = "John Doe"
#   user_principal_name = "john.doe@example.com"
#   password = "MyStrongPassword123"
# }

resource "azuread_group_member" "AddChrisToAADGrp" {
  group_object_id = azuread_group.aks_administrators.object_id
  # member_object_id = azuread_user.example_user.object_id
  member_object_id = "1004f506-be41-4ebe-a590-34837292b5b8"

}

# ------------------- ROLE ASSIGN ------------------------
resource "azurerm_role_assignment" "aks_administrators-role-assign" {
  scope                = azurerm_kubernetes_cluster.aks_cluster.id
  role_definition_name = "Azure Kubernetes Service Cluster User Role"
  principal_id         = azuread_group.aks_administrators.object_id
}

# This is to give me RBAC permission to create kv secret
  # NOT FOR K8S CLUSTER
resource "azurerm_role_assignment" "aksRoleAssign-KVA" {
  principal_id                     = azuread_group.aks_administrators.object_id
  role_definition_name             = "Key Vault Administrator"
  scope                            = azurerm_key_vault.OIDC_kv.id
}

# commented out bcos k8s rbac admin gives access to view via portal 

# resource "azurerm_role_assignment" "aksadmin2" {
#   scope                = azurerm_kubernetes_cluster.aks_cluster.id
#   # role_definition_name = "Azure Kubernetes Service Cluster User Role"
#   # role_definition_name = "Azure Kubernetes Service Cluster Admin Role" 
#   role_definition_name = "Azure Kubernetes Service RBAC Admin"

#   principal_id         = azuread_group.aks_administrators.object_id
# }
