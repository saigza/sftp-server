module "sftp" {
  source                          = "../../modules/sftp-server"
  name_prefix                     = var.sftp_name
  region                          = var.region
  input_tags                      = var.sftp_tags
  security_group_ids_lambda       = var.security_group_ids_lambda
  subnets_ids                     = var.subnets_ids
  vpc_id_endpoint                 = var.vpc_id_endpoint
  subnets_ids_endpoint            = var.subnets_ids_endpoint
  address_allocation_ids_endpoint = var.address_allocation_ids_endpoint
  network_interface_id_sftp       = var.network_interface_id_sftp
}