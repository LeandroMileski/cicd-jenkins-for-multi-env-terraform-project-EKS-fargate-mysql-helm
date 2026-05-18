# This gives back object with certificate-authority among other attributes: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster#attributes-reference
data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_name
  depends_on = [module.eks.cluster_name]
}

# This gives us object with token: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth#attributes-reference  
data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
  depends_on = [module.eks.cluster_name]
}

provider "kubernetes" {
  # load_config_file     = "false"
  host                   = data.aws_eks_cluster.cluster.endpoint
  token                  = data.aws_eks_cluster_auth.cluster.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
}

provider "helm" {
  kubernetes = {
    host = data.aws_eks_cluster.cluster.endpoint
    token = data.aws_eks_cluster_auth.cluster.token
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  }
}

data "aws_secretsmanager_secret_version" "mysql_root" {
  secret_id  = aws_secretsmanager_secret.mysql_root.id
  depends_on = [aws_secretsmanager_secret_version.mysql_root]
}

resource "helm_release" "mysql" {
  name             = "mysql"
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "mysql"
  namespace        = "mysql"
  create_namespace = true

  values = [file("values.yaml")]

  set_sensitive = [
    {
    name  = "auth.rootPassword"
    value = data.aws_secretsmanager_secret_version.mysql_root.secret_string
  }]

  depends_on = [module.eks]
}