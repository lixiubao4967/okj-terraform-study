# Lab 03：State 管理

## 学习目标

- 深刻理解 terraform.tfstate 的结构和作用
- 掌握 terraform state 系列命令
- 理解状态漂移（drift）及其处理方式
- 了解 Remote Backend 的概念（本地模拟）

## 什么是 State？

State 是 Terraform 维护的"当前世界"快照。它记录了：
1. 你的配置（.tf 文件）定义了什么资源
2. Terraform 实际创建的资源的属性（ID、IP 等）
3. 配置与真实资源之间的映射关系

**没有 State，Terraform 无法知道它之前创建了什么。**

```
.tf 文件 (期望状态)
    ↕  terraform plan/apply
terraform.tfstate (已知状态)
    ↕  terraform apply -refresh-only
真实资源 (实际状态)
```

## 状态漂移 (Drift)

当真实资源被手动修改（不通过 Terraform），就产生了漂移：

```
tfstate 说：文件内容是 "Hello"
真实文件：内容是 "Hello World"  ← 漂移！
```

处理漂移：
- `terraform apply -refresh-only`：接受漂移，更新 state
- `terraform apply`：以 .tf 文件为准，覆盖漂移

---

## 任务 1：观察 State 文件结构

```bash
cd labs/03-state
terraform init
terraform apply -auto-approve

# 查看状态文件
cat terraform.tfstate | python3 -m json.tool
```

观察 state 文件中：
- `version`：state 文件格式版本
- `terraform_version`：使用的 terraform 版本
- `resources`：资源列表，每个资源包含 `instances[].attributes`
- `dependencies`：资源间的依赖关系

---

## 任务 2：使用 state 命令

```bash
# 列出所有资源
terraform state list

# 查看某个资源的详细信息
terraform state show local_file.app

# 导出完整 state（JSON 格式）
terraform state pull

# 尝试重命名资源（不会影响实际文件）
terraform state mv local_file.app local_file.app_renamed
terraform state list   # 确认已重命名
terraform state mv local_file.app_renamed local_file.app  # 改回来
```

---

## 任务 3：演示状态漂移

```bash
# 1. 先 apply 创建文件
terraform apply -auto-approve

# 2. 手动修改文件（模拟漂移）
echo "MANUALLY MODIFIED" > /tmp/tf-state-demo/app.txt

# 3. 检测漂移
terraform plan   # 会看到 "drift detected"

# 4. 用两种方式处理漂移：
# 方式 A：以 .tf 为准（覆盖手动修改）
terraform apply -auto-approve

# 方式 B：接受漂移（更新 state 但不修改资源）
# 先手动改回去再测试
echo "MANUALLY MODIFIED" > /tmp/tf-state-demo/app.txt
terraform apply -refresh-only
cat terraform.tfstate | python3 -m json.tool | grep content
```

---

## 任务 4：terraform state rm 和 import

```bash
# 1. apply 创建资源
terraform apply -auto-approve

# 2. 从 state 中移除一个资源（注意：不会删除实际文件）
terraform state rm local_file.extra
ls /tmp/tf-state-demo/extra.txt  # 文件还在！
terraform state list              # 但 state 中没有了

# 3. plan 会说要重新创建它
terraform plan

# 4. 用 import 把它重新导入 state
terraform import local_file.extra /tmp/tf-state-demo/extra.txt
terraform state list    # 又回来了
terraform plan          # 应该是 No changes
```

---

## 任务 5：了解 Remote Backend（概念演示）

查看 `backend.tf.example` 文件，了解 S3 远程 Backend 的配置方式。

**为什么需要 Remote Backend？**

| 问题 | Remote Backend 解决方案 |
|------|------------------------|
| state 文件在本地，团队无法共享 | state 存在 S3，所有人访问同一份 |
| 多人同时运行会损坏 state | DynamoDB 实现 state 锁 |
| state 包含敏感信息放本地不安全 | S3 加密 + 权限控制 |
| 本地文件可能丢失 | S3 自动备份 + 版本控制 |

---

## 检查清单

- [ ] 能解释 tfstate 文件的结构和作用？
- [ ] `terraform state rm` 和 `terraform destroy` 的区别？
- [ ] 什么是状态漂移？如何检测？两种处理方式分别是什么？
- [ ] 为什么不应该手动编辑 tfstate 文件？
- [ ] Remote Backend 解决了什么问题？
