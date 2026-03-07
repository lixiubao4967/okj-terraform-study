# Terraform Test (v1.6+)
# 运行方式：在 modules/web-service 目录下执行 terraform test

# 测试 1：基本功能
run "creates_service_config" {
  variables {
    service_name   = "test-service"
    environment    = "dev"
    instance_count = 2
  }

  assert {
    condition     = output.is_production == false
    error_message = "dev 环境不应该是 production"
  }

  assert {
    condition     = length(output.service_id) > 0
    error_message = "service_id 不应该为空"
  }
}

# 测试 2：生产环境标记
run "prod_environment_flag" {
  variables {
    service_name   = "test-service"
    environment    = "prod"
    instance_count = 3
  }

  assert {
    condition     = output.is_production == true
    error_message = "prod 环境应该标记为 is_production=true"
  }
}
