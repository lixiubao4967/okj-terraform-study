output "user_count" {
  description = "用户数量"
  value       = length(var.users)
}

output "user_names" {
  description = "所有用户名"
  value       = [for u in var.users : u.name]
}

output "index_file_path" {
  description = "用户索引文件路径"
  value       = local_file.user_index.filename
}
