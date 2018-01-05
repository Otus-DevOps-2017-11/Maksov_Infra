provider "google" {
  version = "1.4.0"
  project = "${var.project}"
  region  = "${var.region}-d"
}

resource "google_compute_project_metadata" "sshkey1" {

  metadata  {

    ssh-keys  = "Maksim:${file("C:/Users/Maksim/.ssh/Maksim.pub")}"

  }

}

resource "google_compute_firewall" "firewall_puma" {
  name = "allow-puma-default"

  # Название сети, в которой действует правило
  network = "default"

  # Какой доступ разрешить
  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }

  # Каким адресам разрешаем доступ
  source_ranges = ["0.0.0.0/0"]

  # Правило применимо для инстансов с тегом
    target_tags = ["reddit-app"]

}

resource "google_compute_instance" "app" {

  count = "2"
  name         = "reddit-app${count.index+1}"
  machine_type = "g1-small"
  zone         = "${var.zone}-d"


  # определение загрузочного диска
  boot_disk {
    initialize_params {
      image = "${var.disk_image}"
    }
  }

  tags = ["reddit-app"]

  # определение сетевого интерфейса
  network_interface {
    # сеть, к которой присоединить данный интерфейс
    network = "default"

    # использовать ephemeral IP для доступа из Интернет
    access_config {}
  }

  connection {
    type        = "ssh"
    user        = "Maksim"
    agent       = false
    private_key = "${file(var.private_key_path)}"
  }

  provisioner "file" {
    source      = "files/puma.service"
    destination = "/tmp/puma.service"
  }

  provisioner "remote-exec" {
    script = "files/deploy.sh"
  }
}

resource "google_compute_global_address" "global_ip" {
  name = "global-reddit-ip"
}

resource "google_compute_http_health_check" "reddit-health" {
  name         = "reddit-health-check"
  port = "9292"
  timeout_sec        = 1
  check_interval_sec = 1
}

resource "google_compute_instance_group" "webservers" {
  name        = "reddit-group"
  description = "Reddit instance group"

  instances = [
   "${google_compute_instance.app.*.self_link}"
  ]

  named_port {
    name = "reddit-group-port"
    port = "9292"
  }

  zone = "${var.zone}-d"

}

resource "google_compute_backend_service" "reddit-bk" {

  name        = "reddit-backend"
  description = "Our company website"
  port_name   = "reddit-group-port"
  protocol    = "HTTP"
  timeout_sec = 10
  enable_cdn  = false

  backend {
    group = "${google_compute_instance_group.webservers.self_link}"
  }

  health_checks = ["${google_compute_http_health_check.reddit-health.self_link}"]

}

resource "google_compute_url_map" "reddit-map" {
  name        = "urlmap"
  description = "a description"

  default_service = "${google_compute_backend_service.reddit-bk.self_link}"

  }

resource "google_compute_target_http_proxy" "http-reddit-proxy" {
    name        = "reddit-proxy"
    description = "a description"
    url_map     = "${google_compute_url_map.reddit-map.self_link}"
  }

resource "google_compute_global_forwarding_rule" "default" {
    name       = "default-rule"
    target     = "${google_compute_target_http_proxy.http-reddit-proxy.self_link}"
    ip_address = "${google_compute_global_address.global_ip.address}"
    port_range = "80"
}
