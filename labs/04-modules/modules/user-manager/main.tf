# ============================================================
# Module: user-manager
# 为每个用户生成配置文件
# ============================================================

resource "local_file" "user_config" {
  for_each = { for u in var.users : u.name => u }
  filename = "${var.output_dir}/users/${each.key}.json"
  content = jsonencode({
    name  = each.value.name
    role  = each.value.role
    email = each.value.email
  })
}

resource "local_file" "user_index" {
  filename = "${var.output_dir}/users/index.txt"
  content = join("\n", [
    for u in var.users : "${u.name} <${u.email}> [${u.role}]"
  ])
}
