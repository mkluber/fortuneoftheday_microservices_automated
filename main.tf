provider "aws" {
  region = var.region
}

module "dynamodb-table" {
  source  = "terraform-aws-modules/dynamodb-table/aws"


  name                        = var.dynamodb_table_name
  hash_key                    = var.dynamodb_table_hash_key
  range_key                   = var.dynamodb_table_range_key
  table_class                 = "STANDARD"
  deletion_protection_enabled = false

  attributes = [
    {
      name = var.dynamodb_table_hash_key
      type = "S"
    },
    {
      name = var.dynamodb_table_range_key
      type = "S"
    }
  ]

  tags = {
    Terraform   = "true"
    Environment = "staging"
  }
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_name
  cidr = var.cidr

  azs             = var.azs
  public_subnets = var.public_subnets
  create_igw = "true"
  default_route_table_name = var.default_route_table_name
  map_public_ip_on_launch = "true"
}

module "elastic-beanstalk-application" {
  source  = "cloudposse/elastic-beanstalk-application/aws"
  version = "0.11.1"

  name = var.appname

}

module "elastic-beanstalk-environment" {
  source  = "cloudposse/elastic-beanstalk-environment/aws"
  version = "0.51.2"

  description                = var.description
  region                     = var.region
  availability_zone_selector = var.availability_zone_selector
  dns_zone_id                = var.dns_zone_id
  dns_subdomain              = var.dns_subdomain

  wait_for_ready_timeout             = var.wait_for_ready_timeout
  elastic_beanstalk_application_name = var.appname
  environment_type                   = var.environment_type
  loadbalancer_type                  = var.loadbalancer_type
  elb_scheme                         = var.elb_scheme
  tier                               = var.tier
  #version_label                      = var.version_label
  force_destroy                      = var.force_destroy

  instance_type    = var.instance_type
  root_volume_size = var.root_volume_size
  root_volume_type = var.root_volume_type

  autoscale_min             = var.autoscale_min
  autoscale_max             = var.autoscale_max
  autoscale_measure_name    = var.autoscale_measure_name
  autoscale_statistic       = var.autoscale_statistic
  autoscale_unit            = var.autoscale_unit
  autoscale_lower_bound     = var.autoscale_lower_bound
  autoscale_lower_increment = var.autoscale_lower_increment
  autoscale_upper_bound     = var.autoscale_upper_bound
  autoscale_upper_increment = var.autoscale_upper_increment

  namespace = var.namespace
  stage = var.stage
  name = var.name

  vpc_id               = module.vpc.vpc_id
  loadbalancer_subnets = module.vpc.public_subnets
  application_subnets  = module.vpc.private_subnets
  loadbalancer_redirect_http_to_https = true
  enable_loadbalancer_logs = false

  allow_all_egress = true

  # additional_security_group_rules = [
  #   {
  #     type                     = "ingress"
  #     from_port                = 0
  #     to_port                  = 65535
  #     protocol                 = "-1"
  #     source_security_group_id = module.vpc.vpc_default_security_group_id
  #     description              = "Allow all inbound traffic from trusted Security Groups"
  #   }
  # ]

  rolling_update_enabled  = var.rolling_update_enabled
  rolling_update_type     = var.rolling_update_type
  updating_min_in_service = var.updating_min_in_service
  updating_max_batch      = var.updating_max_batch

  healthcheck_url  = var.healthcheck_url
  application_port = var.application_port

  solution_stack_name = var.solution_stack_name    
  additional_settings = var.additional_settings
  env_vars            = var.env_vars

  extended_ec2_policy_document = data.aws_iam_policy_document.fortune_dynamodb_permissions.json
  prefer_legacy_ssm_policy     = false
  prefer_legacy_service_policy = false
  scheduled_actions            = var.scheduled_actions

#  context = module.this.context
}

data "aws_iam_policy_document" "fortune_dynamodb_permissions" {
    statement {
      sid = "fortuneDynamodbPermissions"
      actions = [
                "dynamodb:PutItem",
                "dynamodb:DescribeTable",
                "dynamodb:DeleteItem",
                "dynamodb:GetItem",
                "dynamodb:Scan",
                "dynamodb:Query",
                "dynamodb:UpdateItem"
    ]
    resources = ["${module.dynamodb-table.dynamodb_table_arn}"]
  }
}