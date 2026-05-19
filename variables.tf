variable "region" {
  default = "eu-west-1"
}

variable "application" {
  default = {
    name = "myapp"
  }
}

variable "k8s_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.33"
}

variable "env_prefix" {
  default = "test"
}

variable "cluster_name" {
  default = "my-test-eks-cluster"
}

variable "cluster_version" {
  default = "1.29"
}

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "node_instance_type" {
  default = "t2.small"
}

variable "node_desired_size" { default = 3 }
variable "node_min_size"     { default = 1 }
variable "node_max_size"     { default = 4 }

variable "private_subnets" {
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnets" {
  default = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}