# Lab 05：高级特性

## 学习目标

- 掌握 `count` vs `for_each` 的使用场景和区别
- 掌握 `dynamic` 动态块
- 理解 `lifecycle` 规则
- 掌握 `data source` 的使用
- 理解 `templatefile()` 函数
- 掌握 Workspace 多环境管理

## 文件结构

```
05-advanced/
├── README.md
├── providers.tf
├── main.tf
├── variables.tf
├── outputs.tf
└── templates/
    └── app.conf.tftpl     # 模板文件
```

---

## 任务 1：count vs for_each 对比

查看 `main.tf` 中使用 count 和 for_each 的两种方式：

```bash
cd labs/05-advanced
terraform init
terraform apply -auto-approve
terraform state list
```

观察：
- count 创建的资源地址：`local_file.count_demo[0]`, `local_file.count_demo[1]`
- for_each 创建的资源地址：`local_file.foreach_demo["web"]`, `local_file.foreach_demo["api"]`

**测试 count 的缺陷：**

修改 `variables.tf` 中 `servers_count` 的列表，把第一个元素删掉：
```hcl
default = ["api", "worker"]  # 删掉 "web"
```

运行 `terraform plan`，会看到：
- count 方式：Terraform 要修改/重建多个资源（索引发生变化！）
- for_each 方式：只删除 "web" 对应的资源，其他不变

**这是 for_each 优于 count 的核心原因。**

---

## 任务 2：dynamic 块

修改 `main.tf` 中的 `ingress_rules` 变量，添加/删除端口，
观察生成的安全组配置文件内容变化。

---

## 任务 3：lifecycle 规则

取消注释 `main.tf` 中 lifecycle 相关代码，分别测试：
- `prevent_destroy`：尝试 `terraform destroy`，观察报错
- `ignore_changes`：手动修改文件后 `terraform plan`，观察是否检测到变更
- `create_before_destroy`：观察 plan 输出中的操作顺序

---

## 任务 4：templatefile() 函数

`templates/app.conf.tftpl` 是一个配置文件模板，
查看模板语法（`%{for}`, `%{if}`, `${}`），
然后运行 apply 观察生成的配置文件内容。

---

## 任务 5：Workspace 多环境

```bash
# 查看当前 workspace
terraform workspace show   # default

# 创建新 workspace
terraform workspace new staging
terraform workspace new prod

# 列出所有 workspace
terraform workspace list

# 在不同 workspace 中 apply
terraform workspace select staging
terraform apply -auto-approve

terraform workspace select prod
terraform apply -auto-approve

# 观察：每个 workspace 有独立的 state
# .terraform/environment 文件记录当前 workspace
ls terraform.tfstate.d/

# 切换回 default
terraform workspace select default
```

在代码中使用 workspace 名称：
```hcl
locals {
  env = terraform.workspace  # 获取当前 workspace 名
}
```

---

## 检查清单

- [ ] 能说出 `count` 和 `for_each` 各自的适用场景？
- [ ] 为什么从 count 列表中间删除一个元素会导致问题？
- [ ] `dynamic` 块解决了什么问题？
- [ ] `lifecycle.ignore_changes` 什么时候有用？
- [ ] `data source` 和 `resource` 的区别？
- [ ] Workspace 和用多套目录管理多环境的优缺点？
