# --- VPC Creation ---
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.0"

  name = "${var.cluster_name}-vpc"
  cidr = var.vpc_cidr

  azs             = ["${var.aws_region}a", "${var.aws_region}b"]
  private_subnets = var.private_subnet_cidrs
  public_subnets  = var.public_subnet_cidrs

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true

   # 👇 Required tags for EKS to use subnets
  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = "1"
  }

  tags = {
    Name        = "${var.cluster_name}-vpc"
    Terraform   = "true"
    Environment = "dev"
  }
}

# --- EKS Cluster ---
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.0"

  cluster_name                    = var.cluster_name
  cluster_version                 = "1.29"
  cluster_endpoint_public_access  = true

  vpc_id      = module.vpc.vpc_id
  subnet_ids  = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.private_subnets

  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {
    node_group = {
      desired_size = var.desired_capacity
      min_size     = var.min_size
      max_size     = var.max_size
      instance_types = [var.node_instance_type]
      subnets        = module.vpc.private_subnets
      create_timeout = "60m"

      iam_role_additional_policies = {
      AmazonEKSWorkerNodePolicy           = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
      AmazonEKS_CNI_Policy                = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
      AmazonEC2ContainerRegistryReadOnly  = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    }
  }
}
  tags = {
    Name        = var.cluster_name
    Environment = "dev"
    Terraform   = "true"
  }
}
