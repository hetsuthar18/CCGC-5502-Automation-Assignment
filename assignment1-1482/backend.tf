terraform {
 backend "azurerm" {
   resource_group_name  = "tfstaten01651482RG"
   storage_account_name = "tfstaten01651482sa"
   container_name       = "terraform-state"
   key                  = "terraform.tfstate"
  }
}


