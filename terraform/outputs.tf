output "reddit_global_ip" {
  value = "${google_compute_global_forwarding_rule.default.ip_address}"
}

output "reddit_app_ip" {
  value = "${google_compute_instance.app.*.network_interface.0.access_config.0.nat_ip}"
}
