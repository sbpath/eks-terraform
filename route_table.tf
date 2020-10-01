resource "aws_route_table" "private" {
  vpc_id = aws_vpc.EKSTerraform.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw.id
  }
  tags = {
    Name = "EKSTerraform-privateroute"
  }
}
 
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.EKSTerraform.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "EKSTerraform-publicroute"
  }
}
