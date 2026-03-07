module "frontend" {
  source         = "../../modules/web-service"
  service_name   = "frontend"
  environment    = "dev"
  instance_count = 1
  log_level      = "debug"
}

module "backend" {
  source         = "../../modules/web-service"
  service_name   = "backend"
  environment    = "dev"
  instance_count = 1
  log_level      = "debug"
}

output "frontend_id" {
  value = module.frontend.service_id
}

output "backend_config" {
  value = module.backend.config_path
}
