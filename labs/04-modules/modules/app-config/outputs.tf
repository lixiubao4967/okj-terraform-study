output "config_file_path" {
  description = "生成的配置文件路径"
  value       = local_file.config.filename
}

output "app_id" {
  description = "应用唯一 ID"
  value       = random_id.app_id.hex
}

output "app_full_name" {
  description = "应用完整名称"
  value       = "${var.app_name}-${var.environment}"
}
