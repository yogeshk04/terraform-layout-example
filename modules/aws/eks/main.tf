# Create the EKS cluster
resource "aws_eks_cluster" "eks-cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks.arn

  vpc_config {
    subnet_ids = var.subnets
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks,
    aws_iam_role_policy_attachment.eks_cni,
  ]
}

# Create the IAM role for the EKS cluster
resource "aws_iam_role" "eks" {
  name = "${var.cluster_name}-eks"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

# Attach the necessary policies to the IAM role
resource "aws_iam_role_policy_attachment" "eks" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks.name
}

resource "aws_iam_role_policy_attachment" "eks_cni" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks.name
}

# Create the worker node groups
resource "aws_eks_node_group" "worker_groups" {
  for_each = { for g in var.worker_groups : g["name"] => g }

  cluster_name    = aws_eks_cluster.eks-cluster.name
  node_group_name = each.key

  scaling_config {
    desired_size = each.value["desired_size"]
    max_size     = each.value["max_size"]
    min_size     = each.value["min_size"]
  }

  remote_access {
    ec2_ssh_key              = each.value["ssh_key_name"]
    source_security_group_id = aws_security_group.workers.id
  }

  launch_template {
    id      = aws_launch_template.workers.id
    version = "$Latest"
  }
}

# Create a security group for the worker nodes
resource "aws_security_group" "workers" {
  name_prefix = "${var.cluster_name}-workers-"
  vpc_id      = var.vpc_id
  tags        = var.tags
}

# Create a launch template for the worker nodes
resource "aws_launch_template" "workers" {
  name_prefix = "${var.cluster_name}-workers-"
  image_id    = var.worker
}
