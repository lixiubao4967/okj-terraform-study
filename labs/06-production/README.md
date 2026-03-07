# Lab 06：生产实践

## 学习目标

- 掌握生产级项目目录结构
- 理解多环境管理的最佳实践
- 掌握代码质量工具（fmt / validate / tflint）
- 了解 Terraform Test 框架
- 了解 CI/CD 集成模式

---

## 生产级项目结构

### 方案 A：按环境拆目录（推荐）

```
infrastructure/
├── modules/                    # 可复用模块（内部库）
│   ├── vpc/
│   ├── eks/
│   └── rds/
├── environments/
│   ├── dev/
│   │   ├── main.tf             # 调用模块
│   │   ├── variables.tf
│   │   ├── terraform.tfvars
│   │   └── backend.tf          # 指向 dev 的 state
│   ├── staging/
│   │   └── ...
│   └── prod/
│       ├── main.tf
│       ├── terraform.tfvars
│       └── backend.tf          # 指向 prod 的 state（独立 state！）
└── global/                     # 全局资源（IAM、Route53 等）
    └── iam/
```

### 方案 B：Workspace 多环境

```
infrastructure/
├── modules/
├── main.tf
├── variables.tf
├── dev.tfvars
├── staging.tfvars
└── prod.tfvars
```

使用：
```bash
terraform workspace select prod
terraform apply -var-file=prod.tfvars
```

**方案 A 更常用**，因为 prod 和 dev 通常有完全不同的配置，
独立目录更清晰，也防止误操作影响 prod。

---

## 本 Lab 实验内容

本实验演示一个模拟的"完整项目"，包含：
- 规范的目录结构
- 代码格式化与校验
- 简单的 terraform test

```
06-production/
├── README.md
├── modules/
│   └── web-service/            # 模拟 Web 服务模块
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── tests/
│           └── basic.tftest.hcl  # Terraform Test
├── environments/
│   ├── dev/
│   │   ├── main.tf
│   │   ├── terraform.tfvars
│   │   └── providers.tf
│   └── prod/
│       ├── main.tf
│       ├── terraform.tfvars
│       └── providers.tf
└── .github/
    └── workflows/
        └── terraform.yml       # GitHub Actions 示例
```

---

## 任务 1：代码规范

```bash
# 格式化所有 tf 文件
terraform fmt -recursive

# 检查语法
terraform validate

# 如果安装了 tflint
# brew install tflint
# tflint --init
# tflint
```

---

## 任务 2：运行 Dev 环境

```bash
cd labs/06-production/environments/dev
terraform init
terraform plan
terraform apply -auto-approve
terraform output
```

---

## 任务 3：运行 Prod 环境

```bash
cd labs/06-production/environments/prod
terraform init
terraform plan
terraform apply -auto-approve
terraform output
```

对比 dev 和 prod 的输出差异（instance_count、log_level 等）。

---

## 任务 4：运行 Terraform Test（v1.6+）

```bash
cd labs/06-production/modules/web-service
terraform test
```

查看 `tests/basic.tftest.hcl`，理解测试的结构：
- `run` 块：执行一次 apply
- `assert` 块：断言某个值符合预期

---

## 任务 5：阅读 CI/CD 配置

查看 `.github/workflows/terraform.yml`，理解：
- PR 时自动运行 `terraform plan` 并评论结果
- merge 到 main 时自动 apply
- 如何安全地传入 AWS 凭证（OIDC，不存储长期密钥）

---

## 生产安全清单

- [ ] State 文件存在 Remote Backend，启用加密和版本控制
- [ ] State 访问权限最小化（不是所有人都能 apply prod）
- [ ] 不在代码中 hardcode 任何密钥或密码
- [ ] `prevent_destroy = true` 保护关键资源
- [ ] PR review 流程：plan 结果必须经人工审核
- [ ] 锁定 Provider 版本（`version = "= 5.31.0"` 而不是 `~> 5.0`）
- [ ] 锁定 Terraform 版本（`.terraform-version` 文件 + `required_version`）
- [ ] 定期运行 `terraform apply -refresh-only` 检测漂移
- [ ] 敏感输出标记 `sensitive = true`
- [ ] 生产变更有回滚计划（利用 state 版本历史）

---

## 检查清单

- [ ] 方案 A（按环境拆目录）和方案 B（Workspace）各自的优缺点？
- [ ] 为什么 prod 和 dev 应该使用独立的 Remote Backend？
- [ ] `terraform fmt` 应该在什么时候运行？如何强制执行？
- [ ] Terraform Test 的 `run` 块做了什么？
- [ ] CI/CD 中如何避免在代码中暴露 AWS 密钥？
