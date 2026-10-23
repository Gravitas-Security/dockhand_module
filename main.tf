resource "dockhand_git_stack" "published_stacks" {
  for_each = local.published_stacks

  stack_name    = each.key
  env           = var.environment_id
  repository_id = var.repository_id
  compose_path  = "${basename(var.published_stack_files_path)}/${each.value}"
  env_vars_json = local.stack_env_vars_json

  auto_update_enabled = true
  auto_update_cron    = "* * * * *"
  deploy_now          = true
  build_on_deploy     = false
  repull_images       = true
  force_redeploy      = false
}

resource "dockhand_git_stack" "unpublished_stacks" {
  for_each = local.unpublished_stacks

  stack_name    = each.key
  env           = var.environment_id
  repository_id = var.repository_id
  compose_path  = "${basename(var.unpublished_stack_files_path)}/${each.value}"
  env_vars_json = local.stack_env_vars_json

  auto_update_enabled = true
  auto_update_cron    = "* * * * *"
  deploy_now          = true
  build_on_deploy     = false
  repull_images       = true
  force_redeploy      = false
}

data "cloudflare_accounts" "account" {
  name = var.cf_account_name
}

data "cloudflare_zones" "zones" {
  filter {
    name = var.cf_domain
  }
}

resource "cloudflare_zero_trust_access_application" "access_app" {
  for_each = local.published_stacks

  zone_id  = data.cloudflare_zones.zones.zones[0].id
  domain   = "${each.key}.${var.cf_domain}"
  name     = each.key
  policies = [cloudflare_zero_trust_access_policy.app_policy.id]

  lifecycle {
    ignore_changes = [zone_id]
  }
}

resource "cloudflare_zero_trust_access_policy" "app_policy" {
  account_id = data.cloudflare_accounts.account.accounts[0].id
  name       = "${var.cf_domain} Access Policy"
  decision   = "allow"

  include {
    login_method = ["fde5709d-c4a5-4a52-b368-dba11118f38b"]
  }

  lifecycle {
    create_before_destroy = true
  }
}
