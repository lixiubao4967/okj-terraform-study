# ============================================================
# Module: app-config
# 生成应用配置文件
# ============================================================

resource "random_id" "app_id" {
  byte_length = 4
}

resource "local_file" "config" {
  filename = "${var.output_dir}/${var.app_name}-${var.environment}.json"
  content = jsonencode(merge({
    app_name       = var.app_name
    environment    = var.environment
    instance_count = var.instance_count
    app_id         = random_id.app_id.hex
    created_at     = timestamp()
  }, var.extra_config))
}
