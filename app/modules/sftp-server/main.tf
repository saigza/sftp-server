data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

resource "aws_iam_role" "sftp_transfer_server" {
  name = "${var.name_prefix}-sftp-transfer-server-iam-role${var.name_suffix}"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Principal": {
            "Service": "transfer.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
        }
    ]
}
EOF
  tags = merge(
    var.input_tags,
    {
      "Name" = "${var.name_prefix}-sftp-transfer-server-invocation-iam-role${var.name_suffix}"
    },
  )
}

resource "aws_iam_role_policy" "sftp_transfer_server" {
  name = "${var.name_prefix}-sftp-transfer-server-iam-policy${var.name_suffix}"
  role = aws_iam_role.sftp_transfer_server.id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Sid": "AllowFullAccesstoCloudWatchLogs",
        "Effect": "Allow",
        "Action": [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "logs:PutLogEvents",
          "logs:GetLogEvents",
          "logs:FilterLogEvents"
        ],
        "Resource": "*"
        }
    ]
}
POLICY
}

resource "aws_iam_role" "sftp_transfer_server_invocation" {
  name = "${var.name_prefix}-sftp-transfer-server-invocation-iam-role${var.name_suffix}"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Principal": {
            "Service": "transfer.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
        }
    ]
}
EOF
  tags = merge(
    var.input_tags,
    {
      "Name" = "${var.name_prefix}-sftp-transfer-server-invocation-iam-role${var.name_suffix}"
    },
  )
}

resource "aws_iam_role_policy" "sftp_transfer_server_invocation" {
  name = "${var.name_prefix}-sftp-transfer-server-invocation-iam-policy${var.name_suffix}"
  role = aws_iam_role.sftp_transfer_server_invocation.id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "execute-api:Invoke"
            ],
            "Resource": "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.sftp.id}/${aws_api_gateway_stage.prod.stage_name}/${aws_api_gateway_method.get.http_method}/*",
            "Effect": "Allow"
        },
         {
            "Action": [
                "apigateway:GET"
            ],
            "Resource": "*",
            "Effect": "Allow"
        }
    ]
}
POLICY
}

resource "aws_transfer_server" "sftp_transfer_server" {
  identity_provider_type = "API_GATEWAY"
  logging_role           = aws_iam_role.sftp_transfer_server.arn
  invocation_role        = aws_iam_role.sftp_transfer_server_invocation.arn
  url                    = aws_api_gateway_stage.prod.invoke_url

  endpoint_type = "VPC"
  endpoint_details {
    vpc_id                 = var.vpc_id_endpoint
    subnet_ids             = var.subnets_ids_endpoint
    security_group_ids     = [aws_security_group.sftp_sg.id]
    address_allocation_ids = var.address_allocation_ids_endpoint
  }

  tags = merge(
    var.input_tags,
    {
      "Name" = "${var.name_prefix}-sftp-transfer-server${var.name_suffix}"
    },
  )

  depends_on = [aws_security_group.sftp_sg]
}

# Security group for SFTP Server (if not existing)
resource "aws_security_group" "sftp_sg" {
  name        = "sftp_alterno_sg"
  description = "Allow SFTP traffic in ports 22 and 2222"
  vpc_id      = var.vpc_id_endpoint

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 2222
    to_port     = 2222
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sftp_sg"
  }
}

resource "aws_iam_role" "sftp_transfer_server_role_read" {
  name = "${var.name_prefix}-sftp-transfer-server-read-role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "transfer.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
  tags = {
      "Name" = "${var.name_prefix}-sftp-transfer-server-read-role"
  }
}

resource "aws_iam_role_policy" "sftp_transfer_server_policy_read" {
  name = "${var.name_prefix}-sftp-transfer-server-policy-read"
  role = aws_iam_role.sftp_transfer_server_role_read.id

  policy = templatefile("${path.module}/templates/policy/read-only.tftpl",
  {
  s3_bucket = var.s3_bucket_name
  })
}

resource "aws_iam_role" "sftp_transfer_server_role_write" {
  name = "${var.name_prefix}-sftp-transfer-server-write-role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "transfer.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
  tags = {
      "Name" = "${var.name_prefix}-sftp-transfer-server-write-role"
    }
}

resource "aws_iam_role_policy" "sftp_transfer_server_policy_write" {
  name = "${var.name_prefix}-sftp-transfer-server-policy-write"
  role = aws_iam_role.sftp_transfer_server_role_write.id

  policy = templatefile("${path.module}/templates/policy/read-write.tftpl",
  {
  s3_bucket = var.s3_bucket_name
  })
}
