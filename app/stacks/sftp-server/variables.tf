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
     type = list(string)
}

variable "security_group_ids" {
     description = "security group ids associate to lambda"
     type = list(string)
}

