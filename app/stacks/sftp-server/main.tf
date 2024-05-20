module "sftp" {
  source      = "../../modules/sftp-server"
  name_prefix = var.sftp_name
  region      = var.region
  input_tags  = var.sftp_tags

}



