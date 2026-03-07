# ============================================================
# locals：本地计算值
# 用于避免重复表达式，集中管理派生值
# ============================================================

locals {
  # 组合多个变量生成统一前缀
  name_prefix = "${var.project_name}-${var.environment}"

  # 合并用户传入的标签与强制标签
  common_tags = merge(var.tags, {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
  })

  # 根据环境决定配置
  is_production = var.environment == "prod"
  debug_mode    = local.is_production ? false : var.enable_debug

  # 从 users 列表中过滤出管理员
  admin_users = [for u in var.users : u.name if u.admin]

  # 将 users 列表转换为 map（以 name 为 key）
  users_map = { for u in var.users : u.name => u.role }
}
