variable name_app {
  description = "Name application"
}

variable machine_type_app {
  description = "Machine type of instance"
}

variable tags_app {
  description = "instance's tags"
  default     = []
}

variable name_firewall_app {
  description = "Name of firewall rule for access to the application"
}

variable source_ranges {
  description = "sdsd"
  default     = ["0.0.0.0/0"]
}

variable ports_app {
  description = "Access port of application"
  default     = []
}

variable target_tags {
  description = "Target tags app"
  default     = []
}

variable private_key_path {
  description = "Path to the private key used to connect provision to instance"
}

variable zone_app {
  description = "Zone"
}

variable app_disk_image {
  description = "Disk image for reddit app"
  default     = "reddit-app-base"
}
