# ----------------------------
# Elastic IP for NAT Gateway
# ----------------------------
resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "secure-prod-nat-eip"
  }
}

# ----------------------------
# NAT Gateway (Public Subnet)
# ----------------------------
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_1.id

  tags = {
    Name = "secure-prod-nat"
  }

  depends_on = [aws_internet_gateway.igw]
}

# ----------------------------
# Private Route → NAT Gateway
# ----------------------------
resource "aws_route" "private_nat_route" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}
