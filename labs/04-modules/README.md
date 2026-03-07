# Lab 04：模块化 (Modules)

## 学习目标

- 理解 Module 的结构和作用
- 编写可复用的 Module
- 掌握模块间的输入/输出传递
- 了解公共 Registry Module 的使用

## 什么是 Module？

Module 是一组 `.tf` 文件的封装，就像编程语言中的函数：
- 接收输入（variables）
- 执行逻辑（resources）
- 返回输出（outputs）

```
root module (调用者)
    ├── module "app" { source = "./modules/app" }   # child module
    └── module "network" { source = "./modules/network" }
```

## 文件结构

```
04-modules/
├── README.md
├── providers.tf
├── main.tf                    # Root module，调用子模块
├── variables.tf
├── outputs.tf
└── modules/
    ├── app-config/            # 模块 1：应用配置
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    └── user-manager/          # 模块 2：用户管理
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

---

## 任务 1：运行并理解模块调用

```bash
cd labs/04-modules
terraform init    # 注意：init 会同时初始化子模块
terraform plan
terraform apply
terraform output
```

观察：
- 子模块的资源在 state 中的地址格式：`module.<name>.<type>.<name>`
- `terraform state list` 中模块资源的命名

---

## 任务 2：向模块传入不同参数

在 `main.tf` 中，修改调用 `app-config` 模块的参数：
- 修改 `environment = "staging"`
- 修改 `instance_count = 3`

运行 `terraform plan`，观察哪些资源会变更。

---

## 任务 3：多次实例化同一模块

在 `main.tf` 中，再添加一个 `app-config` 模块的调用，
用不同的名字（如 `module "backend_app"`）并传入不同参数：

```hcl
module "backend_app" {
  source         = "./modules/app-config"
  app_name       = "backend"
  environment    = "dev"
  instance_count = 1
}
```

**这就是模块的核心价值：一次编写，多次复用。**

---

## 任务 4：使用子模块的输出

在 `outputs.tf` 中，输出子模块的输出值：

```hcl
output "backend_config_path" {
  value = module.backend_app.config_file_path
}
```

观察：父模块如何通过 `module.<name>.<output_name>` 引用子模块的输出。

---

## 任务 5：模块版本固定（概念）

查看 `modules/app-config/variables.tf` 的结构，思考：
- 如果模块来自 Git，如何锁定版本？
- `source = "git::https://github.com/org/repo.git?ref=v1.2.0"`
- 如果来自 Terraform Registry：`source = "hashicorp/consul/aws"`, `version = "0.1.0"`

---

## 检查清单

- [ ] Module 的三要素（variables/resources/outputs）各自的作用？
- [ ] `terraform init` 时 Module 被下载到哪里？
- [ ] 如何在 state 中查看某个模块的资源？
- [ ] 父模块如何引用子模块的输出？
- [ ] 同一个 Module 被实例化两次，state 中如何区分？
