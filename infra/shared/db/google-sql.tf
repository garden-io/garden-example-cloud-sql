variable "gcp_region" {
  type        = "string"
  description = "The region where we'll create your resources (e.g. us-central1)."
}

variable "gcp_project_id" {
  type        = "string"
  description = "The project ID where we'll create the GKE cluster and related resources."
}

variable "gcp_zone" {
  type        = "string"
  description = "The zone where we'll create your resources (e.g. us-central1-b)."
}

variable "gcp_network" {
  type        = "string"
  description = "The GCP network to use. Created in cluster/gke.tf"
}

provider "google-beta" {
  project = "${var.gcp_project_id}"
  region  = "${var.gcp_region}"
  zone    = "${var.gcp_zone}"
}

resource "google_compute_global_address" "private_ip_address" {
  provider = "google-beta"

  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = "${var.gcp_network}"
}

resource "google_service_networking_connection" "private_vpc_connection" {
  provider = "google-beta"

  network                 = "${var.gcp_network}"
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = ["${google_compute_global_address.private_ip_address.name}"]
}

resource "random_id" "db_name_suffix" {
  byte_length = 4
}

resource "google_sql_database_instance" "instance" {
  provider = "google-beta"

  name              = "private-instance-${random_id.db_name_suffix.hex}"
  database_version  = "POSTGRES_11"
  region            = "${var.gcp_region}"

  depends_on = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled    = false
      private_network = "${var.gcp_network}"
    }
  }
}

resource "google_sql_user" "users" {
  name     = "demo"
  instance = "${google_sql_database_instance.instance.name}"
  password = "changeme"
  project  = "${var.gcp_project_id}"
}

output "host_ip" {
  value = "${google_sql_database_instance.instance.private_ip_address}"
}

output "username" {
  value = "${google_sql_user.users.name}"
}

output "password" {
  value = "${google_sql_user.users.password}"
}
