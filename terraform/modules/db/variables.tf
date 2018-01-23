variable name_db {
  description = "Name DB Instance"
}

variable machine_type_db {
  description = "Machine type of DB instance"
}

variable tags_db {
  description = "DB instance's tags"
  default = []
}

variable name_firewall_db {
  description = "Name of firewall rule for access to DB"
}

variable firewall_db_ports {

  description = "Firewall access port to DB"
  default = []

}

variable target_tags_db {
  description = "Target tags db"
  default = []
}

variable source_tags_db {
  description = "Source tags for access of instances to the DB"
  default =  []
}


variable zone {
  description = "Zone"
}

variable db_disk_image {
  description = "Disk image for reddit db"
}
