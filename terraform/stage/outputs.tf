output "db_external_ip" {
  value = "${module.db.db_external_ip}"
}

output "db_internal_ip" {
  value = "${module.db.db_internal_ip}"
}

output "app_external_ip" {
  value = "${module.app.app_external_ip}"
}

output "app_internal_ip" {
  value = "${module.app.app_internal_ip}"
}
