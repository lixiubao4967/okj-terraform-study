# terraform.tfvars — 默认变量赋值文件，terraform 自动加载
# 这里的值会覆盖 variables.tf 中的 default

project_name   = "okj-study"
environment    = "dev"
instance_count = 2
enable_debug   = true

allowed_ports = [80, 443, 3000, 8080]

tags = {
  Team    = "platform"
  Owner   = "me"
}
