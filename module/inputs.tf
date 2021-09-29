variable "aws_region" { type = string }
variable "instance_type" { type = string }
variable "purpose" { type = string }
variable "unique_id" { type = string }

locals {
  tags = {
    "Purpose"   = var.purpose
    "Component" = "helloworld Server"
    "CreatedBy" = "Terraform"
  }
  ec2_tags = merge(local.tags,
    {
      "Name"        = "${local.name}-server"
      "Description" = "Instance running a helloworld server"
    }
  )
  port = 3000
  name = var.purpose != "prod" ? "helloworld-${var.purpose}${var.unique_id}" : "helloworld"
}
