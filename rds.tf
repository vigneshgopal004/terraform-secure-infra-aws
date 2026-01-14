# ----------------------------
# RDS Subnet Group (Private only)
# ----------------------------
resource "aws_db_subnet_group" "db_subnets" {
  name = "secure-prod-db-subnets"
  subnet_ids = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id
  ]

  tags = {
    Name = "secure-prod-db-subnets"
  }
}

# ----------------------------
# Security Group for RDS
# ----------------------------
resource "aws_security_group" "rds_sg" {
  name        = "secure-prod-rds-sg"
  description = "Allow DB access only from EC2"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "MySQL from EC2 only"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]
  }

  egress {
    description = "Outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "secure-prod-rds-sg"
  }
}

# ----------------------------
# RDS Instance (Private)
# ----------------------------
resource "aws_db_instance" "db" {
  identifier        = "secure-prod-db"
  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  storage_type      = "gp2"

  db_name  = "securedb"
  username = "adminuser"
  password = "ChangeThisPassword123!" # demo only

  db_subnet_group_name   = aws_db_subnet_group.db_subnets.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  publicly_accessible    = false
  skip_final_snapshot    = true
  deletion_protection    = false
  multi_az               = false

  tags = {
    Name = "secure-prod-db"
  }
}

