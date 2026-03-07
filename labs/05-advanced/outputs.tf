output "count_files" {
  description = "count 方式创建的文件"
  value       = [for f in local_file.count_demo : f.filename]
}

output "foreach_files" {
  description = "for_each 方式创建的文件"
  value       = { for k, f in local_file.foreach_demo : k => f.filename }
}

output "app_config_path" {
  description = "从模板生成的配置文件"
  value       = local_file.app_config_from_template.filename
}

output "current_workspace" {
  description = "当前 workspace"
  value       = terraform.workspace
}
