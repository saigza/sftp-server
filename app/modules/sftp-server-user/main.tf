resource "random_password" "password" {
  length           = 8
  special          = true
  override_special = "#!*()-_=+?"
}

resource "vault_kv_secret_v2" "secret" {
  mount               = var.vault_mount_path
  name                = "${var.vault_path}/${var.user_name}"
  delete_all_versions = false
  data_json = jsonencode(
    {
      Password      = random_password.password.result,
      Role = var.read_only ? var.role_read_arn : var.role_write_arn,
      Policy = templatefile("${path.module}/templates/policy/user_policy.tftpl",
          {
            s3_bucket = var.s3_bucket_name
            user_home = var.user_home
          })
      HomeDirectory = "/${var.s3_bucket_name}/${var.user_home}"
    }
  )
  depends_on = [
    random_password.password
  ]
}
