resource "google_compute_instance" "db" {
  name         = "${var.name_db}"
  machine_type = "${var.machine_type_db}"
  zone         = "${var.zone}"
  tags         = "${var.tags_db}"

  boot_disk {
    initialize_params {
      image = "${var.db_disk_image}"
    }
  }

  network_interface {
    network       = "default"
    access_config = {}
  }

  connection {
    type        = "ssh"
    user        = "Maksim"
    agent       =  false
    private_key = "${file(var.private_key_path)}"

   }

   provisioner "remote-exec" {
    script = "${path.module}/files/install_mongodb.sh"
   }

}

resource "google_compute_firewall" "firewall_db" {
  name    = "${var.name_firewall_db}"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = "${var.firewall_db_ports}"
  }

  # правило применимо к инстансам с тегом ...
  target_tags = "${var.target_tags_db}"

  # порт будет доступен только для инстансов с тегом ...
  source_tags = "${var.source_tags_db}"

}
