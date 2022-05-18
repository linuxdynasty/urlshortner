data "aws_availability_zones" "azs" {}

data "template_file" "userdata" {
  template = file("./templates/userdata.tpl")
  vars = {
    DB_PASSWORD = module.db.db_instance_password
    DB_HOST     = module.db.db_instance_address
    DB_NAME     = local.name
    DB          = local.name
  }
}
