variable "region" {
  type    = string
  description = "Provide the AWS Region into which the EKS Nodegroup to be created" 
}

variable "subnet_ids" {
  type    = list
  description = "Provide the VPC Subnet IDs"
}

variable "eks_cluster" {
  type     = string
  description = "Provide the EKS Cluster Name"
}

#variable "eks_iam_role_name" {
#  type = string
#  description = "Provide the EKS IAM Role Name"
#}

variable "node_group_name2" {
  type = string
  description = "Provide the Node Group Name"
}

variable "eks_nodegrouprole_name" {
  type = string
  description = "Provide the Node Group Role Name"
}

variable "launch_template_name" {
  type = string
  description = "Provide the Launch Template Name for Extra Node Group"
}

variable "eks_cluster_name" {
  type = string
  description = "Provide the EKS Cluster Name"
}

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

variable "env" {
  type = list
  description = "Provide the Name of Environment for Extra NodeGroup"
}
