output "service_id" {
  description = "服务唯一 ID"
  value       = random_id.service_id.hex
}

output "config_path" {
  description = "配置文件路径"
  value       = local_file.service_config.filename
}

output "is_production" {
  description = "是否是生产环境"
  value       = var.environment == "prod"
}
