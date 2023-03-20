# Azure EventHub
resource "azurerm_eventhub_namespace" "eventhub_namespace" {
  name                = "ehn-${var.environment.project_name}-${var.region}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"
  capacity            = 1
}

resource "azurerm_eventhub" "eventhub" {
  name                = "eh-${var.environment.project_name}-${var.region}"
  namespace_name      = azurerm_eventhub_namespace.eventhub_namespace.name
  resource_group_name = azurerm_resource_group.rg.name
  partition_count     = 2
  message_retention   = 1
  capture_description {
    enabled = true
    encoding = "Avro"
    interval_in_seconds = 300
    size_limit_in_bytes = 314572800
    destination {
      name = "eventhubarchive"
      archive_name_format = "{Namespace}/{EventHub}/{PartitionId}/{Year}/{Month}/{Day}/{Hour}/{Minute}/{Second}"
      storage_account_id = azurerm_storage_account.storage_account.id
      blob_container = "eventhubcontainer"
    }
  }
}