# Terraform 系统学习计划

本项目是一套从零到精通的 Terraform 实战课程，分为 5 个阶段，每个阶段包含理论学习和动手实验。

---

## 学习路线总览

```
Phase 1: 基础入门     (第 1-2 天)  —— HCL 语法、工作流、Provider
Phase 2: 核心概念     (第 3-5 天)  —— 变量、输出、State、生命周期
Phase 3: 模块化       (第 6-8 天)  —— Module 编写与复用
Phase 4: 高级特性     (第 9-12 天) —— 动态块、条件、循环、远程后端
Phase 5: 生产实践     (第 13-15 天)—— 工程化结构、安全、CI/CD
```

每个阶段对应 `labs/` 目录下的一个子目录，进入目录后按 README 指引完成实验。

---

## 目录结构

```
.
├── README.md              # 本文件：总学习计划
├── labs/
│   ├── 01-basics/         # Phase 1：基础入门
│   ├── 02-variables/      # Phase 2a：变量与输出
│   ├── 03-state/          # Phase 2b：State 管理
│   ├── 04-modules/        # Phase 3：模块化
│   ├── 05-advanced/       # Phase 4：高级特性
│   └── 06-production/     # Phase 5：生产实践
└── cheatsheet.md          # 常用命令速查表
```

---

## 环境准备

```bash
# 安装 Terraform (macOS)
brew tap hashicorp/tap
brew install hashicorp/tap/terraform

# 验证安装
terraform version

# 本课程大部分实验使用 local / random / null provider
# 无需 AWS 账号即可完成 Phase 1-4
# Phase 5 可选：使用 LocalStack 模拟 AWS 环境（推荐），或配置真实 AWS CLI

# 安装 LocalStack（模拟 AWS，无需真实账号）
brew install localstack/tap/localstack-cli

# 启动 LocalStack（-d 表示后台运行）
localstack start -d

# 验证服务状态
localstack status services
```

---

## Phase 1：基础入门

**目标：** 理解 IaC 理念，掌握 Terraform 核心工作流。

### 核心概念
| 概念 | 说明 |
|------|------|
| IaC (Infrastructure as Code) | 用代码描述和管理基础设施 |
| Provider | Terraform 与外部 API 的适配层（AWS、GCP、local...） |
| Resource | 基础设施的最小单元 |
| HCL | HashiCorp Configuration Language，Terraform 的配置语言 |
| `terraform init` | 初始化工作目录，下载 Provider |
| `terraform plan` | 预览变更，不执行 |
| `terraform apply` | 执行变更 |
| `terraform destroy` | 销毁所有资源 |

### 任务
进入 `labs/01-basics/` 完成实验，详见该目录的 README。

---

## Phase 2a：变量与输出

**目标：** 让配置可参数化、可复用。

### 核心概念
| 概念 | 说明 |
|------|------|
| `variable` | 输入变量，类型：string/number/bool/list/map/object |
| `output` | 输出值，供外部引用或打印 |
| `locals` | 本地计算值，避免重复表达式 |
| `terraform.tfvars` | 变量赋值文件，自动加载 |
| `*.auto.tfvars` | 同上，多文件自动加载 |
| `-var` / `-var-file` | 命令行传入变量 |

### 任务
进入 `labs/02-variables/` 完成实验。

---

## Phase 2b：State 管理

**目标：** 理解 Terraform State 的本质，掌握状态操作。

### 核心概念
| 概念 | 说明 |
|------|------|
| `terraform.tfstate` | 状态文件，记录真实资源与配置的映射 |
| Remote Backend | 将 State 存储在远程（S3、Terraform Cloud...） |
| State Locking | 防止并发写入导致状态损坏 |
| `terraform state list` | 查看状态中的资源列表 |
| `terraform state show` | 查看某资源的详细状态 |
| `terraform state mv` | 重命名/移动资源 |
| `terraform state rm` | 从状态中移除资源（不销毁实体） |
| `terraform import` | 将已有资源导入状态 |
| `terraform refresh` | 刷新状态（已废弃，用 apply -refresh-only） |

### 任务
进入 `labs/03-state/` 完成实验。

---

## Phase 3：模块化

**目标：** 编写可复用的 Module，理解模块调用与传参。

### 核心概念
| 概念 | 说明 |
|------|------|
| Module | 一组 `.tf` 文件的封装，有输入变量和输出值 |
| Root Module | 直接执行的顶层配置 |
| Child Module | 被调用的子模块 |
| `source` | 模块来源：本地路径、Git URL、Terraform Registry |
| `module.<name>.<output>` | 引用子模块的输出 |

### 任务
进入 `labs/04-modules/` 完成实验。

---

## Phase 4：高级特性

**目标：** 掌握表达式、循环、条件、动态块等高级用法。

### 核心概念
| 概念 | 说明 |
|------|------|
| `count` | 创建多个相同资源 |
| `for_each` | 用 map/set 驱动多资源，推荐替代 count |
| `for` 表达式 | 变换 list/map |
| `dynamic` 块 | 动态生成嵌套块 |
| `condition ? true : false` | 三元运算符 |
| `lifecycle` | `create_before_destroy` / `prevent_destroy` / `ignore_changes` |
| `depends_on` | 显式依赖声明 |
| `data` | 查询已有资源，不创建 |
| `templatefile()` | 渲染模板文件 |
| `sensitive` | 标记敏感变量，隐藏输出 |

### 任务
进入 `labs/05-advanced/` 完成实验。

---

## Phase 5：生产实践

**目标：** 掌握工程化项目结构、安全配置、CI/CD 集成。

### 核心概念
- 大型项目目录结构（按环境/按功能拆分）
- Remote Backend（S3 + DynamoDB 锁）
- Workspace 多环境管理
- 敏感数据管理（不 hardcode 密钥）
- `terraform fmt` / `terraform validate` / `tflint`
- `terraform test` (v1.6+)
- GitHub Actions 集成 Terraform

### 任务
进入 `labs/06-production/` 完成实验。

---

## LocalStack 使用指南

LocalStack 在本地模拟 AWS 服务（S3、DynamoDB、SQS、Lambda 等），无需真实 AWS 账号。

### 安装与启动

```bash
# 安装
brew install localstack/tap/localstack-cli

# 后台启动
localstack start -d

# 查看服务状态
localstack status services

# 停止
localstack stop
```

### 在 Terraform 中使用

配置 AWS provider 指向本地端点：

```hcl
provider "aws" {
  region                      = "us-east-1"
  access_key                  = "test"   # 随意填，LocalStack 不校验
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    s3       = "http://localhost:4566"
    dynamodb = "http://localhost:4566"
    sqs      = "http://localhost:4566"
    lambda   = "http://localhost:4566"
  }
}
```

### 验证资源创建

```bash
# 安装 awslocal（awscli 的 LocalStack 封装）
pip install awscli-local

# 示例：查看 S3 bucket
awslocal s3 ls

# 示例：查看 SQS 队列
awslocal sqs list-queues
```

### 支持的服务

S3、DynamoDB、SQS、SNS、Lambda、IAM、EC2、Kinesis 等主流服务均支持。
完整列表见：https://docs.localstack.cloud/references/coverage/

---

## 知识图谱

```
Terraform
├── 语言 (HCL)
│   ├── 类型系统: string / number / bool / list / map / object / tuple / set / any
│   ├── 表达式: 引用、函数、条件、for、splat
│   └── 元参数: count / for_each / provider / depends_on / lifecycle
├── 核心命令
│   ├── init / plan / apply / destroy
│   ├── state (list/show/mv/rm/pull/push)
│   ├── import / output / console / graph
│   └── fmt / validate / test
├── State
│   ├── 本地 Backend
│   ├── 远程 Backend (S3/GCS/AzureRM/Terraform Cloud)
│   └── State Locking
├── Module
│   ├── 本地 Module
│   ├── Registry Module
│   └── Git Module
└── Provider
    ├── AWS / GCP / Azure
    ├── Kubernetes / Helm
    └── local / random / null (练习用)
```

---

## 学习资源

- 官方文档：https://developer.hashicorp.com/terraform/docs
- Terraform Registry：https://registry.terraform.io
- Learn Terraform（官方互动教程）：https://developer.hashicorp.com/terraform/tutorials
- LocalStack（模拟 AWS 本地环境）：https://github.com/localstack/localstack
