# for VPC.tf 
variable "project_id" {
  description = "project id"
}

variable "region" {
  description = "region"
}

variable "region_zone" {
  description = "region_zone"
}

# for GKE.tf 
variable "gke_username" {
  default     = ""
  description = "gke username"
}

variable "gke_password" {
  default     = ""
  description = "gke password"
}

variable "gke_initial_node_count" {
  default     = 1
  description = "number of gke nodes"
}

variable "gke_num_nodes" {
  default     = 1
  description = "number of gke nodes"
}
  
# for VPC
variable "subnet_cidr" {
  type    = string
  default = "10.10.0.0/24"
}
