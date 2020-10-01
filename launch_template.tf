locals {
  tf-eks-node-userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.tf_eks.endpoint}' --b64-cluster-ca '${aws_eks_cluster.tf_eks.certificate_authority.0.data}' '${aws_eks_cluster.tf_eks.name}'
USERDATA
}


resource "aws_launch_template" "custom" {
  name = "lt-eks-custom"
  image_id = "ami-04c7c12b7aab0bb46"
  instance_type = "t3.small"
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 20
      volume_type = "gp2"
      delete_on_termination = true
    }
  }
  network_interfaces {
    security_groups = [ aws_security_group.tf-eks-node.id ]
  }
    

#  iam_instance_profile {
#    name = aws_iam_instance_profile.node.name
#  }


    tags = {
      "eks:cluster-name" = "EKS-Terraform-cluster"
      "eks:nodegroup-name" = "aws-managed-node-group-ami"
    }

  user_data =  base64encode(local.tf-eks-node-userdata)

}

