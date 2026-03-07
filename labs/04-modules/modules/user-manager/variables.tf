variable "users" {
  type = list(object({
    name  = string
    role  = string
    email = string
  }))
  description = "用户列表"
}

variable "output_dir" {
  type    = string
  default = "/tmp/tf-modules-demo"
}
