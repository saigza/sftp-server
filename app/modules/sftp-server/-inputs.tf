variable "region" {
  description = "AWS Region"
  type        = string
}

variable "secrets_prefix" {
  description = "Prefix used to create AWS Secrets"
  default     = "SFTP"
  type        = string
}

variable "input_tags" {
  description = "Map of tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "name_prefix" {
  description = "String to use as prefix on object names"
  type        = string
}

variable "name_suffix" {
  description = "String to append to object names. This is optional, so start with dash if using"
  type        = string
  default     = ""
}

variable "subnets_ids" {
  description = "subnet ids associate to lambda"
  type        = list(string)
}

variable "security_group_ids_lambda" {
  description = "security group ids associate to lambda"
  type        = list(string)
}

variable "vpc_id_endpoint" {
  description = "Id de la VPC donde se desplegará el endpoint type VPC"
  type        = string
}

variable "subnets_ids_endpoint" {
  description = "subnet id donde se desplegará el endpoint type VPC"
  type        = list(string)
}

variable "address_allocation_ids_endpoint" {
  description = "subnet id donde se desplegará el endpoint type VPC"
  type        = list(string)
}

variable "network_interface_id_sftp" {
  description = "ENI asociada al SFTP Server"
  type        = string
}

variable "s3_bucket_name" {
  description = "Transfer Server S3 bucket name"
  type        = string
}
