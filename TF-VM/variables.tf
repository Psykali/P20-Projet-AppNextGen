#####################
## Ressource Group ##
#####################
variable "location" {
  default = "francecentral"
}

variable "resource_group_name" {
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
########
## VM ##
########
variable "first_vm" {
  default = "skJenkins"
}
variable "second_vm" {
  default = "skAnsible"
}
################
## Networking ##
################
variable "subnet" {
  default = "skwpp20subnet"
}

variable "virtual_network_name" {
  default = "skwpp20vnet"
}

variable "network_security_group_name" {
  default = "skwpp20nsg"
}
