variable project {
  description = "ID Project"
}

variable zone_default {
  description = "Zone"
  default     = "us-east1-d"
}

variable region {
  description = "Region"
  default     = "us-east1"
}

variable user_ssh {
  description = "Name of ssh user"
}

variable public_key_path {
  description = "Path to public ssh key"
}

variable private_key_path {
  description = "Path to private ssh key"
}

variable source_ranges_default {
  description = "Default source ranges"
  default     = ["0.0.0.0/0"]
}

variable machine_type_default {
  description = "Machine type of instance"
  default     = "g1-small"
}
