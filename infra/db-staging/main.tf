variable "gcp_project_id" {
  type        = "string"
  description = "The project ID where we'll create the GKE cluster and related resources. This value is set in the project level garden.yml"
}

variable "gcp_region" {
  type        = "string"
  description = "The region where we'll create your resources (e.g. us-central1). This value is set in the project level garden.yml"
}

variable "gcp_zone" {
  type        = "string"
  description = "The zone where we'll create your resources (e.g. us-central1-b). This value is set in the project level garden.yml"
}

variable "gcp_network" {
  type        = "string"
  description = "The GCP network to use, created by the cluster-dev module. This value is set in the module level garden.yml"
}

module "db" {
  source          = "../shared/db"
  gcp_project_id  = "${var.gcp_project_id}"
  gcp_region      = "${var.gcp_region}"
  gcp_zone        = "${var.gcp_zone}"
  gcp_network     = "${var.gcp_network}"
}

output "db_host_ip" {
  value = "${module.db.host_ip}"
}

output "db_username" {
  value = "${module.db.username}"
}

output "db_password" {
  value = "${module.db.password}"
}
