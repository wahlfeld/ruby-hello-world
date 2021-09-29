#tfsec:ignore:AWS002
resource "aws_s3_bucket" "helloworld" {
  #checkov:skip=CKV_AWS_18:Access logging is an extra cost and unecessary for this implementation
  #checkov:skip=CKV_AWS_144:Cross-region replication is an extra cost and unecessary for this implementation
  #checkov:skip=CKV_AWS_52:MFA delete is unecessary for this implementation
  bucket_prefix = local.name
  acl           = "private"
  tags          = local.tags
  versioning { enabled = true }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
      }
    }
  }
}

resource "aws_s3_bucket_policy" "helloworld" {
  bucket = aws_s3_bucket.helloworld.id
  policy = jsonencode({
    Version : "2012-10-17",
    Id : "PolicyForHelloWorldServer",
    Statement : [
      {
        Effect : "Allow",
        Principal : {
          "AWS" : aws_iam_role.helloworld.arn
        },
        Action : [
          "s3:Get*",
          "s3:List*"
        ],
        Resource : "arn:aws:s3:::${aws_s3_bucket.helloworld.id}/*"
      }
    ]
  })

  # https://github.com/hashicorp/terraform-provider-aws/issues/7628
  depends_on = [aws_s3_bucket_public_access_block.helloworld]
}

resource "aws_s3_bucket_public_access_block" "helloworld" {
  bucket = aws_s3_bucket.helloworld.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_object" "helloworld" {
  for_each = fileset("${path.module}/local/src", "*")

  bucket         = aws_s3_bucket.helloworld.id
  key            = each.value
  content_base64 = base64encode(file("${path.module}/local/src/${each.value}"))
}

output "bucket_id" {
  value = aws_s3_bucket.helloworld.id
}
