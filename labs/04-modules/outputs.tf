output "frontend_config_path" {
  description = "Frontend 配置文件路径"
  value       = module.frontend_app.config_file_path
}

output "frontend_app_id" {
  description = "Frontend 应用 ID"
  value       = module.frontend_app.app_id
}

output "user_count" {
  description = "用户总数"
  value       = module.users.user_count
}

output "user_names" {
  description = "所有用户名"
  value       = module.users.user_names
}
