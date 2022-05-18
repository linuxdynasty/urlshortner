module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = local.name


  create_db_option_group    = false
  create_db_parameter_group = false

  create_random_password = true

  # All available versions: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_PostgreSQL.html#PostgreSQL.Concepts
  engine               = "postgres"
  engine_version       = "14.1"
  family               = "postgres14" # DB parameter group
  major_engine_version = "14"         # DB option group
  instance_class       = "db.t3a.large"

  allocated_storage = 20

  db_name  = local.name
  username = "dev"
  port     = 5432

  vpc_security_group_ids = [module.db_security_group.security_group_id]
  subnet_ids             = module.vpc.public_subnets

  maintenance_window      = "Mon:00:00-Mon:03:00"
  backup_window           = "03:00-06:00"
  backup_retention_period = 0

  tags = local.tags
  depends_on = [
    module.vpc
  ]

}
