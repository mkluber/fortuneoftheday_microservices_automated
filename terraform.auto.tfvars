region = "eu-central-1"

cidr = "137.137.0.0/16"
azs = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
public_subnets = ["137.137.1.0/24", "137.137.2.0/24", "137.137.3.0/24"]
private_subnets = ["137.137.11.0/24", "137.137.22.0/24", "137.137.33.0/24"]
vpc_name = "fortunevpc"
default_route_table_name = "fortuneroute"
dynamodb_table_name = "Fortunes"
dynamodb_table_hash_key = "FortuneName"
dynamodb_table_range_key = "FortuneOrigin"

availability_zones = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]

namespace = "eg"
stage = "test"
name = "eb-env"
appname = "fortuneapp"
description = "Terraform Fortune App"

tier = "WebServer"

environment_type = "LoadBalanced"

loadbalancer_type = "application"

availability_zone_selector = "Any 3"

instance_type = "t2.micro"

autoscale_min = 1

autoscale_max = 2

wait_for_ready_timeout = "20m"

force_destroy = true

rolling_update_enabled = true

rolling_update_type = "Health"

updating_min_in_service = 0

updating_max_batch = 1

healthcheck_url = "/"

application_port = 80

root_volume_size = 8

root_volume_type = "gp3"

autoscale_measure_name = "CPUUtilization"

autoscale_statistic = "Average"

autoscale_unit = "Percent"

autoscale_lower_bound = 20

autoscale_lower_increment = -1

autoscale_upper_bound = 80

autoscale_upper_increment = 1

elb_scheme = "public"

// https://docs.aws.amazon.com/elasticbeanstalk/latest/platforms/platforms-supported.html
// https://docs.aws.amazon.com/elasticbeanstalk/latest/platforms/platforms-supported.html#platforms-supported.docker
solution_stack_name = "64bit Amazon Linux 2023 v4.0.7 running Python 3.11"

version_label = "fortuneapp_version_label"

dns_domain = "outworldindustries.com"
dns_zone_id = "Z01280511PKX9H52OLIQH"
dns_subdomain = "api"
loadbalancer_ssl_policy = "ELBSecurityPolicy-TLS13-1-2-2021-06"

// https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html
additional_settings = [
  {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "StickinessEnabled"
    value     = "false"
  },
  {
    namespace = "aws:elasticbeanstalk:managedactions"
    name      = "ManagedActionsEnabled"
    value     = "false"
  }
]

env_vars = {
  "DB_HOST"         = "xxxxxxxxxxxxxx"
  "DB_USERNAME"     = "yyyyyyyyyyyyy"
  "DB_PASSWORD"     = "zzzzzzzzzzzzzzzzzzz"
  "ANOTHER_ENV_VAR" = "123456789"
}

s3_bucket_versioning_enabled = false
enable_loadbalancer_logs     = false


s3_bucket_name = "fortuneappsource"
s3_file_name = "fortuneapp.zip"
s3_file_source = "package/fortunefile.zip"