#####################
## Ressource Group ##
#####################
variable "location" {
  type        = string
  default = "francecentral"
}

variable "resource_group_name" {
  type        = string
  default = "PERSO_SIEF"
}
############
## Admin  ##
############
variable "admin_username" {
  default = "SkLoginDipP20"
}

variable "admin_password" {
  default = "gqtErHR7Khdz!3B#M@waw"
}
#########################
## Container Registrey ##
#########################
variable "contreg_name" {
  type        = string
  default = "hcovnxk8s"
}

variable "location_contreg" {
  type        = string
  default = "westeurope"
}

###############
## Azure AKS ##
###############
variable "kubernetes_cluster_name" {
  type        = string
  default = "skprjcluster"
}

variable "dns_prefix" {
  type        = string
  default = "skcluster"
}

variable "node_pool_name" {
  type        = string
  default = "skclusterpl"
}

variable "namespace_name" {
  type        = string
  default = "skclusterappli"
}