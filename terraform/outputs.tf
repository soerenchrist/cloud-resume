output "function_app_name" {
  value       = azurerm_windows_function_app.functionapp.name
  description = "Deployed function app name"
}

output "function_app_default_hostname" {
  value       = azurerm_windows_function_app.functionapp.default_hostname
  description = "Deployed function app hostname"
}