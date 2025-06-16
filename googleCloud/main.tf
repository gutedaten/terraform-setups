terraform {
  backend "gcs" {
    bucket = "datadash360-terraform-state"
    prefix = "state"
  }

   required_providers {
    google = {
      source  = "hashicorp/google"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
    }
  }
}

# -------------------------------
# APIs aktivieren
# -------------------------------
resource "google_project_service" "crm_api" {
  project            = var.project_id
  service            = "cloudresourcemanager.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "iam_api" {
  project            = var.project_id
  service            = "iam.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "firebase_api" {
  project            = var.project_id
  service            = "firebase.googleapis.com"
  disable_on_destroy = false
  depends_on         = [google_project_service.iam_api]
}

resource "google_project_service" "firestore_api" {
  project            = var.project_id
  service            = "firestore.googleapis.com"
  disable_on_destroy = false
  depends_on         = [google_project_service.firebase_api]
}

resource "google_project_service" "bigquery_api" {
  project            = var.project_id
  service            = "bigquery.googleapis.com"
  disable_on_destroy = false
  depends_on         = [google_project_service.iam_api]
}

# -------------------------------
# Module-Aufrufe
# -------------------------------
provider "google" {
  project     = var.project_id
  region      = "europe-west3"
}

provider "google-beta" {
  project     = var.project_id
  region      = "europe-west3"
}

module "iam" {
  source     = "./modules/iam"
  project_id = var.project_id
}

module "bigquery" {
  source     = "./modules/bigquery"
  project_id = var.project_id
}

module "firestore" {
  source     = "./modules/firebase/firestore"
  project_id = var.project_id

  providers = {
    google       = google
    google-beta  = google-beta
  }
}
