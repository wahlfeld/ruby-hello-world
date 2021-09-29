data "aws_caller_identity" "current" {}

resource "aws_iam_role" "helloworld" {
  name = "${local.name}-server"
  assume_role_policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Action : "sts:AssumeRole",
        Principal : {
          Service : "ec2.amazonaws.com"
        },
        Effect : "Allow",
        Sid : ""
      }
    ]
  })
  tags = local.tags
}

resource "aws_iam_instance_profile" "helloworld" {
  role = aws_iam_role.helloworld.name
}

resource "aws_iam_policy" "helloworld" {
  name        = "${local.name}-server"
  description = "Allows the helloworld server to interact with various AWS services"
  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Effect : "Allow",
        Action : [
          "s3:Get*",
          "s3:List*"
        ],
        Resource : [
          "arn:aws:s3:::${aws_s3_bucket.helloworld.id}",
          "arn:aws:s3:::${aws_s3_bucket.helloworld.id}/"
        ]
      },
      {
        Effect : "Allow",
        Action : ["ec2:DescribeInstances"],
        Resource : ["*"]
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "helloworld" {
  role       = aws_iam_role.helloworld.name
  policy_arn = aws_iam_policy.helloworld.arn
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.helloworld.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
