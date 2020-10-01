resource "aws_eip" "natgw" {
  vpc      = true
}
 
resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.natgw.id
  subnet_id = aws_subnet.public[0].id
  tags = {
    Name = "EKSTerraform-natgw"
  }
  depends_on = [ aws_internet_gateway.igw ]
}
