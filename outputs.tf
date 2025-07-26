output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "private_subnets" {
  description = "IDs of private subnets"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "IDs of public subnets"
  value       = module.vpc.public_subnets
}

output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_security_group_id" {
  description = "Security group ID of the EKS cluster"
  value       = module.eks.cluster_security_group_id
}

output "eks_node_group_role_arn" {
  description = "IAM role ARN of the worker node group"
  value       = module.eks.eks_managed_node_groups["node_group"].iam_role_arn
}
