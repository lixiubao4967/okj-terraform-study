# ============================================================
# Lab 05 - 高级特性
# ============================================================

locals {
  output_dir = "/tmp/tf-advanced-demo"
  # 获取当前 workspace 名（任务 5 用）
  env = terraform.workspace
}

# ============================================================
# 1. count 方式（有缺陷，仅用于对比）
# ============================================================

resource "local_file" "count_demo" {
  count    = length(var.servers_count)
  filename = "${local.output_dir}/count-${var.servers_count[count.index]}.txt"
  content  = "Server: ${var.servers_count[count.index]}, Index: ${count.index}"
}

# ============================================================
# 2. for_each 方式（推荐）
# ============================================================

resource "local_file" "foreach_demo" {
  for_each = toset(var.servers_count)
  filename = "${local.output_dir}/foreach-${each.key}.txt"
  content  = "Server: ${each.key} (managed by for_each, no index vulnerability)"
}

# ============================================================
# 3. dynamic 块演示：动态生成安全组配置
# ============================================================

# 用 local_file 模拟生成安全组配置（替代真实的 aws_security_group）
resource "local_file" "security_group_config" {
  filename = "${local.output_dir}/security-group.json"
  content = jsonencode({
    name = "app-sg"
    ingress_rules = [
      for rule in var.ingress_rules : {
        port     = rule.port
        protocol = rule.protocol
        desc     = rule.desc
      }
    ]
  })
}

# 如果使用真实 AWS provider，dynamic 块的写法如下：
# resource "aws_security_group" "app" {
#   name = "app-sg"
#   dynamic "ingress" {
#     for_each = var.ingress_rules
#     content {
#       from_port   = ingress.value.port
#       to_port     = ingress.value.port
#       protocol    = ingress.value.protocol
#       description = ingress.value.desc
#       cidr_blocks = ["0.0.0.0/0"]
#     }
#   }
# }

# ============================================================
# 4. templatefile() 函数
# ============================================================

resource "local_file" "app_config_from_template" {
  filename = "${local.output_dir}/app.conf"
  content = templatefile("${path.module}/templates/app.conf.tftpl", {
    app      = var.app_settings
    env      = local.env
  })
}

# ============================================================
# 5. lifecycle 演示
# ============================================================

resource "random_id" "stable_id" {
  byte_length = 8

  # lifecycle {
  #   # 测试 1：防止误删
  #   prevent_destroy = true
  #
  #   # 测试 2：忽略某字段变化
  #   ignore_changes = [keepers]
  #
  #   # 测试 3：先创建后删除（避免停机）
  #   create_before_destroy = true
  # }
}

resource "local_file" "lifecycle_demo" {
  filename = "${local.output_dir}/lifecycle-demo.txt"
  content  = "ID: ${random_id.stable_id.hex}, Env: ${local.env}"

  # lifecycle {
  #   ignore_changes = [content]  # 取消注释后手动修改文件，terraform plan 不会检测到变化
  # }
}

# ============================================================
# 6. 条件表达式
# ============================================================

resource "local_file" "conditional_demo" {
  filename = "${local.output_dir}/conditional.txt"
  content = var.app_settings.enable_ssl ? (
    "SSL is ENABLED. Workers: ${var.app_settings.workers}"
  ) : (
    "SSL is DISABLED. Workers: ${var.app_settings.workers}"
  )
}

# ============================================================
# 7. for 表达式综合演示
# ============================================================

resource "local_file" "expressions_demo" {
  filename = "${local.output_dir}/expressions.json"
  content = jsonencode({
    # list -> list 转换
    upper_servers = [for s in var.servers_count : upper(s)]

    # list -> map
    server_map = { for s in var.servers_count : s => "${s}-instance" }

    # 过滤
    filtered = [for s in var.servers_count : s if s != "worker"]

    # map -> list
    port_list = [for r in var.ingress_rules : r.port]

    # splat 操作符（等价于 for 表达式）
    # 仅用于 list of objects：resource_list[*].attribute
  })
}
