output "rest_api_id" {
  value = aws_api_gateway_rest_api.sftp.id
}

output "invoke_url" {
  value = aws_api_gateway_stage.prod.invoke_url
}

output "rest_api_stage_name" {
  value = aws_api_gateway_stage.prod.stage_name
}

output "rest_api_http_method" {
  value = aws_api_gateway_method.get.http_method
}

output "transfer_server_id" {
  value = aws_transfer_server.sftp_transfer_server.id
}

output "role_read_arn" {
 value = aws_iam_role.sftp_transfer_server_role_read.arn
}

output "role_write_arn" {
  value = aws_iam_role.sftp_transfer_server_role_write.arn
}
