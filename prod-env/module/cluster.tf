# EKS CLuster Definition
#-----------------------

resource "aws_eks_cluster" "eksdemo" {
  name     = "${var.eks_cluster}-${var.env}"
  role_arn = aws_iam_role.eksdemorole.arn
  version = var.kubernetes_version[5] 

  vpc_config {
    subnet_ids = var.subnet_ids
#    subnet_ids = ["subnet-05dd16bc3a73a55ad", "subnet-0ff097df94318f90d", "subnet-06fb9c70358c599e2", "subnet-0a8f252083967e8ba", "subnet-075a21d1c5d03c63d", "subnet-0c6da32ab01e5a2f2" ]                ##### Private and Public Subnet List for Private EKS    
  }

  tags = {
    Environment = var.env     ##"Dev"
    Owner       = "Ops"
    Billing     = "MyProject"
  } 

  depends_on = [
    aws_iam_role_policy_attachment.eksdemorole-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eksdemorole-AmazonEKSVPCResourceController,
  ]
}


#-------------------------
# IAM Role for EKS Cluster
#-------------------------

resource "aws_iam_role" "eksdemorole" {
  name = "${var.eks_iam_role_name}-${var.env}"

  assume_role_policy = file("trust-relationship.json")
  
  tags = {
    Environment = var.env     ##"Dev"
    Owner       = "Ops"
    Billing     = "MyProject"
  }
}

resource "aws_iam_role_policy_attachment" "eksdemorole-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eksdemorole.name
}

resource "aws_iam_role_policy_attachment" "eksdemorole-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eksdemorole.name
}

#--------------------------------------
# Enabling IAM Role for Service Account
#--------------------------------------

data "tls_certificate" "ekstls" {
  url = aws_eks_cluster.eksdemo.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eksopidc" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.ekstls.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.eksdemo.identity[0].oidc[0].issuer
}

data "aws_iam_policy_document" "eksdoc_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eksopidc.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-node"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eksopidc.arn]
      type        = "Federated"
    }
  }
}

#------------------------------------------
#Create Launch Template for EKS Worker Node
#------------------------------------------

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
      kms_key_id = "arn:aws:kms:us-east-2:027330342406:key/d387bfc3-9214-4414-b2eb-8786965c2619"     ### Provide the kms_key_id for your AWS Account.
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Environment = var.env        ##"Dev"
      Owner       = "Ops"
      Billing     = "MyProject"
      "kubernetes.io/cluster/${var.eks_cluster}-${var.env}" = "owned"
    }
  }
  
  tag_specifications {
     resource_type = "volume"
     tags = {
       Environment = var.env       ##"Dev"
       Owner       = "Ops"
       Billing     = "MyProject"
       "kubernetes.io/cluster/${var.eks_cluster}-${var.env}" = "owned"
    }
  } 

#  user_data = filebase64("user_data.sh")

#  user_data = base64encode(templatefile("userdata.tpl", { CLUSTER_NAME = aws_eks_cluster.cluster.name, B64_CLUSTER_CA = aws_eks_cluster.cluster.certificate_authority[0].data, API_SERVER_URL = aws_eks_cluster.cluster.endpoint }))
  
  depends_on = [ aws_eks_cluster.eksdemo ]

}


#-------------------------
# Creating the Worker Node
#-------------------------

resource "aws_eks_node_group" "eksnode" {
  cluster_name    = "${var.eks_cluster}-${var.env}"
  node_group_name = "${var.node_group_name}-${var.env}"
  node_role_arn   = aws_iam_role.eksnoderole.arn
  subnet_ids      = ["subnet-06c010c9604e2d4fc", "subnet-08b891b9c95f0ed45", "subnet-077d35dc107f1e7bc"]      #var.subnet_ids
  
#  subnet_ids = ["subnet-05dd16bc3a73a55ad", "subnet-0ff097df94318f90d", "subnet-06fb9c70358c599e2"]    #### Private Subnet List for Private EKS NodeGroup  
  
#  instance_types  = [ var.instance_types[1] ]
#  disk_size       = var.disk_size
  ami_type        = var.ami_type[0]
  capacity_type   = var.capacity_type[0]
  release_version = var.release_version[5] 

  tags = {
    Environment = var.env        ##"Dev"
    Owner       = "Ops"
    Billing     = "MyProject"
  }
  
  launch_template {
    id      = aws_launch_template.eks_launch_template.id
    version = "$Latest"                  ##aws_launch_template.eks_launch_template.version
#    name    = var.launch_template_name
  } 

  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 2
  }

  update_config {
    max_unavailable = 2
  }

  depends_on = [
    aws_launch_template.eks_launch_template,
    aws_iam_role.eksnoderole,
    aws_eks_cluster.eksdemo,
    aws_iam_role_policy_attachment.eksnode-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eksnode-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eksnode-AmazonEC2ContainerRegistryReadOnly,
  ]
}

#----------------------------
# IAM Role for EKS Node Group
#----------------------------

resource "aws_iam_role" "eksnoderole" {
  name = "${var.eks_nodegrouprole_name}-${var.env}"

  assume_role_policy = file("trust-relationship-nodegroup.json")              ## This is the trust relationship for IAM Role.

  inline_policy {                                                             ## This is the inline policy for autoscaling attached with the IAM Role.
    name = "autoscale_inline_policy-${var.env}"
    policy = file("autoscalepolicy.json")
  }
  tags = {
    Environment = var.env        ##"Dev"
    Owner       = "Ops"
    Billing     = "MyProject"
  }
}

resource "aws_iam_role_policy_attachment" "eksnode-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eksnoderole.name
}

resource "aws_iam_role_policy_attachment" "eksnode-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eksnoderole.name
}

resource "aws_iam_role_policy_attachment" "eksnode-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eksnoderole.name
}


#---------------------------------------
# create EKS EBS CSI Driver Add ons
#---------------------------------------

data "aws_iam_policy_document" "csi" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eksopidc.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eksopidc.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "eks_ebs_csi_driver" {
  assume_role_policy = data.aws_iam_policy_document.csi.json
  name               = "eks-ebs-csi-driver-${var.env}"
  
  tags = {
    Environment = var.env        ##"Dev"
    Owner       = "Ops"
    Billing     = "MyProject"
  }

}

resource "aws_iam_role_policy_attachment" "amazon_ebs_csi_driver" {
  role       = aws_iam_role.eks_ebs_csi_driver.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

resource "aws_iam_policy" "eks_ebs_csi_driver_kms" {
  name        = "KMS_Key_For_Encryption_On_EBS_Policy-${var.env}"
  description = "Policy to encrypt ebs volume created using ebs csi driver"
  policy = file("kms-key-for-encryption-on-ebs.json")   

  tags = {
    Environment = var.env        ##"Dev"
    Owner       = "Ops"
    Billing     = "MyProject"
  }
}

resource "aws_iam_role_policy_attachment" "amazon_ebs_csi_driver_kms" {
   role       = aws_iam_role.eks_ebs_csi_driver.name
   policy_arn = aws_iam_policy.eks_ebs_csi_driver_kms.arn
}

resource "aws_eks_addon" "ebs_csi_driver" {
  cluster_name      = aws_eks_cluster.eksdemo.id
  addon_name        = var.ebs_csi_name
  addon_version     = var.ebs_csi_version
  service_account_role_arn = aws_iam_role.eks_ebs_csi_driver.arn
  resolve_conflicts_on_create = "OVERWRITE"     # use resolve_conflicts_on_update for updating a kubernetes cluster  #resolve_conflicts = "OVERWRITE"

  depends_on = [
    aws_eks_cluster.eksdemo,
    aws_eks_node_group.eksnode
  ]
  
  tags = {
    Environment = var.env        ##"Dev"
    Owner       = "Ops"
    Billing     = "MyProject"
  }
}
