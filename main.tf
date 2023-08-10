terraform {
  required_providers {
    vault = {
      source = "hashicorp/vault"
      version = "3.13.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.65"
    }
  }
}

provider "aws" {
  region = var.region
}

provider "vault" {
    address         = var.vault_cluster_addr
    skip_tls_verify = true 
}

resource "vault_mount" "kvv2" {
  path        = "kvv2"
  type        = "kv"
  options     = { version = "2" }
  description = "KV Version 2 secret engine mount"
}

resource "vault_kv_secret_v2" "secret" {
  mount                      = vault_mount.kvv2.path
  name                       = "secret"
  cas                        = 1
  delete_all_versions        = true
  data_json                  = jsonencode(
  {
    code       = "123"
  }
  )
}


