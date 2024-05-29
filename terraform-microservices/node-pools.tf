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

resource "google_container_node_pool" "c2-node-pool" {
  name       = "c2-node-pool"
  cluster    = google_container_cluster.primary.id
  initial_node_count = 1

  management {
    auto_repair     = true
    auto_upgrade    = true
  }

  autoscaling {
    min_node_count = 1
    max_node_count = 4
  }

  node_config {
    preemptible  = false
    machine_type = "c2-standard-4"

    service_account = google_service_account.kubernetes.email
    oauth_scopes = [
        "https://www.googleapis.com/auth/cloud-platform"
    ]

    labels = {
      nodepool = "c2"
    }
  }
}

resource "google_container_node_pool" "e2-node-pool" {
  name       = "e2-node-pool"
  cluster    = google_container_cluster.primary.id
  initial_node_count = 1

  management {
    auto_repair     = true
    auto_upgrade    = true
  }

  autoscaling {
    min_node_count = 1
    max_node_count = 2
  }

  node_config {
    preemptible  = false
    machine_type = "e2-standard-4"

    service_account = google_service_account.kubernetes.email
    oauth_scopes = [
        "https://www.googleapis.com/auth/cloud-platform"
    ]
    
    labels = {
      nodepool = "e2"
    }
  }
}