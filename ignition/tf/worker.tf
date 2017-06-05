data "ignition_config" "dell-worker" {
  count = "${var.dell_workers}"
  disks = [
    "${data.ignition_disk.devsda.id}",
  ]

  filesystems = [
    "${data.ignition_filesystem.root.id}",
  ]

  files = [
    "${data.ignition_file.kube-proxy-worker.id}",
    "${data.ignition_file.worker-kubeconfig.id}",
    "${data.ignition_file.worker-machine-role.id}",
    "${element(data.ignition_file.dell-hostname.*.id, count.index)}",
  ]

  systemd = [
    "${data.ignition_systemd_unit.kubelet-worker.id}",
    "${data.ignition_systemd_unit.get-ssl-worker.id}",
  ]
}

data "ignition_config" "atx-worker" {
  count = "${var.atx_workers}"
  disks = [
    "${data.ignition_disk.nvme0n1.id}",
  ]

  filesystems = [
    "${data.ignition_filesystem.nvme0n1root.id}",
  ]

  files = [
    "${data.ignition_file.kube-proxy-worker.id}",
    "${data.ignition_file.worker-kubeconfig.id}",
    "${data.ignition_file.worker-machine-role.id}",
    "${element(data.ignition_file.atx-hostname.*.id, count.index)}",
  ]

  systemd = [
    "${data.ignition_systemd_unit.kubelet-worker.id}",
    "${data.ignition_systemd_unit.get-ssl-worker.id}",
  ]
}

data "ignition_disk" "nvme0n1" {
  device     = "/dev/nvme0n1"
  wipe_table = true

  partition {
    label = "ROOT"
  }
}

data "ignition_filesystem" "nvme0n1root" {
  name = "root"

  mount {
    device  = "/dev/nvme0n1p1"
    format  = "ext4"
    create  = true
    force   = true
    options = ["-L", "ROOT"]
  }
}

data "template_file" "kube-proxy-worker" {
  template = "${file("resources/manifests/worker/kube-proxy.yaml")}"

  vars {
    hyperkube_image = "${var.hyperkube_image}"
  }
}

data "ignition_file" "kube-proxy-worker" {
  filesystem = "root"
  mode       = 644
  path       = "/etc/kubernetes/manifests/kube-proxy.yaml"
  content = {
  content    = "${data.template_file.kube-proxy-worker.rendered}"
  }
}

data "template_file" "worker-kubeconfig" {
  template = "${file("resources/kubeconfig.yaml")}"

  vars {
    server      = "https://192.168.1.100"
    client_cert = "k8s-worker.pem"
    client_key  = "k8s-worker-key.pem"
  }
}

data "ignition_file" "worker-kubeconfig" {
  filesystem = "root"
  mode       = 644
  path       = "/etc/kubernetes/kubeconfig"
  content = {
  content    = "${data.template_file.worker-kubeconfig.rendered}"
  }
}

data "ignition_file" "worker-machine-role" {
  filesystem = "root"
  mode       = 644
  path       = "/etc/prom-text-collectors/machine_role.prom"

  content {
    content = "machine_role{role=\"worker\"} 1"
  }
}

data "ignition_file" "dell-hostname" {
  count = "${var.dell_workers}"

  filesystem = "root"
  mode       = 420
  path       = "/etc/hostname"

  content {
    content = "worker${count.index}-borg.prod.uw.systems"
  }
}

data "ignition_file" "atx-hostname" {
  count = "${var.atx_workers}"

  filesystem = "root"
  mode       = 420
  path       = "/etc/hostname"

  content {
    content = "atx-worker${count.index}-borg.prod.uw.systems"
  }
}

data "template_file" "kubelet-worker" {
  template = "${file("resources/services/worker/kubelet.service")}"

  vars {
    kubelet_image_url = "${var.kubelet_image_url}"
    kubelet_image_tag = "${var.kubelet_image_tag}"
  }
}

data "ignition_systemd_unit" "kubelet-worker" {
  name    = "kubelet.service"
  content = "${data.template_file.kubelet-worker.rendered}"
}

data "template_file" "get-ssl-worker" {
  template = "${file("resources/services/worker/get-ssl.service")}"

  vars {}
}

data "ignition_systemd_unit" "get-ssl-worker" {
  name    = "get-ssl.service"
  content = "${data.template_file.get-ssl-worker.rendered}"
}
