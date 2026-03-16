# ============================================================
# Lab 02 - 变量与输出
# ============================================================

# 生成一个随机 ID（模拟资源 ID）
resource "random_id" "app_id" {
  byte_length = 4
}

# 使用变量和 locals 生成应用配置文件
resource "local_file" "app_config" {
  filename = "/tmp/${local.name_prefix}-config.json"
  content = jsonencode({
    app_name    = var.app_config.name
    version     = var.app_config.version
    port        = var.app_config.port
    debug       = local.debug_mode
    environment = var.environment
    instance_id = random_id.app_id.hex
    tags        = local.common_tags
  })
}

# 生成用户清单文件
resource "local_file" "user_manifest" {
  filename = "/tmp/${local.name_prefix}-users.txt"
  content = join("\n", [
    "# User Manifest for ${var.project_name}",
    "# Environment: ${var.environment}",
    "",
    "## All Users:",
    join("\n", [for u in var.users : "  - ${u.name} (${u.role})"]),
    "",
    "## Admins:",
    join("\n", [for name in local.admin_users : "  - ${name}"]),
  ])
}

# 为每个允许的端口创建一个配置文件（演示 count）
resource "local_file" "port_config" {
  count    = length(var.allowed_ports)
  filename = "/tmp/${local.name_prefix}-port-${var.allowed_ports[count.index]}.txt"
  content  = "Port ${var.allowed_ports[count.index]} is allowed in ${var.environment}"
}

resource "local_file" "db_config" {
  filename = "/tmp/${local.name_prefix}-db.txt"
  content  = "password = ${var.db_password}"
}
