module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.33"

  cluster_endpoint_public_access                  = true
  enable_cluster_creator_admin_permissions        = true
  enable_irsa                                     = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  create_cloudwatch_log_group = false

  eks_managed_node_groups = {
    node_group = {
      instance_types = [var.node_instance_type]
      ami_type       = "AL2023_x86_64_STANDARD"

      min_size     = var.node_min_size
      max_size     = var.node_max_size
      desired_size = var.node_desired_size
      
      tags = {
        Name = "${var.env_prefix}"
      }
      # EBS CSI Driver policy
      iam_role_additional_policies = {
        AmazonEBSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
      }  
    }
  }
  # Starting from EKS 1.23 CSI plugin is needed for volume provisioning.
  cluster_addons = {
    aws-ebs-csi-driver     = {}
  }
  tags = {
    Environment = "${var.env_prefix}"
    Terraform   = "true"
    Application = var.application.name
  }

  fargate_profiles = {
    profile = {
      name = "my-fargate-profile"
      selectors = [
        {
          namespace = "my-app"
        }
      ]
    }
  }

}