output "published_stack_definitions" {
  description = "Published stack name => compose file"
  value       = local.published_stacks
}

output "unpublished_stack_definitions" {
  description = "Unpublished stack name => compose file"
  value       = local.unpublished_stacks
}

output "cloudflare_access_application" {
  description = "Access Application"
  value       = cloudflare_zero_trust_access_application.access_app
}

output "cloudflare_access_policy" {
  description = "Access Application Policies"
  value       = cloudflare_zero_trust_access_policy.app_policy
}

output "stack_public_attributes" {
  description = "Per-stack ID, compose path and sync status (no secrets)"
  value       = local.stack_public_attrs
}
