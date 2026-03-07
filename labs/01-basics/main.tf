# ============================================================
# Lab 01 - 基础入门
# 使用 local provider 操作本地文件，无需云账号
# ============================================================

# 创建一个本地文件
resource "local_file" "hello" {
  filename = "/tmp/terraform-hello.txt"
  content  = "Hello, Terraform! I was created by terraform apply."
}

# 创建一个 JSON 格式的配置文件
resource "local_file" "config" {
  filename = "/tmp/terraform-config.json"
  content = jsonencode({
    app     = "my-app"
    version = "1.0.0"
    debug   = false
  })
}

# 任务 4：取消下方注释，使用 random provider
# --------------------------------------------------------------
# resource "random_pet" "name" {
#   length    = 2
#   separator = "-"
# }
#
# resource "local_file" "pet_name" {
#   filename = "/tmp/terraform-pet.txt"
#   content  = "My random name is: ${random_pet.name.id}"
# }
# --------------------------------------------------------------
