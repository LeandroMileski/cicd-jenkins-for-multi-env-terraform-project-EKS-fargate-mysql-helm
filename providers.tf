terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # This allows any 5.x version (e.g., 5.95.0), fixing the conflict with 6.28.0
    }
    random = {
    source  = "hashicorp/random"
    version = "~> 3.0"
  }
}
}

