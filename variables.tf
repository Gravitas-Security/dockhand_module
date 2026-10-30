variable "published_stack_files_path" {
  description = "Path to the directory of stacks (<name>/compose.yaml) published through Cloudflare Access. The directory name must match its path in the Dockhand git repository."
  type        = string
}

variable "unpublished_stack_files_path" {
  description = "Path to the directory of internal-only stacks (<name>/compose.yaml). The directory name must match its path in the Dockhand git repository."
  type        = string
}


variable "environment_id" {
  description = "Dockhand environment ID to deploy stacks to"
  type        = string
}

variable "repository_id" {
  description = "Dockhand git repository ID that holds the stack files"
  type        = string
}

variable "cf_domain" {
  description = "Cloudflare zone that published stacks are exposed under"
  type        = string
}

variable "cf_account_name" {
  description = "Cloudflare account name"
  type        = string
}

variable "secret_provider_id" {
  description = "Dockhand secret provider ID to bind to every stack. null leaves each stack's existing binding unchanged."
  type        = number
  default     = null
}
