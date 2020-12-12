variable "environment" {
  description = "Project environment"
  type        = string
  default     = "stage"
}

variable "region" {
  description = "Project region"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "Project zone"
  type        = string
  default     = "us-central1-a"
}

variable "project_id" {
  description = "Project ID"
  type        = string
  default     = "{{ cookiecutter.project_slug }}-id"
}

variable "tier" {
  description = "Database tier"
  type        = string
  default     = "db-f1-micro"
}
