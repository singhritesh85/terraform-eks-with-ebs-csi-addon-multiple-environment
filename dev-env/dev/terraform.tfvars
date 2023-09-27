###########Provide Parameters for EKS Cluster and NodeGroup########################

region = "us-east-2"
#subnet_ids = ["subnet-7cb8b707", "subnet-c9236e84", "subnet-ad5f95c5"]

subnet_ids = ["subnet-04717310fe695afe4", "subnet-0520680d77a2dcf00", "subnet-04a759ed02e64e4ff", "subnet-0c062142bcd14ec0c", "subnet-0bb0d66be2ec68d9e", "subnet-09ef05ad3098820ba"]

eks_cluster = "eks-demo-cluster"
eks_iam_role_name = "eks-iam-role"
node_group_name = "eks-nodegroup"
eks_nodegrouprole_name = "eks-nodegroup-role"
launch_template_name = "eks-launch-template"
#eks_ami_id = ["ami-0f5a11c59a157c25a", "ami-076fda1d45f0f46d7"]
instance_type = ["t3.micro", "t3.small", "t3.medium"]
disk_size = "10"
ami_type = ["AL2_x86_64", "CUSTOM"]
release_version = ["1.22.15-20221222", "1.23.16-20230217", "1.24.10-20230217", "1.25.6-20230217"]
kubernetes_version = ["1.22", "1.23", "1.24", "1.25"]
capacity_type = ["ON_DEMAND", "SPOT"]
env = [ "dev", "stage", "prod" ]
ebs_csi_name = "aws-ebs-csi-driver"
ebs_csi_version = "v1.21.0-eksbuild.1"
