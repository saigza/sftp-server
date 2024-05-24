sftp_name = "SFTP-Server"

region = "us-west-1"

sftp_tags = {
  Owner       = "terraspace",
  Project     = "SFTP Server",
  Environment = "production"
}

subnets_ids = ["subnet-0bbdccb157e13a595", "subnet-04adb826867c24bac"] 

security_group_ids = ["sg-034c58fef7c83bf49"] 
