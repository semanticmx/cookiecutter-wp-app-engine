terraform {
  required_version = ">= 0.12, < 0.14"
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

resource "google_sql_database_instance" "instance" {
  name                = "{{ cookiecutter.project_slug }}"
  region              = var.region
  deletion_protection = "true"

  settings {
    tier              = var.tier
    activation_policy = "ALWAYS"
  }
}

resource "google_sql_database" "database" {
  name     = "{{ cookiecutter.project_slug }}-db"
  instance = google_sql_database_instance.instance.name
}
