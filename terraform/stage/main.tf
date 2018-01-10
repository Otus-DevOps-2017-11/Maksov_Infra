provider "google" {
  version = "1.4.0"
  project = "${var.project}"
  region  = "${var.region}-d"
}

resource "google_compute_project_metadata" "sshkey" {
  metadata {
    ssh-keys = "Maksim:${file("C:/Users/Maksim/.ssh/Maksim.pub")}"
  }
}

module "app" {
  source          = "modules/app"
  public_key_path = "${var.public_key_path}"
  zone            = "${var.zone}"
  app_disk_image  = "${var.app_disk_image}"
}

module "db" {
  source          = "modules/db"
  public_key_path = "${var.public_key_path}"
  zone            = "${var.zone}"
  db_disk_image   = "${var.db_disk_image}"
}

module "vpc" {
  source = "module/vpc"
}
