variable "hyperkube_image" {
  default = "quay.io/coreos/hyperkube:v1.6.2_coreos.0"
}

variable "kubelet_image_url" {
  default = "quay.io/coreos/hyperkube"
}

variable "kubelet_image_tag" {
  default = "v1.6.2_coreos.0"
}

variable "etcd_image_url" {
  default = "quay.io/coreos/etcd"
}

variable "etcd_image_tag" {
  default = "v3.1.6"
}

variable "dell_workers" {
  default = 2
}

variable "storage_workers" {
  default = 2
}

variable "atx_workers" {
  default = 1
}
