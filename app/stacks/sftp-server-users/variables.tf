variable "sftp_user_s3_bucket_name" {
  description = "Bucket name principal de acceso"
  type        = string
}

variable "sftp_users" {
  description = "Sftp Users"
  type        = map(any)
  default     = {}
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

variable "sftp_user_role_read_arn" {
  description = "Arn del role read generado en el stack sftp-server"
  type        = string
}

variable "sftp_user_role_write_arn" {
  description = "Arn del role write generado en el stack sftp-server"
  type        = string
}
