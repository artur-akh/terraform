# GKE cluster
# Создаем GKE cluster
resource "google_container_cluster" "primary" {
  name     = "${var.project_id}-gke"
  # location = var.region
  location = var.region_zone       # выбираем регион
  
  remove_default_node_pool = true
  initial_node_count       = var.gke_initial_node_count       # количество нодов при установке кластера
  
  network    = google_compute_network.vpc.name                # сеть с которой будет связан
  subnetwork = google_compute_subnetwork.subnet.name          # подсеть с которой связан
}

# Separately Managed Node Pool
# Создание нодов
resource "google_container_node_pool" "primary_nodes" {
  name       = google_container_cluster.primary.name
  # location   = var.region
  location   = var.region_zone                              # в каком регионе
  cluster    = google_container_cluster.primary.name        # с каким кластером связан
  node_count = var.gke_num_nodes                            # количество нодов, можно будет менять данную переменную, чтобы уменьшить или повысить количество нодов

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
    labels = {
      env = var.project_id
    }

    # preemptible  = true
    machine_type = "e2-medium"                             # тип мощности серверов
    disk_size_gb = 40                                      # размер диска
    tags         = ["gke-node", "${var.project_id}-gke"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  } 
}


# # Kubernetes provider
# # The Terraform Kubernetes Provider configuration below is used as a learning reference only. 
# # It references the variables and resources provisioned in this file. 
# # We recommend you put this in another file -- so you can have a more modular configuration.
# # https://learn.hashicorp.com/terraform/kubernetes/provision-gke-cluster#optional-configure-terraform-kubernetes-provider
# # To learn how to schedule deployments and services using the provider, go here: https://learn.hashicorp.com/tutorials/terraform/kubernetes-provider.

# provider "kubernetes" {
#   load_config_file = "false"

#   host     = google_container_cluster.primary.endpoint
#   username = var.gke_username
#   password = var.gke_password

#   client_certificate     = google_container_cluster.primary.master_auth.0.client_certificate
#   client_key             = google_container_cluster.primary.master_auth.0.client_key
#   cluster_ca_certificate = google_container_cluster.primary.master_auth.0.cluster_ca_certificate
# }

