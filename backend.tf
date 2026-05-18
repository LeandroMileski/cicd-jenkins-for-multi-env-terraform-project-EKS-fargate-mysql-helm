terraform {
  backend "s3" {
    bucket         = "amzn-eks-backend"
    key            = "eks/test/terraform.tfstate"
    region         = "eu-west-1"
    encrypt        = true
    use_lockfile   = true
  }
}