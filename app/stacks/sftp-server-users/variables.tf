variable "sftp_user_name_prefix" {
  description = "Prefijo asignado a todos los recursos creados con este modulo"
  type        = string
}
variable "sftp_user_s3_bucket_name" {
  description = "Transfer Server S3 bucket name"
  type        = string
}
variable "sftp_user_transfer_server_id" {
  description = "id del transfer server SFTP creado en el stack sftp-server"
  type        = list(string)
}
variable "sftp_user_user_name" {
  description = "Nombre del usuario"
  type        = string
}
variable "sftp_user_read_only" {
  description = "Asignacion de usuario de solo lectura"
  type        = bool
  default     = true
}
variable "sftp_user_input_tags" {
  description = "Tags"
  type        = map(string)
}
variable "sftp_user_secrets_prefix" {
  description = "Prefijo del secreto creado en la boveda"
  type        = string
}
variable "sftp_user_user_home" {
  description = "HOME path for transfer server user. Mustn't start with /"
  type        = string
}

variable "vault_auth_url" {
  description = "vault url"
  type        = string
  default     = "http://vault.auronix.com"
}

variable "vault_auth_token" {
  description = "vault token"
  type        = string
  default     = ""
}
