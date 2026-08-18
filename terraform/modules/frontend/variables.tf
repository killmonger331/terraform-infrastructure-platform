variable "environment" {
  description = "Environment/name used for frontend resources"
  type        = string
  default     = "shared"
}

variable "frontend_path" {
  description = "Local path containing frontend files"
  type        = string
}