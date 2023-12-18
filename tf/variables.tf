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

variable "GKE_CLUSTER_NAME" {
  type        = string
  default     = "buddybot-cluster"
  description = "GKE cluster name"
}

variable "GKE_POOL_NAME" {
  type        = string
  default     = "buddybot-pool"
  description = "GKE pool name"
}

variable "GITHUB_OWNER" {
  type        = string
  description = "GitHub user"
}

variable "GKE_MACHINE_TYPE" {
  type        = string
  default     = "n1-standard-4"
  description = "Machine type"
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

variable "FLUX_GITHUB_TARGET_PATH" {
  type        = string
  default     = "clusters"
  description = " Flux manifets subbdirectory"
}