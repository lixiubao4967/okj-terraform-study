# prod.tfvars — 生产环境变量
# 使用方式: terraform plan -var-file="prod.tfvars"

project_name   = "okj-study"
environment    = "prod"
instance_count = 5
enable_debug   = false

allowed_ports = [80, 443]

tags = {
  Team        = "platform"
  Owner       = "ops-team"
  CostCenter  = "cc-001"
}
