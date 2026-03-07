# Lab 01：基础入门

## 学习目标

- 理解 Terraform 核心工作流：init → plan → apply → destroy
- 读懂 HCL 基本语法
- 了解 Provider 的作用
- 查看和理解 terraform.tfstate

## 知识点

### Terraform 工作流

```
写代码(.tf) → terraform init → terraform plan → terraform apply → terraform destroy
                 (下载provider)   (预览变更)       (执行变更)        (清理资源)
```

### HCL 基本结构

```hcl
# 块类型 "资源类型" "本地名称" {
#   参数 = 值
# }

resource "local_file" "example" {
  filename = "/tmp/hello.txt"
  content  = "Hello, Terraform!"
}
```

## 实验内容

本实验使用 `local` provider（操作本地文件）和 `random` provider，
**无需任何云账号**。

### 文件说明

```
01-basics/
├── README.md          # 本文件
├── main.tf            # 主配置
├── providers.tf       # Provider 声明
└── expected/          # 期望的实验结果（答案参考）
```

---

## 任务 1：运行你的第一个 Terraform 配置

**步骤：**

```bash
cd labs/01-basics

# 1. 初始化（下载 provider）
terraform init

# 2. 查看执行计划
terraform plan

# 3. 应用配置
terraform apply

# 4. 查看生成的文件
cat /tmp/terraform-hello.txt

# 5. 查看状态文件
cat terraform.tfstate

# 6. 销毁资源
terraform destroy
```

**观察要点：**
- `terraform plan` 输出中 `+` 表示创建，`-` 表示删除，`~` 表示修改
- `terraform.tfstate` 文件记录了资源的真实状态
- `terraform destroy` 后状态文件会清空

---

## 任务 2：修改资源，观察 plan 的变化

1. 打开 `main.tf`，修改 `local_file` 的 `content` 内容
2. 运行 `terraform plan`，观察输出（应看到 `~` 修改符号）
3. 运行 `terraform apply` 应用修改

**思考：** 为什么修改 `filename` 会触发 `destroy + create`，而修改 `content` 只是 `update`？

---

## 任务 3：探索 terraform console

```bash
terraform apply  # 先确保资源存在

# 进入交互式控制台
terraform console
```

在 console 中尝试：
```
> local_file.hello.content
> local_file.hello.filename
> "hello" == "hello"
> upper("terraform")
> format("I am %s", "learning terraform")
```

---

## 任务 4：使用 random provider

取消注释 `main.tf` 中 `random_pet` 相关的代码，然后：

1. `terraform plan` — 观察新增资源
2. `terraform apply`
3. 多次 `terraform apply`，观察 random_pet 是否改变
4. `terraform destroy -target=random_pet.name` — 只销毁这个资源
5. `terraform plan` — 观察其他资源是否受影响

---

## 检查清单

完成本实验后，你应该能回答：

- [ ] `terraform init` 做了什么？`.terraform` 目录里有什么？
- [ ] `plan` 和 `apply` 的区别是什么？
- [ ] `terraform.tfstate` 的作用是什么？如果删掉它会怎样？
- [ ] 为什么要有 `provider` 块？
- [ ] 如何只销毁特定资源而不影响其他资源？
