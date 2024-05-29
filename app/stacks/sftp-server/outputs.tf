# This is where you put your outputs declaration

output "transfer_server_role_read_arn" {
 value = module.sftp.role_read_arn
}

output "transfer_server_role_write_arn" {
  value = module.sftp.role_write_arn
}

output "s3_bucket_name" {
  value = var.s3_bucket_name
}
