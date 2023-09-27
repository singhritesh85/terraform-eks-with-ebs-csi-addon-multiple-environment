#------------------------------------------------
#Create Launch Template for EKS Extra Worker Node
#------------------------------------------------

resource "aws_launch_template" "eks_launch_template" {
#  image_id               = var.eks_ami_id[1]          ## You can use https://github.com/awslabs/amazon-eks-ami/releases
  instance_type          = var.instance_type[1]
  name                   = "${var.launch_template_name}-${var.env}"
#  update_default_version = true

  key_name = "eks-test"

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = var.disk_size
      encrypted = true
      kms_key_id = "arn:aws:kms:us-east-2:027330342406:key/d387bfc3-9214-4414-b2eb-8786965c2619"            ### Provide the kms_key_id for your AWS Account.
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Environment = var.env       ##"Dev"
      Owner       = "Ops"
      Billing     = "MyProject"
      "kubernetes.io/cluster/${var.eks_cluster_name}-${var.env}" = "owned"
    }
  }

  tag_specifications {
     resource_type = "volume"
     tags = {
       Environment = var.env      ##"Dev"
       Owner       = "Ops"
       Billing     = "MyProject"
       "kubernetes.io/cluster/${var.eks_cluster_name}-${var.env}" = "owned"
    }
  }

#  user_data = filebase64("user_data.sh")

#  user_data = base64encode(templatefile("userdata.tpl", { CLUSTER_NAME = aws_eks_cluster.cluster.name, B64_CLUSTER_CA = aws_eks_cluster.cluster.certificate_authority[0].data, API_SERVER_URL = aws_eks_cluster.cluster.endpoint }))

#  depends_on = [ aws_eks_cluster.eksdemo ]

}

#-------------------------------
# Creating the Extra Worker Node
#-------------------------------

resource "aws_eks_node_group" "eksnodegroup2" {
  cluster_name    = "${var.eks_cluster}-${var.env}"
  node_group_name = "${var.node_group_name2}-${var.env}"
  node_role_arn   = "${var.eks_nodegrouprole_name}-${var.env}"            #aws_iam_role.eksnoderole.arn
  subnet_ids      = var.subnet_ids
  
#  subnet_ids = ["subnet-05dd16bc3a73a55ad", "subnet-0ff097df94318f90d", "subnet-06fb9c70358c599e2"]    #### Private Subnet List For For Private EKS NodeGroup  
  
#  instance_types  = [ var.instance_types[1] ]
#  disk_size       = var.disk_size
  ami_type        = var.ami_type[0]
  capacity_type   = var.capacity_type[0]
  release_version = var.release_version[2]

  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 2
  }
  
  launch_template {
    id      = aws_launch_template.eks_launch_template.id
    version = "$Latest"                  ##aws_launch_template.eks_launch_template.version
#    name    = var.launch_template_name
  }   

  update_config {
    max_unavailable = 2
  }
  
  tags = {
    Environment = var.env              ##"Dev"
    Owner       = "Ops"
    Billing     = "MyProject"
  }

#  depends_on = [
#    aws_iam_role_policy_attachment.eksnode-AmazonEKSWorkerNodePolicy,
#    aws_iam_role_policy_attachment.eksnode-AmazonEKS_CNI_Policy,
#    aws_iam_role_policy_attachment.eksnode-AmazonEC2ContainerRegistryReadOnly,
#  ]
}
