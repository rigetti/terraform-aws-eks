# This Terraform file defines the necessary Kubernetes cluster role and cluster role binding resources for the "expel-reader" role.

# Resource: kubernetes_cluster_role.expel-reader-clusterrole
# This resource defines a Kubernetes cluster role named "expel-reader-clusterrole". It grants read-only access to various Kubernetes resources.
# The role allows the user specified in the variable "var.expel_k8s_user_name" to perform "get" and "list" operations on the specified resources.

resource "kubernetes_cluster_role" "expel-reader-clusterrole" {
  metadata {
    name = var.expel_k8s_cluster_role_name
  }

  rule {
    api_groups = [
      "",
      "admissionregistration.k8s.io",
      "apps",
      "networking.k8s.io",
      "rbac.authorization.k8s.io"
    ]
    resources = [
      "apiservices",
      "clusterrolebindings",
      "clusterroles",
      "cronjobs",
      "daemonsets",
      "deployments",
      "events",
      "flowschemas",
      "horizontalpodautoscalers",
      "ingressclasses",
      "ingresses",
      "jobs",
      "localsubjectaccessreviews",
      "mutatingwebhookconfigurations",
      "namespaces",
      "networkpolicies",
      "nodes",
      "persistentvolumes",
      "poddisruptionbudgets",
      "pods",
      "podsecuritypolicies",
      "podtemplates",
      "replicasets",
      "rolebindings",
      "roles",
      "selfsubjectaccessreviews",
      "selfsubjectrulesreviews",
      "serviceaccounts",
      "services",
      "statefulsets",
      "subjectaccessreviews",
      "tokenreviews",
      "validatingwebhookconfigurations",
      "volumeattachments"
    ]
    verbs = ["get", "list"]
  }
}

# Resource: kubernetes_cluster_role_binding.expel-reader-cluster-role-binding
# This resource defines a Kubernetes cluster role binding named "expel-reader-clusterrolebinding". It binds the "expel-reader-clusterrole" to the user specified in the variable "var.expel_k8s_user_name".
# The cluster role binding allows the user to assume the permissions defined in the "expel-reader-clusterrole".

resource "kubernetes_cluster_role_binding" "expel-reader-cluster-role-binding" {
  metadata {
    name = "expel-reader-clusterrolebinding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = var.expel_k8s_cluster_role_name
  }
  subject {
    kind = "User"
    name = var.expel_k8s_user_name
  }
}
