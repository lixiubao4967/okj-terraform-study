variable "servers_count" {
  type        = list(string)
  description = "服务列表（用于演示 count vs for_each）"
  default     = ["web", "api", "worker"]
}

variable "ingress_rules" {
  type = list(object({
    port     = number
    protocol = string
    desc     = string
  }))
  description = "入站规则列表（用于演示 dynamic 块）"
  default = [
    { port = 80,   protocol = "tcp", desc = "HTTP" },
    { port = 443,  protocol = "tcp", desc = "HTTPS" },
    { port = 8080, protocol = "tcp", desc = "App Port" },
  ]
}

variable "app_settings" {
  type = object({
    name        = string
    version     = string
    log_level   = string
    workers     = number
    enable_ssl  = bool
    allowed_ips = list(string)
  })
  default = {
    name        = "my-app"
    version     = "2.0.0"
    log_level   = "info"
    workers     = 4
    enable_ssl  = true
    allowed_ips = ["10.0.0.0/8", "192.168.0.0/16"]
  }
}
