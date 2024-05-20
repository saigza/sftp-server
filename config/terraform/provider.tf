# Docs: https://www.terraform.io/docs/providers/aws/index.html
#
# If AWS_PROFILE and AWS_REGION is set, then the provider is optional.  Here's an example anyway:
#
# provider "aws" {
#   region = "us-east-1"
# }

provider "aws" {
  alias  = "auronix"
  region = "us-west-1"
}

provider "aws" {
  alias  = "gestii"
  region = "us-west-1"
  assume_role {
   role_arn = "arn:aws:iam::815057614664:role/auronix-cross-gestii"
  }
}

provider "aws" {
  alias  = "auronix-us-east-1"
  region = "us-east-1"
}

provider "aws" {
  alias  = "auronix-us-west-1"
  region = "us-west-1"
}

provider "archive" {
  # Configuration options
}

provider "random" {
  # Configuration options
}