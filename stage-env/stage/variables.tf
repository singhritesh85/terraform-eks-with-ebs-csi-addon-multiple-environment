variable "region" {
  type = string
  description = "Provide the AWS Region into which EKS Cluster to be created"
}

variable "subnet_ids" {
  type    = list
  description = "Provide the VPC Subnet IDs"
}

variable "eks_cluster" {
  type     = string
  description = "Provide the EKS Cluster Name"
}

variable "eks_iam_role_name" {
  type = string
  description = "Provide the EKS IAM Role Name"
}

variable "node_group_name" {
  type = string
  description = "Provide the Node Group Name"
}

variable "eks_nodegrouprole_name" {
  type = string
  description = "Provide the Node Group Role Name"
}

variable "launch_template_name" {
  type = string
  description = "Provide the Launch Template Name"
}

#variable "eks_ami_id" {
#  type = list
#  description = "Provide the EKS AMI ID"
#}

variable "instance_type" {
  type = list
  description = "Provide the Instance Type EKS Worker Node" 
}

variable "disk_size" {
  type = number
  description = "Provide the EBS Disk Size"
}

variable "capacity_type" {
  type = list
  description = "Provide the Capacity Type of Worker Node"
}

variable "ami_type" {
  type = list
  description = "Provide the AMI Type"
}

variable "release_version" {
  type = list
  description = "AMI version of the EKS Node Group"
}

variable "kubernetes_version" {
  type = list
  description = "Desired Kubernetes master version."
}

variable "env" {
  type = list
  description = "Provide the Environment for EKS Cluster and NodeGroup"
}

variable "ebs_csi_name" {
  type = string
  description = "Provide the addon name"
}

variable "ebs_csi_version" {
  type = string
  description = "Provide the ebs csi driver version"
}
