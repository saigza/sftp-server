sftp_name = "SFTP-Server"

region = "us-west-1"

sftp_tags = {
  Owner       = "terraspace",
  Project     = "SFTP Server",
  Environment = "production"
}

subnets_ids = ["subnet-0bbdccb157e13a595", "subnet-04adb826867c24bac"] 

security_group_ids_lambda = ["sg-034c58fef7c83bf49"] 

vpc_id_endpoint              = "vpc-affe11ca"
subnets_ids_endpoint           = ["subnet-028fb344"]
address_allocation_ids_endpoint= ["eipalloc-09c9ba8ea64abbc1c"]
network_interface_id_sftp      = "eni-0e0358ce9f7c1fc5a"
