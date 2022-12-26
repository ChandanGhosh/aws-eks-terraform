resource "kubernetes_namespace" "app" {
  metadata {
    name = var.app_namespace
  }

  depends_on = [
    aws_launch_template.this,
    aws_eks_node_group.this
  ]
}

resource "kubernetes_secret" "app-docreg" {
  metadata {
    name      = var.app_docreg
    namespace = kubernetes_namespace.app.id
  }

  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "${var.app_registry_server}" = {
          "username" = var.app_registry_username
          "password" = var.app_registry_password
          "auth"     = base64encode("${var.app_registry_username}:${var.app_registry_password}")
        }
      }
    })
  }
}

resource "kubectl_manifest" "aws_auth" {
  yaml_body = <<YAML
apiVersion: v1
kind: ConfigMap
metadata:
  labels:
    app.kubernetes.io/managed-by: Terraform
  name: aws-auth
  namespace: kube-system
data:
  mapAccounts: |
    []
  mapRoles: |
    ${indent(4, yamlencode(local.aws_auth_roles))}
  mapUsers: |
    []
YAML

  depends_on = [
    aws_eks_cluster.this
  ]
}
