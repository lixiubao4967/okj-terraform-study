# Lab 07：LocalStack 实战

## 学习目标

- 使用真实 AWS Provider（对接 LocalStack）
- 掌握 S3、DynamoDB、IAM 资源的基本写法
- 理解生产中 state 远程存储 + lock 的原理

## 前置条件

LocalStack 必须已启动：

```bash
docker compose up -d
# 验证
curl http://localhost:4566/_localstack/health
```

## 任务 1：初始化并部署

```bash
cd labs/07-localstack
terraform init
terraform plan
terraform apply -auto-approve
terraform output
```

## 任务 2：验证资源

用 awslocal（或 aws cli 指定 endpoint）验证资源是否真实创建：

```bash
# 安装 awslocal（LocalStack 的 aws cli 封装）
pip install awscli-local

# 查看 S3 bucket
awslocal s3 ls

# 查看上传的文件
awslocal s3 cp s3://myapp-dev-bucket/config/app.json -

# 查看 DynamoDB 表
awslocal dynamodb list-tables

# 查看 IAM Role
awslocal iam list-roles
```

## 任务 3：理解 state lock

`aws_dynamodb_table.state_lock` 就是生产中 S3 backend 配套的 lock 表：

```hcl
# 真实项目的 backend 配置（本 lab 注释掉，因为 LocalStack 免费版不支持 backend）
# backend "s3" {
#   bucket         = "myapp-dev-bucket"
#   key            = "terraform.tfstate"
#   region         = "us-east-1"
#   dynamodb_table = "myapp-dev-state-lock"
#   endpoint       = "http://localhost:4566"
# }
```

多人同时 apply 时，DynamoDB 会加锁，防止 state 被并发写入损坏。

## 检查清单

- [ ] S3、DynamoDB、IAM 资源各自的用途？
- [ ] `aws_iam_role_policy` 中 Resource 为什么要同时包含 bucket ARN 和 `/*`？
- [ ] 为什么生产中 state 要放在 S3 而不是本地？
- [ ] DynamoDB state lock 解决了什么问题？
