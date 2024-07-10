provider "azurerm" {
  features {}
}
module "resource_group" {
  source = "./modules/rgroup-1482"
  admin_password = var.admin_password
  tags = var.tags
  location = var.location
}

module "network" {
  source = "./modules/network-1482"
  admin_password = var.admin_password
  rg_name = module.resource_group.rg_name
  location = var.location
  nic_id     = module.network.nic_id
  tags = var.tags
}

module "common_services" {
  source = "./modules/common-1482"
  admin_password = var.admin_password
  rg_name = module.resource_group.rg_name
  location = var.location
  tags = var.tags
}

module "linux_vms" {
  source = "./modules/vmlinux-1482"
  
  admin_username = var.admin_username
  admin_password = var.admin_password
  rg_name    = module.resource_group.rg_name
  storage_account_uri = module.common_services.storage_account_name
  location   = var.location
  subnet_id  = module.network.subnet_id
  linux_vm_names   = var.linux_vm_names
  public_key_path  = var.public_key_path
  private_key_path = var.private_key_path
  ssh_public_key      = var.ssh_public_key
  ssh_private_key     = var.ssh_private_key
  vm_size = var.linux_vm_size
  log_analytics_workspace_id = var.log_analytics_workspace_id
  tags = var.tags
}


module "windows_vm" {
  source = "./modules/vmwindows-1482"
  admin_username = var.admin_username
  admin_password = var.admin_password
  vm_name     = var.vm_name
  rg_name    = module.resource_group.rg_name
  location   = var.location
  subnet_id  = module.network.subnet_id
  avset_id   = module.linux_vms.avset_id
  nic_id     = module.network.nic_id
  tags = var.tags
  log_analytics_workspace_id = var.log_analytics_workspace_id
}

module "data_disks" {
  source = "./modules/datadisk-1482"
  admin_password = var.admin_password
  rg_name  = module.resource_group.rg_name
  location = var.location
  linux_vm_ids        = module.linux_vms.linux_vm_ids
  windows_vm_ids      = module.windows_vm.windows_vm_ids
}

module "load_balancer" {
  source = "./modules/loadbalancer-1482"
   rg_name    = module.resource_group.rg_name
  location = var.location
  vm_name = var.vm_name
  tags = var.tags
  
}

module "database" {
  source = "./modules/database-1482"
  admin_username = var.admin_username
  admin_password = var.admin_password
  rg_name  = module.resource_group.rg_name
  location = var.location
  postgresql_version      = var.postgresql_version
  ssl_enforcement_enabled = var.ssl_enforcement_enabled
  tags = var.tags
}

