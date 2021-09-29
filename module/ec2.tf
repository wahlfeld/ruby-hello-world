#tfsec:ignore:AWS018
resource "aws_security_group" "ingress" {
  #checkov:skip=CKV2_AWS_5:Broken - https://github.com/bridgecrewio/checkov/issues/1203
  name        = "${local.name}-ingress"
  description = "Security group allowing inbound traffic to the helloworld server"
  tags        = local.tags
}

resource "aws_security_group_rule" "helloworld_ingress" {
  type              = "ingress"
  from_port         = local.port
  to_port           = local.port
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] #tfsec:ignore:AWS006
  security_group_id = aws_security_group.ingress.id
  description       = "Allows traffic to the helloworld server"
}

resource "aws_security_group_rule" "netdata" {
  type              = "ingress"
  from_port         = 19999
  to_port           = 19999
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] #tfsec:ignore:AWS006
  security_group_id = aws_security_group.ingress.id
  description       = "Allows traffic to the Netdata dashboard"
}

resource "aws_security_group_rule" "egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"] #tfsec:ignore:AWS007
  security_group_id = aws_security_group.ingress.id
  description       = "Allow all egress rule for the helloworld server"
}

# for region in $(aws ec2 describe-regions --query 'Regions[].RegionName' --output text); \
#   do aws ec2 describe-images --region $region \
#   --filters "Name=name,Values=amzn2-ami-hvm-2.0.*-x86_64-gp2" \
#   --query 'Images[*].[OwnerId]' --output text | sort | uniq; \
#   done
data "aws_ami" "ami" {
  most_recent = true
  owners = [
    "031439099551",
    "045938549113",
    "137112412989",
    "290363375467",
    "311714370241",
    "350615704893",
    "352987102907",
    "363910846355",
    "388677980418",
    "412214881410",
    "613073146702",
    "657760264309",
    "664341837355",
    "679647293574",
    "729784628845",
    "737229874174",
    "815665286609",
    "829250931565",
    "948170117212",
    "986322425065",
  ]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]
  }
}

resource "aws_spot_instance_request" "helloworld" {
  #checkov:skip=CKV_AWS_126:Detailed monitoring is an extra cost and unecessary for this implementation
  #checkov:skip=CKV_AWS_8:This is not a launch configuration
  #checkov:skip=CKV2_AWS_17:This instance will be placed in the default VPC deliberately
  ami                            = data.aws_ami.ami.id
  instance_type                  = var.instance_type
  ebs_optimized                  = true
  user_data                      = templatefile("${path.module}/local/userdata.sh", { bucket = aws_s3_bucket.helloworld.id })
  iam_instance_profile           = aws_iam_instance_profile.helloworld.name
  vpc_security_group_ids         = [aws_security_group.ingress.id]
  wait_for_fulfillment           = true
  instance_interruption_behavior = "stop"
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
  tags = local.ec2_tags

  depends_on = [aws_s3_bucket_object.helloworld[0]]
}

resource "aws_ec2_tag" "helloworld" {
  for_each = local.ec2_tags

  resource_id = aws_spot_instance_request.helloworld.spot_instance_id
  key         = each.key
  value       = each.value
}

output "instance_id" {
  value = aws_spot_instance_request.helloworld.spot_instance_id
}

output "monitoring_url" {
  value = format("%s%s%s", "http://", aws_spot_instance_request.helloworld.public_dns, ":19999")
}

output "helloworld_url" {
  value = format("%s%s%s", "http://", aws_spot_instance_request.helloworld.public_dns, ":${local.port}/hello-world")
}
