locals {
  # stack name => compose file path relative to the stacks dir (<name>/compose.yaml).
  # One directory per stack: Dockhand redeploys a git stack when anything in its
  # compose file's directory changes.
  published_stacks = {
    for f in fileset(var.published_stack_files_path, "*/compose.y*ml") :
    dirname(f) => f
  }
  unpublished_stacks = {
    for f in fileset(var.unpublished_stack_files_path, "*/compose.y*ml") :
    dirname(f) => f
  }

  # Dockhand only pulls from a stack's bound secret provider when this selector is
  # set. Doppler ignores the value (the token scopes the config) but it must be non-empty.
  stack_env_vars_json = jsonencode([
    { key = "DOCKHAND_SECRET_SELECTOR", value = "doppler", isSecret = false },
  ])

  stack_public_attrs = {
    for name, s in merge(dockhand_git_stack.published_stacks, dockhand_git_stack.unpublished_stacks) :
    name => {
      id                  = s.id
      compose_path        = s.compose_path
      repository_name     = s.repository_name
      auto_update_enabled = s.auto_update_enabled
      # sync_status and last_sync are left out: Dockhand updates them on every sync,
      # so exposing them made every plan show output changes.
    }
  }
}
