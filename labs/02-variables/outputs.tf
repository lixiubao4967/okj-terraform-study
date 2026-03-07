# ============================================================
# 输出值声明
# ============================================================

output "app_config_path" {
  description = "应用配置文件路径"
  value       = local_file.app_config.filename
}

output "user_manifest_path" {
  description = "用户清单文件路径"
  value       = local_file.user_manifest.filename
}

output "name_prefix" {
  description = "统一名称前缀"
  value       = local.name_prefix
}

output "common_tags" {
  description = "通用标签"
  value       = local.common_tags
}

output "admin_users" {
  description = "管理员用户列表"
  value       = local.admin_users
}

output "users_map" {
  description = "用户名 -> 角色 映射"
  value       = local.users_map
}

output "app_instance_id" {
  description = "应用实例 ID"
  value       = random_id.app_id.hex
}

output "is_production" {
  description = "是否是生产环境"
  value       = local.is_production
}

output "port_config_files" {
  description = "端口配置文件列表"
  value       = [for f in local_file.port_config : f.filename]
}
