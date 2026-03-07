variable "app_name" {
  type        = string
  description = "应用名称"
}

variable "environment" {
  type        = string
  description = "部署环境"
  default     = "dev"
}

variable "instance_count" {
  type        = number
  description = "实例数量"
  default     = 1
}

variable "extra_config" {
  type        = map(string)
  description = "额外配置项"
  default     = {}
}

variable "output_dir" {
  type        = string
  description = "输出目录"
  default     = "/tmp/tf-modules-demo"
}
