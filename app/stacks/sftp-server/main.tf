module "sftp" {
  source      = "../../modules/sftp-server"
  name_prefix = var.sftp_name
  region      = var.region
  input_tags  = var.sftp_tags
  security_group_ids = var.security_group_ids
  subnets_ids = var.subnets_ids
}
