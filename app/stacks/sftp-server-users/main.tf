module "sftp-user" {
  source             = "../../modules/sftp-server-user"
  name_prefix        = var.sftp_user_name_prefix
  s3_bucket_name     = var.sftp_user_s3_bucket_name
  #transfer_server_id = var.sftp_user_transfer_server_id
  user_name          = var.sftp_user_user_name
  read_only          = var.sftp_user_read_only
  input_tags         = var.sftp_user_input_tags
  secrets_prefix     = var.sftp_user_secrets_prefix
  user_home          = var.sftp_user_user_home
}
