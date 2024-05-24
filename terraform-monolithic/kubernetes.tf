resource "google_container_cluster" "primary" {
  name                      = "primary"
  location                  = "asia-southeast2"
  node_locations            = ["asia-southeast2-a", "asia-southeast2-b", "asia-southeast2-c"]
  remove_default_node_pool  = true
  initial_node_count        = 1
  network                   = google_compute_network.main.self_link
  subnetwork                = google_compute_subnetwork.private.self_link
  logging_service           = "logging.googleapis.com/kubernetes"
  networking_mode           = "VPC_NATIVE"

  release_channel {
    channel = "REGULAR"
  }

  workload_identity_config {
    workload_pool = "ta-chetbot.svc.id.goog"
  }

  ip_allocation_policy {
    cluster_secondary_range_name    = "k8s-pod-range"
    services_secondary_range_name   = "k8s-service-range"
  }

  private_cluster_config {
    enable_private_nodes        = true
    enable_private_endpoint     = false
    master_ipv4_cidr_block      = "172.16.0.0/28"
  }
}

resource "kubernetes_horizontal_pod_autoscaler" "hpa" {
  metadata {
    name = "chetbot-hpa"
  }

  spec {
    max_replicas = 10
    min_replicas = 3

    scale_target_ref {
      kind = "Deployment"
      name = "fastapi-deployment"
    }
  }
}