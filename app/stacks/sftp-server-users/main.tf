module "sftp-user" {
  source            = "../../modules/sftp-server-user"
  s3_bucket_name    = var.sftp_user_s3_bucket_name
  for_each          = var.sftp_users
  user_name         = each.key
  read_only         = lookup(each.value, "read_only", null)
  user_home         = lookup(each.value, "user_home", null)
  role_read_arn     = var.sftp_user_role_read_arn
  role_write_arn    = var.sftp_user_role_write_arn
}
