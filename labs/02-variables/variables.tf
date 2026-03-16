# ============================================================
# 变量声明 - 演示各种变量类型
# ============================================================

variable "project_name" {
  type        = string
  description = "项目名称"
  default     = "terraform-study"
}

variable "environment" {
  type        = string
  description = "部署环境"
  default     = "dev"

  # 任务 3：在这里添加 validation 块
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment 只能是 dev、staging 或 prod。"
  }
}

variable "instance_count" {
  type        = number
  description = "实例数量"
  default     = 2
}

variable "enable_debug" {
  type        = bool
  description = "是否开启调试模式"
  default     = false
}

# list 类型
variable "allowed_ports" {
  type        = list(number)
  description = "允许的端口列表"
  default     = [80, 443, 8080]
}

# map 类型
variable "tags" {
  type        = map(string)
  description = "资源标签"
  default = {
    Team    = "platform"
    Project = "okj"
  }
}

# object 类型（结构固定，每个字段有独立类型）
variable "app_config" {
  type = object({
    name    = string
    version = string
    port    = number
    debug   = bool
  })
  description = "应用配置"
  default = {
    name    = "my-app"
    version = "1.0.0"
    port    = 8080
    debug   = false
  }
}

# list of objects
variable "users" {
  type = list(object({
    name  = string
    role  = string
    admin = bool
  }))
  description = "用户列表"
  default = [
    { name = "alice", role = "developer", admin = false },
    { name = "bob", role = "ops", admin = true },
  ]
}

variable "db_password" {
  type      = string
  sensitive = true
  default   = "super-secret-123"
}
