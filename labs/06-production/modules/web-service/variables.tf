variable "service_name" {
  type        = string
  description = "服务名称"
}

variable "environment" {
  type        = string
  description = "部署环境"
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment 必须是 dev、staging 或 prod。"
  }
}

variable "instance_count" {
  type        = number
  description = "实例数量"
  default     = 1
  validation {
    condition     = var.instance_count > 0 && var.instance_count <= 20
    error_message = "instance_count 必须在 1 到 20 之间。"
  }
}

variable "log_level" {
  type        = string
  description = "日志级别"
  default     = "info"
}

variable "output_dir" {
  type    = string
  default = "/tmp/tf-production-demo"
}
