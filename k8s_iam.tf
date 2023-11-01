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

resource "kubernetes_cluster_role_binding" "example" {
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
