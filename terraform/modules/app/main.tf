resource "google_compute_instance" "app" {
  name         = "${var.name_app}"
  machine_type = "${var.machine_type_app}"
  zone         = "${var.zone_app}"
  tags         = "${var.tags_app}"

  boot_disk {
    initialize_params {
      image = "${var.app_disk_image}"
    }
  }

  network_interface {
    network = "default"

    access_config = {
      nat_ip = "${google_compute_address.app_ip.address}"
    }
  }

  connection {
    type        = "ssh"
    user        = "Maksim"
    agent       =  false
    private_key = "${file(var.private_key_path)}"

   }

  provisioner "remote-exec" {
    inline = [
      "sudo bash -c 'echo DATABASE_URL=${var.ip_db} >> /etc/bash.profile'",
      "export DATABASE_URL=${var.ip_db}",
      "sudo systemctl restart puma"
    ]
  }

}

resource "google_compute_address" "app_ip" {
  name = "app-ip"
}

resource "google_compute_firewall" "firewall_app" {
  name    = "${var.name_firewall_app}"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = "${var.ports_app}"
  }

  source_ranges = "${var.source_ranges}"
  target_tags   = "${var.target_tags}"
}
