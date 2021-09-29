module "main" {
  source = "../module"

  aws_region    = var.aws_region
  instance_type = var.instance_type
  purpose       = var.purpose
  unique_id     = var.unique_id
}

output "monitoring_url" {
  value       = module.main.monitoring_url
  description = "URL to monitor the helloworld Server"
}

output "helloworld_url" {
  value       = module.main.helloworld_url
  description = "URL to the helloworld Server"
}

output "bucket_id" {
  value       = module.main.bucket_id
  description = "The S3 bucket name"
}

output "instance_id" {
  value       = module.main.instance_id
  description = "The EC2 instance ID"
}
