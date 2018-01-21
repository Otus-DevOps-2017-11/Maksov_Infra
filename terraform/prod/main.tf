provider "google" {
  version = "1.4.0"
  project = "${var.project}"
  region  = "${var.region}"
}

terraform {
  backend "gcs" {
    bucket  = "maksov"
    prefix  = "terraform/prod/terraform.tfstate"
    project = "infra-188917"
  }
}

module "app" {
  source            = "../modules/app"
  private_key_path  = "${var.private_key_path}"
  zone_app          = "${var.zone_default}"
  name_app          = "reddit-app-prod"
  app_disk_image    = "reddit-app-base"
  machine_type_app  = "${var.machine_type_default}"
  tags_app          = ["reddit-app", "prod-app", "default-allow-http", "default-allow-http"]
  name_firewall_app = "allow-puma-production"
  ports_app         = ["9292"]
  source_ranges     = ["94.50.193.157/32"]
  target_tags       = ["reddit-app-prod"]
}

module "db" {
  source            = "../modules/db"
  private_key_path  = "${var.private_key_path}"
  zone              = "${var.zone_default}"
  name_db           = "reddit-db-prod"
  db_disk_image     = "reddit-db-base"
  machine_type_db   = "${var.machine_type_default}"
  tags_db           = ["reddit-db", "prod-db"]
  name_firewall_db  = "allow-mongo-production"
  firewall_db_ports = ["27017"]
  target_tags_db    = ["reddit-db-prod"]
  source_tags_db    = ["reddit-app-prod"]
}
