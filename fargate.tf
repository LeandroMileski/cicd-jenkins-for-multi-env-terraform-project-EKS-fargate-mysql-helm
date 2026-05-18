module "fargate_java" {
  source  = "terraform-aws-modules/eks/aws//modules/fargate-profile"
  version = "~> 20.0"

  cluster_name = module.eks.cluster_name

  name = "java-app-fargate-profile"

  selectors = [
    {
      namespace = "java-apps"
      labels = {
        runtime = "fargate"
      }
    }
  ]

  subnet_ids = module.vpc.private_subnets

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }

  depends_on = [module.eks]
}