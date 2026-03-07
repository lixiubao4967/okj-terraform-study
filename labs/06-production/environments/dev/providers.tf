terraform {
  required_version = ">= 1.6"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "= 2.5.1"  # 生产中锁定精确版本
    }
    random = {
      source  = "hashicorp/random"
      version = "= 3.6.0"
    }
  }

  # 真实项目中使用远程 Backend
  # backend "s3" {
  #   bucket = "my-terraform-state"
  #   key    = "dev/terraform.tfstate"
  #   region = "ap-northeast-1"
  #   dynamodb_table = "terraform-state-lock"
  # }
}
