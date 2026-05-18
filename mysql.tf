resource "helm_release" "mysql" {
  name       = "mysql"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "mysql"
  version    = "9.x"
  namespace  = "mysql"

  create_namespace = true

  values = [file("${path.module}/values/mysql-values.yaml")]

  depends_on = [module.eks]
}