# Lab 02：变量与输出

## 学习目标

- 掌握 input variable 的定义与使用
- 理解变量类型系统（string/number/bool/list/map/object）
- 掌握 locals 的使用场景
- 掌握 output 输出值
- 理解变量赋值的优先级

## 变量赋值优先级（从低到高）

```
默认值(default) < terraform.tfvars < *.auto.tfvars < -var-file < -var < 环境变量(TF_VAR_)
```

## 文件说明

```
02-variables/
├── README.md
├── providers.tf
├── variables.tf       # 变量声明
├── locals.tf          # 本地计算值
├── main.tf            # 主配置
├── outputs.tf         # 输出声明
├── terraform.tfvars   # 默认变量值（已提供）
└── prod.tfvars        # 生产环境变量（练习用）
```

---

## 任务 1：理解变量类型

查看 `variables.tf` 中定义的各种变量类型，然后：

```bash
cd labs/02-variables
terraform init
terraform plan        # 使用 terraform.tfvars 中的默认值
terraform apply
terraform output      # 查看所有输出
```

---

## 任务 2：传入不同变量值

```bash
# 命令行传入单个变量
terraform plan -var="project_name=my-custom-project"

# 使用 prod.tfvars
terraform plan -var-file="prod.tfvars"

# 环境变量方式
export TF_VAR_project_name="env-project"
terraform plan
unset TF_VAR_project_name
```

**观察：** 不同方式传入的变量，输出结果有何变化？

---

## 任务 3：添加变量校验

在 `variables.tf` 中为 `environment` 变量添加 validation，
要求只允许 `"dev"`, `"staging"`, `"prod"` 三个值：

```hcl
validation {
  condition     = contains(["dev", "staging", "prod"], var.environment)
  error_message = "environment 只能是 dev、staging 或 prod。"
}
```

然后尝试：
```bash
terraform plan -var="environment=invalid"
```

---

## 任务 4：使用 terraform console 调试表达式

```bash
terraform console
```

在 console 中测试以下表达式：
```
> var.tags
> local.common_tags
> merge(var.tags, {Extra = "added"})
> [for k, v in var.tags : "${k}=${v}"]
> length(var.allowed_ports)
```

---

## 任务 5：sensitive 变量

在 `variables.tf` 中添加一个敏感变量：

```hcl
variable "db_password" {
  type      = string
  sensitive = true
  default   = "super-secret-123"
}
```

在 `main.tf` 中使用它，在 `outputs.tf` 中输出它，观察：
- `terraform plan` 中密码是否被隐藏？
- `terraform output db_password` 的行为？
- `terraform output -json` 呢？

---

## 检查清单

- [ ] 能说出变量赋值的 5 种方式和优先级顺序？
- [ ] `locals` 和 `variable` 的区别是什么？
- [ ] 如何输出一个敏感值？有什么风险？
- [ ] `object` 类型变量和 `map` 类型有什么区别？
