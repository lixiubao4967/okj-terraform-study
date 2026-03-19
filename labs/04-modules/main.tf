# ============================================================
# Lab 04 - 模块化
# Root module：调用子模块
# ============================================================

# 调用 app-config 模块（第一个实例：frontend）
module "frontend_app" {
  source         = "./modules/app-config"
  app_name       = "frontend"
  environment    = "staging"
  instance_count = 2
  extra_config = {
    framework = "react"
    node_version = "18"
  }
}

# 任务 3：多次实例化同一模块
module "backend_app" {
  source         = "./modules/app-config"
  app_name       = "backend"
  environment    = "staging"
  instance_count = 1
  extra_config = {
    framework = "express"
    port      = "3000"
  }
}

# 调用 user-manager 模块
module "users" {
  source = "./modules/user-manager"
  users = [
    { name = "alice", role = "developer", email = "alice@example.com" },
    { name = "bob",   role = "ops",       email = "bob@example.com" },
    { name = "carol", role = "qa",        email = "carol@example.com" },
  ]
}
