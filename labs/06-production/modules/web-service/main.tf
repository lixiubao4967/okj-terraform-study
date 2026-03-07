resource "random_id" "service_id" {
  byte_length = 6
}

resource "local_file" "service_config" {
  filename = "${var.output_dir}/${var.environment}/${var.service_name}.json"
  content = jsonencode({
    service_name   = var.service_name
    environment    = var.environment
    instance_count = var.instance_count
    log_level      = var.log_level
    service_id     = random_id.service_id.hex
    is_production  = var.environment == "prod"
  })
}
