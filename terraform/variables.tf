variable "resource_group_name" {
  default     = "tfResourceGroup"
  type        = string
  description = "Name of the resource group"
}

variable "resource_group_location" {
  default     = "Australia Southeast" #also works with AustraliaSoutheast
  type        = string
  description = "Name of the resource group location"
}

variable "virtual_network_name" {
  type        = string
  description = "Name of the Virtual network"
}

variable "subnet_name" {
  type        = string
  description = "Name of the subnet"
}

variable "k8s_cluster_name" {
  type        = string
  description = "Name of the kubernetes cluster"
}

variable "k8s_version" {
  type        = string
  description = "AKS version to be used for provisioning the Kubernetes cluster"
}

variable "k8s_worker_node_count" {
  type        = number
  description = "Number of worker nodes"
}