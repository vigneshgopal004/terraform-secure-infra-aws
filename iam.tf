# ----------------------------
# IAM Role for EC2 (SSM only)
# ----------------------------

resource "aws_iam_role" "ec2_ssm_role" {
  name = "secure-prod-ec2-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "secure-prod-ec2-ssm-role"
  }
}

# Attach AWS-managed SSM policy
resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# ----------------------------
# Custom minimal CloudWatch Logs policy
# ----------------------------

resource "aws_iam_policy" "cloudwatch_logs_policy" {
  name        = "secure-prod-ec2-cloudwatch-logs"
  description = "Allow EC2 to write logs to CloudWatch"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cloudwatch_logs_attach" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = aws_iam_policy.cloudwatch_logs_policy.arn
}

# ----------------------------
# EC2 Instance Profile
# ----------------------------

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "secure-prod-ec2-profile"
  role = aws_iam_role.ec2_ssm_role.name
}
