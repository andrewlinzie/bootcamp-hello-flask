locals {
  cluster_name = "${var.project_name}-eks"
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.18" # v20+ supports K8s 1.31

  cluster_name                   = local.cluster_name
  cluster_version                = "1.31"
  cluster_endpoint_public_access = true
  enable_irsa                    = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets   # nodes in private subnets (recommended)

  # EKS Addons (managed)
  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    metrics-server = {
      most_recent = true
    }
  }

  # At least one managed node group
  eks_managed_node_groups = {
    default = {
      desired_size = 2
      min_size     = 2
      max_size     = 3

      instance_types = ["t3.medium"] # good for bootcamps
      capacity_type  = "ON_DEMAND"

      subnet_ids = module.vpc.private_subnets

      # Useful tags
      tags = {
        Name    = "${local.cluster_name}-ng"
        Project = var.project_name
      }
    }
  }

  tags = {
    Project = var.project_name
  }
}

# Helpful data for kubeconfig later
data "aws_eks_cluster" "this" {
  name       = module.eks.cluster_name
  depends_on = [module.eks]
}

data "aws_eks_cluster_auth" "this" {
  name       = module.eks.cluster_name
  depends_on = [module.eks]
}
