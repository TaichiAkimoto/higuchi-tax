terraform {
  required_version = ">= 1.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }

  backend "local" {
    path = "terraform.tfstate"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# Artifact Registry Repository
resource "google_artifact_registry_repository" "mendoi" {
  location      = var.region
  repository_id = "mendoi"
  description   = "Docker repository for Mendoi backend"
  format        = "DOCKER"
}

# Secret Manager - Gemini API Key
resource "google_secret_manager_secret" "gemini_api_key" {
  secret_id = "gemini-api-key"

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "gemini_api_key" {
  secret      = google_secret_manager_secret.gemini_api_key.id
  secret_data = var.gemini_api_key
}

# Secret Manager - Firebase Project ID
resource "google_secret_manager_secret" "firebase_project_id" {
  secret_id = "firebase-project-id"

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "firebase_project_id" {
  secret      = google_secret_manager_secret.firebase_project_id.id
  secret_data = var.firebase_project_id
}

# Secret Manager - Firebase Client Email
resource "google_secret_manager_secret" "firebase_client_email" {
  secret_id = "firebase-client-email"

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "firebase_client_email" {
  secret      = google_secret_manager_secret.firebase_client_email.id
  secret_data = var.firebase_client_email
}

# Secret Manager - Firebase Private Key
resource "google_secret_manager_secret" "firebase_private_key" {
  secret_id = "firebase-private-key"

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "firebase_private_key" {
  secret      = google_secret_manager_secret.firebase_private_key.id
  secret_data = var.firebase_private_key
}

# Service Account for Cloud Run
resource "google_service_account" "cloud_run" {
  account_id   = "mendoi-cloud-run"
  display_name = "Mendoi Cloud Run Service Account"
  description  = "Service account for Mendoi Cloud Run service"
}

# IAM - Secret Manager Access
resource "google_secret_manager_secret_iam_member" "gemini_api_key_access" {
  secret_id = google_secret_manager_secret.gemini_api_key.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.cloud_run.email}"
}

resource "google_secret_manager_secret_iam_member" "firebase_project_id_access" {
  secret_id = google_secret_manager_secret.firebase_project_id.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.cloud_run.email}"
}

resource "google_secret_manager_secret_iam_member" "firebase_client_email_access" {
  secret_id = google_secret_manager_secret.firebase_client_email.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.cloud_run.email}"
}

resource "google_secret_manager_secret_iam_member" "firebase_private_key_access" {
  secret_id = google_secret_manager_secret.firebase_private_key.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.cloud_run.email}"
}

# Cloud Run Service
resource "google_cloud_run_v2_service" "mendoi_api" {
  name     = "mendoi-api"
  location = var.region
  ingress  = "INGRESS_TRAFFIC_ALL"

  template {
    service_account = google_service_account.cloud_run.email

    scaling {
      min_instance_count = 0
      max_instance_count = 10
    }

    containers {
      image = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.mendoi.repository_id}/mendoi-backend:${var.image_tag}"

      ports {
        container_port = 3000
      }

      env {
        name = "NODE_ENV"
        value = "production"
      }

      env {
        name = "GEMINI_API_KEY"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.gemini_api_key.secret_id
            version = "latest"
          }
        }
      }

      env {
        name = "FIREBASE_PROJECT_ID"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.firebase_project_id.secret_id
            version = "latest"
          }
        }
      }

      env {
        name = "FIREBASE_CLIENT_EMAIL"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.firebase_client_email.secret_id
            version = "latest"
          }
        }
      }

      env {
        name = "FIREBASE_PRIVATE_KEY"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.firebase_private_key.secret_id
            version = "latest"
          }
        }
      }

      resources {
        limits = {
          cpu    = "1"
          memory = "512Mi"
        }
      }

      startup_probe {
        http_get {
          path = "/health"
        }
        initial_delay_seconds = 0
        timeout_seconds       = 1
        period_seconds        = 3
        failure_threshold     = 3
      }

      liveness_probe {
        http_get {
          path = "/health"
        }
        initial_delay_seconds = 0
        timeout_seconds       = 1
        period_seconds        = 10
        failure_threshold     = 3
      }
    }
  }

  traffic {
    type    = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
    percent = 100
  }

  depends_on = [
    google_secret_manager_secret_version.gemini_api_key,
    google_secret_manager_secret_version.firebase_project_id,
    google_secret_manager_secret_version.firebase_client_email,
    google_secret_manager_secret_version.firebase_private_key,
  ]
}

# IAM - Allow unauthenticated access to Cloud Run
resource "google_cloud_run_v2_service_iam_member" "noauth" {
  name     = google_cloud_run_v2_service.mendoi_api.name
  location = google_cloud_run_v2_service.mendoi_api.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}

# Enable required APIs
resource "google_project_service" "cloud_run" {
  service = "run.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "artifact_registry" {
  service = "artifactregistry.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "secret_manager" {
  service = "secretmanager.googleapis.com"
  disable_on_destroy = false
}
