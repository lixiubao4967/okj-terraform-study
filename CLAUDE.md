# CLAUDE.md

## 项目简介

这是一个 Terraform 系统学习项目，包含从入门到生产实践的 6 个阶段实验。

## 目录结构

```
labs/01-basics/       # Phase 1：基础入门
labs/02-variables/    # Phase 2a：变量与输出
labs/03-state/        # Phase 2b：State 管理
labs/04-modules/      # Phase 3：模块化
labs/05-advanced/     # Phase 4：高级特性
labs/06-production/   # Phase 5：生产实践
```

每个 Lab 都有独立的 `README.md`（任务说明）、`providers.tf`、`main.tf` 等文件。

## 重要约定

- 所有 Lab 使用 `local` + `random` provider，无需云账号即可运行（Phase 1-4）
- 生成的临时文件统一输出到 `/tmp/` 下各子目录，不提交到 git
- 每个 Lab 目录下的 `terraform.tfstate` 不提交（已在 .gitignore 排除）
- `backend.tf.example` 文件是示例，不会被 terraform 加载

## 协作规范

- 修改 Lab 内容时，先阅读该 Lab 的 `README.md` 了解学习目标
- 新增 Lab 时，目录命名格式为 `labs/NN-topic-name/`，必须包含 `README.md`
- `cheatsheet.md` 是速查表，保持简洁，不重复 README 中的内容

## 用户偏好

- 使用中文沟通
- 回答简洁，不废话
