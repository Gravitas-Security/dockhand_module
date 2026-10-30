# Dockhand Stacks Module

Terraform module that deploys Docker Compose stacks from a Git repository as [Dockhand](https://github.com/Finsys/dockhand) git stacks, using the [`kalebharrison/dockhand`](https://registry.terraform.io/providers/kalebharrison/dockhand/latest) provider, and puts Cloudflare Access in front of the published ones.

## Overview

- Every `<name>/compose.yaml` under `published_stack_files_path` and `unpublished_stack_files_path` becomes a `dockhand_git_stack` named `<name>`.
- Published stacks also get a Cloudflare Zero Trust Access application at `<name>.<cf_domain>`, all sharing one Access policy.
- Each stack lives in its own directory because Dockhand redeploys a git stack whenever anything in its compose file's directory changes.
- Stacks auto-update from Git every minute and repull images on deploy.
- Secrets come from a Dockhand secret provider (for example Doppler) bound to every stack via `secret_provider_id`, or per stack in Dockhand. The module sets `DOCKHAND_SECRET_SELECTOR` on every stack, which Dockhand requires before it pulls from a bulk provider. Compose files reference secrets as `${VAR}`.

## Repository layout

```
published_stack_files/
  traefik/compose.yaml
  wud/compose.yaml
unpublished_stack_files/
  docker-proxy/compose.yaml
```

The directory names must match their paths in the Git repository Dockhand clones, since `compose_path` is built from them.

## Usage

```hcl
module "docker_stacks" {
  source = "github.com/Gravitas-Security/dockhand_module?ref=<tag>"

  published_stack_files_path   = "../published_stack_files"
  unpublished_stack_files_path = "../unpublished_stack_files"

  environment_id = "1" # Dockhand environment ID
  repository_id  = "1" # Dockhand git repository ID holding the stack files

  cf_domain       = "example.com"
  cf_account_name = "Example Account"

  secret_provider_id = 1 # optional: Dockhand secret provider to bind
}
```

The calling configuration configures the `dockhand` and `cloudflare` providers.

## Inputs

| Name | Description |
|------|-------------|
| `published_stack_files_path` | Directory of stacks published through Cloudflare Access |
| `unpublished_stack_files_path` | Directory of internal-only stacks |
| `environment_id` | Dockhand environment ID to deploy stacks to |
| `repository_id` | Dockhand git repository ID that holds the stack files |
| `cf_domain` | Cloudflare zone published stacks are exposed under |
| `cf_account_name` | Cloudflare account name |
| `secret_provider_id` | Dockhand secret provider ID bound to every stack. Default `null` leaves bindings unchanged |

## Outputs

| Name | Description |
|------|-------------|
| `published_stack_definitions` | Published stack name => compose file |
| `unpublished_stack_definitions` | Unpublished stack name => compose file |
| `cloudflare_access_application` | Access applications |
| `cloudflare_access_policy` | Access policy |
| `stack_public_attributes` | Per-stack ID, compose path and sync status |
