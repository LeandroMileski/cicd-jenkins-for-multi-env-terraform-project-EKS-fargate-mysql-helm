#backend.tf
terraform {
  backend "s3" {
    bucket         = "amzn-eks-backend"
    key            = "dev/terraform.tfstate"
    region         = "eu-west-1"
    encrypt        = true
    use_lockfile   = true
  }
}