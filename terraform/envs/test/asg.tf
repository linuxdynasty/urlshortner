module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "v6.3.0"

  # Autoscaling group
  name = local.name

  min_size                  = 1
  max_size                  = 3
  desired_capacity          = 2
  wait_for_capacity_timeout = 0
  health_check_type         = "EC2"
  vpc_zone_identifier       = module.vpc.public_subnets

  instance_refresh = {
    strategy = "Rolling"
    preferences = {
      checkpoint_delay       = 600
      checkpoint_percentages = [35, 70, 100]
      instance_warmup        = 300
      min_healthy_percentage = 50
    }
    triggers = ["tag"]
  }

  # Launch template
  launch_template_name        = local.name
  launch_template_description = local.name
  update_default_version      = true
  user_data                   = data.template_file.userdata.rendered

  image_id          = "ami-0022f774911c1d690"
  instance_type     = "t3.micro"
  ebs_optimized     = true
  enable_monitoring = true

  block_device_mappings = [
    {
      # Root volume
      device_name = "/dev/xvda"
      no_device   = 0
      ebs = {
        delete_on_termination = true
        encrypted             = true
        volume_size           = 20
        volume_type           = "gp2"
      }
    }
  ]

  capacity_reservation_specification = {
    capacity_reservation_preference = "open"
  }

  cpu_options = {
    core_count       = 1
    threads_per_core = 1
  }

  credit_specification = {
    cpu_credits = "standard"
  }

  instance_market_options = {
    market_type = "spot"
    spot_options = {
      block_duration_minutes = 60
    }
  }

  metadata_options = {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 32
  }

  network_interfaces = [
    {
      delete_on_termination = true
      description           = "eth0"
      device_index          = 0
      security_groups       = ["sg-12345678"]
    },
    {
      delete_on_termination = true
      description           = "eth1"
      device_index          = 1
      security_groups       = ["sg-12345678"]
    }
  ]

  placement = {
    availability_zone = "us-west-1b"
  }

  tag_specifications = [
    {
      resource_type = "instance"
      tags          = { WhatAmI = "Instance" }
    },
    {
      resource_type = "volume"
      tags          = { WhatAmI = "Volume" }
    },
    {
      resource_type = "spot-instances-request"
      tags          = { WhatAmI = "SpotInstanceRequest" }
    }
  ]

  tags = {
    Environment = "dev"
    Project     = "megasecret"
  }
}
