resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.EKSTerraform.id
 
  tags = {
    "Name" = "EKSTerraform_igw"
  }
}
