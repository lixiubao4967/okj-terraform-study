terraform {
  required_version = ">= 1.6"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "= 2.5.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "= 3.6.0"
    }
  }
}
