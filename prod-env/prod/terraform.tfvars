###########Provide Parameters for EKS Cluster and NodeGroup########################

region = "us-east-2"
#subnet_ids = ["subnet-7cb8b707", "subnet-c9236e84", "subnet-ad5f95c5"]

subnet_ids = ["subnet-09ed921597be79c28", "subnet-0d3fc1b7cd1587a31", "subnet-00efe21030b91ce5a", "subnet-06c010c9604e2d4fc", "subnet-08b891b9c95f0ed45", "subnet-077d35dc107f1e7bc"]

eks_cluster = "eks-demo-cluster"
eks_iam_role_name = "eks-iam-role"
node_group_name = "eks-nodegroup"
eks_nodegrouprole_name = "eks-nodegroup-role"
launch_template_name = "eks-launch-template"
#eks_ami_id = ["ami-0f5a11c59a157c25a", "ami-076fda1d45f0f46d7"]
instance_type = ["t3.micro", "t3.small", "t3.medium"]
disk_size = "10"
ami_type = ["AL2_x86_64", "CUSTOM"]
release_version = ["1.22.15-20221222", "1.23.16-20230217", "1.24.10-20230217", "1.25.6-20230217", "1.26.12-20240110", "1.27.9-20240110"]
kubernetes_version = ["1.22", "1.23", "1.24", "1.25", "1.26", "1.27"]
capacity_type = ["ON_DEMAND", "SPOT"]
env = ["dev", "stage", "prod"]
ebs_csi_name = "aws-ebs-csi-driver"
ebs_csi_version = "v1.25.0-eksbuild.1"                     ######"v1.21.0-eksbuild.1"
