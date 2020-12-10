terraform {
  required_version = ">= 0.12, < 0.14"
}

provider "google" {
  region = var.region
  zone   = var.zone
}

module "google_project" {
  source          = "git::https://github.com/semanticmx/terraform-google-project.git?ref=tags/1.0.0-alpha1"
  organization_id = var.organization_id
  project_name    = "{{ cookiecutter.project_slug }}"
}
