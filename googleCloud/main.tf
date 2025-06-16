terraform {
  backend "gcs" {
    bucket = "datadash360-terraform-state"
    prefix = "state"
  }
}

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
