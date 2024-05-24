resource "aws_lambda_layer_version" "lambda_layer" {
  filename   = "${path.module}/files/layer.zip"
  layer_name = "lambda_layer_sftp"

  compatible_runtimes = ["python3.12"]
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sftp.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.sftp.id}/*/${aws_api_gateway_method.get.http_method}${aws_api_gateway_resource.config.path}"
}

resource "aws_lambda_function" "sftp" {
  description      = "A function to lookup and return user data from AWS Secrets Manager."
  filename         = data.archive_file.sftp_lambda.output_path
  function_name    = "${var.name_prefix}-sftp-transfer-server-custom-idp-lambda${var.name_suffix}"
  role             = aws_iam_role.sftp_lambda_role.arn
  handler          = "sftp_lambda.lambda_handler"
  runtime          = "python3.12"
  source_code_hash = filebase64sha256(data.archive_file.sftp_lambda.output_path)
  tracing_config {
    mode = "PassThrough"
  }
  timeouts {}
  environment {
    variables = {
      "SecretsManagerRegion" = var.region
    }
  }
  vpc_config {
     subnet_ids = var.subnets_ids
     security_group_ids = var.security_group_ids
  }
  layers = [
    aws_lambda_layer_version.lambda_layer.arn 
  ]
  tags = merge(
    var.input_tags,
    {
      "Name" = "${var.name_prefix}-sftp-transfer-server-custom-idp-lambda${var.name_suffix}"
    },
  )
}

resource "aws_iam_role" "sftp_lambda_role" {
  name               = "${var.name_prefix}-sftp-transfer-server-custom-idp-lambda-role${var.name_suffix}"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
POLICY
  tags = merge(
    var.input_tags,
    {
      "Name" = "${var.name_prefix}-sftp-transfer-server-custom-idp-lambda-role${var.name_suffix}"
    },
  )
}

resource "aws_iam_role_policy" "sftp_lambda_role_policy" {
  name = "LambdaSecretsPolicy"
  role = aws_iam_role.sftp_lambda_role.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
              "logs:CreateLogGroup",
              "logs:CreateLogStream",
              "logs:PutLogEvents",
              "ec2:CreateNetworkInterface",
              "ec2:DescribeNetworkInterfaces",
              "ec2:DescribeSubnets",
              "ec2:DeleteNetworkInterface",
              "ec2:AssignPrivateIpAddresses",
              "ec2:UnassignPrivateIpAddresses"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "kms:Decrypt",
                "kms:DescribeKey"
            ],
            "Effect": "Allow",
            "Resource": "arn:aws:kms:us-west-1:997991941211:key/b42784da-728b-4c78-b049-08a3c8d6c8e1"
                         
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "sftp_lambda_role" {
  role       = aws_iam_role.sftp_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


data "archive_file" "sftp_lambda" {
  type        = "zip"
  source_file = "${path.module}/files/sftp_lambda.py"
  output_path = "${path.module}/files/lambda.zip"
}
