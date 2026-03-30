output "resource_group" {
  value = azurerm_resource_group.rg.name
}

output "key_vault" {
  value = azurerm_key_vault.kv.name
}

output "log_analytics" {
  value = azurerm_log_analytics_workspace.law.name
}

output "action_group" {
  value = azurerm_monitor_action_group.ag.name
}