resource "google_service_account" "kubernetes" {
  account_id = "kubernetes"
}

resource "google_project_iam_binding" "artifact_registry_role" {
  project = "ta-chetbot"
  role    = "roles/artifactregistry.reader"

  members = [
    "serviceAccount:${google_service_account.kubernetes.email}"
  ]
}

resource "google_service_account_key" "artifact_registry_key" {
  service_account_id = google_service_account.kubernetes.name
}

resource "google_container_node_pool" "general" {
  name       = "general"
  cluster    = google_container_cluster.primary.id

  management {
    auto_repair     = true
    auto_upgrade    = true
  }

  autoscaling {
    min_node_count = 0
    max_node_count = 10
  }

  node_config {
    preemptible  = false
    machine_type = "n1-standard-2"
    disk_size_gb = 15

    labels = {
        role = "general"
    }

    service_account = google_service_account.kubernetes.email
    oauth_scopes = [
        "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}