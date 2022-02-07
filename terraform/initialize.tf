data "template_file" "provision" {
  template = file("${path.module}/init-script.sh")

  vars = {
    database_endpoint = aws_db_instance.default.address
    database_name     = var.database_name
    database_password = var.database_password
    database_user     = var.database_user
    listen_host       = var.listen_host
  }
}