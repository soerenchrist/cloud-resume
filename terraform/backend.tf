resource "azurerm_resource_group" "backendrg" {
  name     = "${var.project}-backend-${var.environment}-rg"
  location = var.location
}

resource "azurerm_cosmosdb_account" "cosmosdb" {
  name                = "${var.project}-backend-${var.environment}-cosmos"
  resource_group_name = azurerm_resource_group.backendrg.name
  offer_type          = "Standard"
  location            = azurerm_resource_group.backendrg.location

  capabilities {
    name = "EnableTable"
  }

  capabilities {
    name = "EnableServerless"
  }

  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 300
    max_staleness_prefix    = 100000
  }

  geo_location {
    location          = "westeurope"
    failover_priority = 0
  }
}

resource "azurerm_cosmosdb_table" "cosmosdbtable" {
  name                = "Visitors"
  resource_group_name = azurerm_resource_group.backendrg.name
  account_name        = azurerm_cosmosdb_account.cosmosdb.name
}

resource "azurerm_storage_account" "functionstorage" {
  name                     = "${var.project}backend${var.environment}sa"
  resource_group_name      = azurerm_resource_group.backendrg.name
  location                 = azurerm_resource_group.backendrg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_service_plan" "serviceplan" {
  name                = "${var.project}-backend-${var.environment}-app-service-plan"
  resource_group_name = azurerm_resource_group.backendrg.name
  location            = azurerm_resource_group.backendrg.location
  os_type             = "Windows"
  sku_name            = "Y1"
}

resource "azurerm_application_insights" "applicationinsights" {
  name                = "${var.project}-backend-${var.environment}-insights"
  location            = azurerm_resource_group.backendrg.location
  resource_group_name = azurerm_resource_group.backendrg.name
  application_type    = "web"
}

resource "azurerm_windows_function_app" "functionapp" {
  name                = "${var.project}-backend-${var.environment}-function-app"
  resource_group_name = azurerm_resource_group.backendrg.name
  location            = azurerm_resource_group.backendrg.location

  storage_account_name       = azurerm_storage_account.functionstorage.name
  storage_account_access_key = azurerm_storage_account.functionstorage.primary_access_key
  service_plan_id            = azurerm_service_plan.serviceplan.id

  site_config {
    application_stack {
      dotnet_version = "6"
    }
    cors {
      allowed_origins = [
        "https://*.github.dev",
        "https://*.azureedge.net",
        "https://*.z6.web.core.windows.net",
        "https://www.soerenchrist.de",
        "https://soerenchrist.de"
      ]
    }
  }

  app_settings = {
    CosmosDbConnection               = "DefaultEndpointsProtocol=https;AccountName=${azurerm_cosmosdb_account.cosmosdb.name};AccountKey=${azurerm_cosmosdb_account.cosmosdb.primary_key};TableEndpoint=https://${azurerm_cosmosdb_account.cosmosdb.name}.table.cosmos.azure.com:443/;"
    StorageAccountBlobConnection     = azurerm_storage_account.webstorage.primary_blob_connection_string
    "APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.applicationinsights.instrumentation_key
  }
}