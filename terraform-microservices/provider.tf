provider "google" {
  project = "ta-chetbot"
  region = "asia-southeast1"
}

terraform {
  backend "gcs" {
    bucket = "ta-chetbot-bucket"
    prefix = "terraform/state"
  }
  required_providers {
    google = {
        source = "hashicorp/google"
        version = "~> 4.0"
    }
  }
}