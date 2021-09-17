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

module "cluster" {
  source          = "../shared/cluster"
  gcp_project_id  = "${var.gcp_project_id}"
  gcp_region      = "${var.gcp_region}"
  gcp_zone        = "${var.gcp_zone}"
}

output "kubeconfig_path" {
  value = "${module.cluster.kubeconfig_path}"
}

output "gcp_network" {
  value = "${module.cluster.gcp_network}"
}
