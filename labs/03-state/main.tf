# ============================================================
# Lab 03 - State 管理
# ============================================================

resource "local_file" "app" {
  filename = "/tmp/tf-state-demo/app.txt"
  content  = "This is the app config. Version: 1.0"
}

resource "local_file" "database" {
  filename = "/tmp/tf-state-demo/database.txt"
  content  = "Database config: host=localhost, port=5432"
}

resource "local_file" "extra" {
  filename = "/tmp/tf-state-demo/extra.txt"
  content  = "Extra config file - we will practice state rm on this one"
}

resource "random_id" "deployment_id" {
  byte_length = 8
}

resource "local_file" "manifest" {
  filename = "/tmp/tf-state-demo/manifest.json"
  content = jsonencode({
    deployment_id = random_id.deployment_id.hex
    files = [
      local_file.app.filename,
      local_file.database.filename,
      local_file.extra.filename,
    ]
  })

  # depends_on 显式声明依赖（虽然通过引用已隐式依赖）
  depends_on = [
    local_file.app,
    local_file.database,
    local_file.extra,
  ]
}
