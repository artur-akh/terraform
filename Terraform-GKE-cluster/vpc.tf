# VPC - просто создаем VPC сеть
resource "google_compute_network" "vpc" {
  name                    = "${var.project_id}-vpc"
  auto_create_subnetworks = "false"
}

# Subnet - создаем подсеть с адресом сеть из переменной subnet_cidr
resource "google_compute_subnetwork" "subnet" {
  name          = "${var.project_id}-subnet"
  region        = var.region
  network       = google_compute_network.vpc.name
  ip_cidr_range = var.subnet_cidr
}
# Создаем Router
# resource "google_compute_router" "router" {
#   name    = "my-router"
#   network = google_compute_network.vpc.name
  
# }

# # создаем NAT
# resource "google_compute_router_nat" "nat" {
#   name                               = "my-router-nat"
#   router                             = google_compute_router.router.name
#   region                             = google_compute_router.router.region
#   nat_ip_allocate_option             = "AUTO_ONLY"
#   source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
# }