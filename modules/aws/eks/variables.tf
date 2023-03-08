variable "cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
}

variable "region" {
  description = "The AWS region."
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC where the EKS cluster will be created."
  type        = string
}

variable "subnets" {
  description = "A list of subnet IDs where the EKS worker nodes will be launched."
  type        = list(string)
}

variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
}

variable "worker_groups" {
  description = "A list of maps defining worker group configurations for the EKS cluster."
  type        = list(map(string))
}
