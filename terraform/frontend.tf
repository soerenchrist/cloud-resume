resource "azurerm_resource_group" "frontendrg" {
  name     = "${var.project}-${var.environment}-frontend-rg"
  location = var.location
}

resource "azurerm_storage_account" "webstorage" {
  name                     = "${var.project}frontend${var.environment}sa"
  resource_group_name      = azurerm_resource_group.frontendrg.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  static_website {
    index_document     = "index.html"
    error_404_document = "404.html"
  }
}

resource "azurerm_storage_container" "webcontainer" {
  name                 = "$web"
  storage_account_name = azurerm_storage_account.webstorage.name
}

resource "azurerm_cdn_profile" "cdnprofile" {
  name                = "${var.project}-frontend-${var.environment}-cdn-profile"
  location            = "Global"
  resource_group_name = azurerm_resource_group.frontendrg.name
  sku                 = "Standard_Microsoft"
}

resource "azurerm_cdn_endpoint" "cdnendpoint" {
  name                = "${var.project}-frontend-${var.environment}-cdn"
  profile_name        = azurerm_cdn_profile.cdnprofile.name
  location            = "Global"
  resource_group_name = azurerm_resource_group.frontendrg.name

  origin {
    name      = "${var.project}-frontend-${var.environment}-origin"
    host_name = "${azurerm_storage_account.webstorage.name}.z6.web.core.windows.net"
  }
}