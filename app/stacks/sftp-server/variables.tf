variable "sftp_name" {
  description = "Nombre del server SFTP en Transfer Family service"
  type        = string
}

variable "region" {
  description = "Region de AWS donde se desplegará la infraestructura"
  type        = string
}

variable "sftp_tags" {
  description = "SFTP Tags"
  type        = map(string)
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
  description = "Id de la asignacion de la ip elastica y su respectiva ENI"
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
