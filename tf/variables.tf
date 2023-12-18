variable "GOOGLE_PROJECT" {
  type        = string
  description = "GCP project id"
}

variable "GOOGLE_REGION" {
  type        = string
  default     = "us-central1-c"
  description = "GCP region to use"
}

variable "GKE_NUM_NODES" {
  type        = number
  default     = 3
  description = "GKE nodes number"
}

variable "GITHUB_OWNER" {
  type        = string
  description = "GitHub user"
}

variable "FLUX_GITHUB_REPO" {
  type        = string
  default     = "buddybot-flux-config"
  description = "The name of repository to store Flux manifest"
}
variable "GITHUB_TOKEN" {
  type        = string
  description = "GitHub personal access token"
}