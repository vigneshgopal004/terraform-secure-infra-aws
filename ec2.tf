# ----------------------------
# Security Group for EC2
# ----------------------------
resource "aws_security_group" "ec2_sg" {
  name        = "secure-prod-ec2-sg"
  description = "Allow HTTP only from ALB"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "HTTP from ALB only"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    description = "Outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "secure-prod-ec2-sg"
  }
}

# ----------------------------
# EC2 Instance (Private, SSM-only)
# ----------------------------
resource "aws_instance" "app" {
  ami                         = "ami-0f5ee92e2d63afc18" # Amazon Linux 2 (ap-south-1)
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.private_1.id
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  associate_public_ip_address = false

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "Secure Production EC2 via ALB" > /var/www/html/index.html
              EOF

  tags = {
    Name = "secure-prod-ec2"
  }
}

# ----------------------------
# Attach EC2 to ALB Target Group
# ----------------------------
resource "aws_lb_target_group_attachment" "app_attach" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.app.id
  port             = 80
}

