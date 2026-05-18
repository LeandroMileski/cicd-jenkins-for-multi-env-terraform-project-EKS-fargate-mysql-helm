resource "random_password" "mysql_root" {
  length           = 16
  special          = true
  override_special = "!#$%^&*()-_=+[]"
}

resource "aws_secretsmanager_secret" "mysql_root" {
  name                    = "${var.env_prefix}/mysql/root-password"
  recovery_window_in_days = 7
}

resource "aws_secretsmanager_secret_version" "mysql_root" {
  secret_id     = aws_secretsmanager_secret.mysql_root.id
  secret_string = random_password.mysql_root.result
}