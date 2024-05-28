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
  s3_bucket = var.s3_bucket_name,
  user_home = var.user_home
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

  policy = templatefile("${path.module}/templates/policy/write.tftpl",
  {
  s3_bucket = var.s3_bucket_name,
  user_home = var.user_home
  })
}

resource "random_password" "password" {
  length           = 8
  special          = true
  override_special = "#!*()-_=+?"
}

resource "vault_kv_secret_v2" "secret" {
  mount               = var.vault_mount_path
  name                = "SFTP/${var.vault_path}/${var.sftp_server_users_username}"
  delete_all_versions = false
  data_json = jsonencode(
    {
      username      = var.sftp_server_users_username,
      password      = random_password.password.result,
      role = var.read_only ? aws_iam_role.sftp_transfer_server_role_read.id : aws_iam_role.sftp_transfer_server_role_write.id,
      policy = templatefile("${path.module}/templates/policy/user_policy.tftpl",
          {
            s3_bucket = var.s3_bucket_name
            user_home = var.user_home
          })
      homedirectory = var.user_home
    }
  )
  depends_on = [
    random_password.password
  ]
}
