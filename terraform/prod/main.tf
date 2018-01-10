provider "google" {
  version = "1.4.0"
  project = "${var.project}"
  region  = "${var.region}-d"
}

resource "google_compute_project_metadata" "sshkey" {
  metadata {
    ssh-keys = "${var.user_ssh}:${file(var.public_key_path)}"
  }
}

module "app" {
  source          = "../modules/app"
  public_key_path = "${var.public_key_path}"
  zone_app            = "${var.zone_default}"
  name_app = "reddit-app"
  app_disk_image  = "reddit-app-base"
  machine_type_app = "${var.machine_type_default}"
  tags_app = ["reddit-app"]
  name_firewall_app = "allow-puma-default"
  ports_app = ["9292"]
  source_ranges = "${var.source_ranges_default}"
  target_tags = ["reddit-app"]
}

module "db" {
  source          = "../modules/db"
  public_key_path = "${var.public_key_path}"
  zone            = "${var.zone_default}"
  name_db       = "reddit-db"
  db_disk_image   = "reddit-db-base"
  machine_type_db = "${var.machine_type_default}"
  tags_db = ["reddit-db"]
  name_firewall_db = "allow-mongo-default"
  firewall_db_ports     =  ["27017"]
  target_tags_db = ["reddit-db"]
  source_tags_db = ["reddit-app"]

}

module "vpc" {
  source = "../modules/vpc"
}
