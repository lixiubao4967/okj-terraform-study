module "frontend" {
  source         = "../../modules/web-service"
  service_name   = "frontend"
  environment    = "prod"
  instance_count = 3 # prod 多实例
  log_level      = "warn"
}

module "backend" {
  source         = "../../modules/web-service"
  service_name   = "backend"
  environment    = "prod"
  instance_count = 5
  log_level      = "warn"
}

output "frontend_id" {
  value = module.frontend.service_id
}

output "is_production" {
  value = module.frontend.is_production
}
