# Terraform 命令速查表

## 核心工作流

```bash
terraform init                    # 初始化（下载 provider/module）
terraform init -upgrade           # 升级 provider 版本
terraform plan                    # 预览变更
terraform plan -out=tfplan        # 保存 plan 结果
terraform apply                   # 执行变更（会要求确认）
terraform apply -auto-approve     # 跳过确认
terraform apply tfplan            # 执行已保存的 plan
terraform destroy                 # 销毁所有资源
terraform destroy -target=<addr>  # 只销毁指定资源
```

## 变量传入

```bash
terraform plan -var="name=value"
terraform plan -var-file="prod.tfvars"
export TF_VAR_name=value          # 环境变量方式
```

## 状态操作

```bash
terraform state list              # 列出所有资源
terraform state show <addr>       # 查看资源详情
terraform state mv <src> <dst>    # 重命名资源
terraform state rm <addr>         # 从状态移除（不销毁）
terraform state pull              # 下载远程状态
terraform state push              # 上传本地状态到远端（危险）
terraform import <addr> <id>      # 导入已有资源
terraform apply -refresh-only     # 刷新状态（检测漂移）
```

## 输出与调试

```bash
terraform output                  # 打印所有 output
terraform output <name>           # 打印指定 output
terraform output -json            # JSON 格式输出
terraform console                 # 交互式表达式求值（调试用）
terraform graph | dot -Tsvg > graph.svg  # 生成依赖图
```

## 代码质量

```bash
terraform fmt                     # 格式化代码
terraform fmt -recursive          # 递归格式化
terraform validate                # 检查语法
terraform test                    # 运行测试（v1.6+）
```

## Workspace

```bash
terraform workspace list          # 列出所有 workspace
terraform workspace new <name>    # 创建 workspace
terraform workspace select <name> # 切换 workspace
terraform workspace delete <name> # 删除 workspace
terraform workspace show          # 显示当前 workspace
```

## 常用目标操作

```bash
terraform plan -target=resource_type.name      # 只计划指定资源
terraform apply -target=module.module_name     # 只应用指定模块
```

## 环境变量

```bash
export TF_LOG=DEBUG               # 日志级别: TRACE/DEBUG/INFO/WARN/ERROR
export TF_LOG_PATH=./debug.log    # 日志写入文件
export TF_DATA_DIR=./.terraform   # 指定数据目录
export TF_CLI_ARGS_plan="-refresh=false"  # 为子命令预设参数
```

---

## HCL 语法速查

### 变量类型

```hcl
variable "example" {
  type        = string          # string / number / bool
  description = "描述"
  default     = "default_value"
  sensitive   = true            # 标记敏感，不打印
  validation {
    condition     = length(var.example) > 0
    error_message = "不能为空"
  }
}
```

### 复杂类型

```hcl
variable "tags" {
  type = map(string)
  default = { env = "dev", team = "ops" }
}

variable "ports" {
  type    = list(number)
  default = [80, 443]
}

variable "server" {
  type = object({
    name  = string
    count = number
  })
}
```

### locals

```hcl
locals {
  env       = "production"
  full_name = "${var.project}-${local.env}"
  tags      = merge(var.common_tags, { Env = local.env })
}
```

### output

```hcl
output "instance_ip" {
  value       = aws_instance.web.public_ip
  description = "公网 IP"
  sensitive   = false
}
```

### count vs for_each

```hcl
# count（适合同质资源）
resource "aws_instance" "web" {
  count = 3
  tags  = { Name = "web-${count.index}" }
}
# 引用：aws_instance.web[0]

# for_each（适合有唯一标识的资源，推荐）
resource "aws_iam_user" "users" {
  for_each = toset(["alice", "bob", "charlie"])
  name     = each.key
}
# 引用：aws_iam_user.users["alice"]

# map 驱动
resource "aws_instance" "servers" {
  for_each      = { web = "t2.micro", api = "t2.small" }
  instance_type = each.value
  tags          = { Name = each.key }
}
```

### dynamic 块

```hcl
resource "aws_security_group" "example" {
  dynamic "ingress" {
    for_each = var.ports
    content {
      from_port = ingress.value
      to_port   = ingress.value
      protocol  = "tcp"
    }
  }
}
```

### lifecycle

```hcl
resource "aws_instance" "web" {
  lifecycle {
    create_before_destroy = true   # 先创建新的再删旧的
    prevent_destroy       = true   # 禁止销毁（防误删）
    ignore_changes        = [tags] # 忽略某字段的外部变更
    replace_triggered_by  = [null_resource.trigger]
  }
}
```

### 条件与 for 表达式

```hcl
# 条件
instance_type = var.env == "prod" ? "t3.medium" : "t3.micro"

# for 表达式（list -> list）
upper_names = [for n in var.names : upper(n)]

# for 表达式（list -> map）
name_map = { for n in var.names : n => upper(n) }

# for 表达式 + 过滤
prod_names = [for n in var.names : n if n != "test"]
```

### 常用内置函数

```hcl
# 字符串
upper("hello")          # "HELLO"
lower("HELLO")          # "hello"
format("%-10s", "hi")   # "hi        "
trimspace("  hi  ")     # "hi"
split(",", "a,b,c")     # ["a","b","c"]
join(",", ["a","b"])     # "a,b"
replace("abc", "b", "X")# "aXc"

# 集合
length(var.list)         # 长度
concat(list1, list2)     # 合并 list
flatten([[1,2],[3]])      # [1,2,3]
distinct([1,1,2])         # [1,2]
toset(["a","b","a"])     # {"a","b"}
tolist(var.set)          # 转为 list
tomap({a="1"})           # 转为 map
merge(map1, map2)        # 合并 map
keys(var.map)            # map 的 key 列表
values(var.map)          # map 的 value 列表
lookup(var.map, "key", "default")

# 文件与编码
file("path/to/file")    # 读取文件内容
templatefile("tpl.tftpl", {var="val"})
jsonencode({a=1})        # 编码为 JSON 字符串
jsondecode(string)       # 解码 JSON 字符串
base64encode("str")
base64decode("str")

# 数字
max(1, 2, 3)             # 3
min(1, 2, 3)             # 1
ceil(1.2)                # 2
floor(1.9)               # 1

# 类型转换
tostring(42)             # "42"
tonumber("42")           # 42
tobool("true")           # true
```
