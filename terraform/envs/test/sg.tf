module "db_security_group" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "db-urlshortner"
  description = "db security group"
  vpc_id      = module.vpc.vpc_id

  # ingress
  ingress_with_cidr_blocks = [
    {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      description = "PostgreSQL access from within VPC"
      cidr_blocks = module.vpc.vpc_cidr_block
    },
  ]

  tags = local.tags
}


module "redis_security_group" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "redis-urlshortner"
  description = "redis security group"
  vpc_id      = module.vpc.vpc_id

  # ingress
  ingress_with_cidr_blocks = [
    {
      from_port   = 6379
      to_port     = 6379
      protocol    = "tcp"
      description = "Redis access from within VPC"
      cidr_blocks = module.vpc.vpc_cidr_block
    },
  ]

  tags = local.tags
}

module "asg_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = local.name
  description = "A security group"
  vpc_id      = module.vpc.vpc_id

  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "http-80-tcp"
      source_security_group_id = module.alb_http_sg.security_group_id
    }
  ]
  number_of_computed_ingress_with_source_security_group_id = 1

  egress_rules = ["all-all"]

  tags = local.tags
}

module "alb_http_sg" {
  source = "terraform-aws-modules/security-group/aws//modules/http-80"

  name        = "${local.name}-alb-http"
  vpc_id      = module.vpc.vpc_id
  description = "Security group for ${local.name}"

  ingress_cidr_blocks = ["0.0.0.0/0"]

  tags = local.tags
}
