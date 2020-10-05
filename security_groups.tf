resource "aws_security_group" "tf-eks-master" {
    name        = "terraform-eks-cluster"
    description = "Cluster communication with worker nodes"
    vpc_id      = aws_vpc.EKSTerraform.id
 
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    tags = {
        Name = "EKSTerraform-master-SG"
    }
}



resource "aws_security_group" "tf-eks-node" {
    name        = "terraform-eks-node"
    description = "Security group for all nodes in the cluster"
    vpc_id      = aws_vpc.EKSTerraform.id

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "EKSTerraform-node-SG"
    }
}


resource "aws_security_group" "tf-eks-lb" {
    name        = "terraform-eks-lb"
    description = "Security group for all NLB"
    vpc_id      = aws_vpc.EKSTerraform.id

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "EKSTerraform-nlb-SG"
    }
}




