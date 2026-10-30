terraform {
  required_version = ">= 1.5"

  required_providers {
    dockhand = {
      source  = "kalebharrison/dockhand"
      version = "~> 0.1.93"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.45"
    }
  }
}
