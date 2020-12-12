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

variable "organization_id" {
  description = "Organization ID"
  type        = string
}
