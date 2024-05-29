variable "vault_mount_path" {
  description = "vault mount path"
  type = string
  default = "SFTP"
}

variable "vault_path" {
  description = "vault path"
  type = string
  default = "users"
}

variable "s3_bucket_name" {
   description = "Transfer Server S3 bucket name"
   type        = string
}

variable "user_name" {
  description = "User name for SFTP server"
  type        = string
}

variable "user_home" {
  description = "HOME path for transfer server user. Mustn't start with /"
  type        = string
  default     = ""
}

variable "read_only" {
  description = "Define if the user is created with read-only privileges"
  type        = bool
  default     = false
}

variable "role_read_arn" {
  description = "Arn del role read generado en el stack sftp-server"
  type        = string
}

variable "role_write_arn" {
  description = "Arn del role write generado en el stack sftp-server"
  type        = string
}
