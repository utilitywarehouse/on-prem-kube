data "ignition_config" "master" {
  disks = [
    "${data.ignition_disk.devsda.id}",
  ]

  filesystems = [
    "${data.ignition_filesystem.root.id}",
  ]

  files = [
    "${data.ignition_file.kube-apiserver.id}",
    "${data.ignition_file.kube-proxy.id}",
    "${data.ignition_file.kube-controller-manager.id}",
    "${data.ignition_file.kube-scheduler.id}",
    "${data.ignition_file.kube-system.id}",
    "${data.ignition_file.network-policy.id}",
    "${data.ignition_file.master-kubeconfig.id}",
    "${data.ignition_file.install-kube-system.id}",
    "${data.ignition_file.master-machine-role.id}",
    "${data.ignition_file.master-hostname.id}",
  ]

  systemd = [
    "${data.ignition_systemd_unit.etcd-member.id}",
    "${data.ignition_systemd_unit.kubelet.id}",
    "${data.ignition_systemd_unit.install-kube-system.id}",
    "${data.ignition_systemd_unit.get-ssl.id}",
  ]
}

data "template_file" "kube-apiserver" {
  template = "${file("resources/manifests/kube-apiserver.yaml")}"

  vars {
    hyperkube_image = "${var.hyperkube_image}"
  }
}

data "ignition_file" "kube-apiserver" {
  filesystem = "root"
  mode       = 644
  path       = "/etc/kubernetes/manifests/kube-apiserver.yaml"

  content = {
    content = "${data.template_file.kube-apiserver.rendered}"
  }
}

data "template_file" "kube-proxy" {
  template = "${file("resources/manifests/kube-proxy.yaml")}"

  vars {
    hyperkube_image = "${var.hyperkube_image}"
  }
}

data "ignition_file" "kube-proxy" {
  filesystem = "root"
  mode       = 644
  path       = "/etc/kubernetes/manifests/kube-proxy.yaml"

  content = {
    content = "${data.template_file.kube-proxy.rendered}"
  }
}

data "template_file" "kube-controller-manager" {
  template = "${file("resources/manifests/kube-controller-manager.yaml")}"

  vars {
    hyperkube_image = "${var.hyperkube_image}"
  }
}

data "ignition_file" "kube-controller-manager" {
  filesystem = "root"
  mode       = 644
  path       = "/etc/kubernetes/manifests/kube-controller-manager.yaml"

  content = {
    content = "${data.template_file.kube-controller-manager.rendered}"
  }
}

data "template_file" "kube-scheduler" {
  template = "${file("resources/manifests/kube-scheduler.yaml")}"

  vars {
    hyperkube_image = "${var.hyperkube_image}"
  }
}

data "ignition_file" "kube-scheduler" {
  filesystem = "root"
  mode       = 644
  path       = "/etc/kubernetes/manifests/kube-scheduler.yaml"

  content = {
    content = "${data.template_file.kube-scheduler.rendered}"
  }
}

data "template_file" "kube-system" {
  template = "${file("resources/manifests/kube-system.yaml")}"

  vars {}
}

data "ignition_file" "kube-system" {
  filesystem = "root"
  mode       = 644
  path       = "/etc/kubernetes/manifests/kube-system.yaml"

  content = {
    content = "${data.template_file.kube-system.rendered}"
  }
}

data "template_file" "network-policy" {
  template = "${file("resources/manifests/network-policy.yaml")}"

  vars {}
}

data "ignition_file" "network-policy" {
  filesystem = "root"
  mode       = 644
  path       = "/etc/kubernetes/manifests/network-policy.yaml"
  content = {
  content    = "${data.template_file.network-policy.rendered}"
  }
}

data "template_file" "master-kubeconfig" {
  template = "${file("resources/kubeconfig.yaml")}"

  vars {
    server      = "http://127.0.0.1:8080"
    client_cert = "k8s-apiserver.pem"
    client_key  = "k8s-apiserver-key.pem"
  }
}

data "ignition_file" "master-kubeconfig" {
  filesystem = "root"
  mode       = 644
  path       = "/etc/kubernetes/kubeconfig"
  content = {
  content    = "${data.template_file.master-kubeconfig.rendered}"
  }
}

data "template_file" "install-kube-system" {
  template = "${file("resources/bin/install-kube-system")}"

  vars {}
}

data "ignition_file" "install-kube-system" {
  filesystem = "root"
  mode       = 644
  path       = "/opt/bin/install-kube-system"
  content = {
  content    = "${data.template_file.install-kube-system.rendered}"
  }
}

data "ignition_file" "master-machine-role" {
  filesystem = "root"
  mode       = 644
  path       = "/etc/prom-text-collectors/machine_role.prom"

  content {
    content = "machine_role{role=\"master\"} 1"
  }
}

data "ignition_file" "master-hostname" {
  filesystem = "root"
  mode       = 420
  path       = "/etc/hostname"

  content {
    content = "master0-borg.prod.uw.systems"
  }
}

data "ignition_systemd_unit" "etcd-member" {
  name = "etcd-member.service"

  dropin = [
    {
      name = "10-wait-etcd.conf"

      content = <<EOF
[Unit]
After=get-ssl.service
Requires=get-ssl.service
EOF
    },
    {
      name = "15-custom-options.conf"

      content = <<EOF
[Service]
ExecStartPre=/usr/bin/mkdir -p /etc/etcd
Environment="RKT_RUN_ARGS=\
  --uuid-file-save=/var/lib/coreos/etcd-member-wrapper.uuid \
  --volume etc-etcd,kind=host,source=/etc/etcd,readOnly=true \
  --mount volume=etc-etcd,target=/etc/etcd"
EOF
    },
    {
      name = "20-config.conf"

      content = <<EOF
[Service]
Environment="ETCD_IMAGE_URL=${var.etcd_image_url}"
Environment="ETCD_IMAGE_TAG=${var.etcd_image_tag}"
Environment="ETCD_NAME=member0"
Environment="ETCD_INITIAL_CLUSTER=member0=https://192.168.1.100:2380"
Environment="ETCD_LISTEN_PEER_URLS=https://192.168.1.100:2380"
Environment="ETCD_LISTEN_CLIENT_URLS=https://0.0.0.0:2379"
Environment="ETCD_ADVERTISE_CLIENT_URLS=https://192.168.1.100:2379"
Environment="ETCD_INITIAL_ADVERTISE_PEER_URLS=https://192.168.1.100:2380"
Environment="ETCD_CLIENT_CERT_AUTH=true"
Environment="ETCD_TRUSTED_CA_FILE=/etc/etcd/ssl/ca.pem"
Environment="ETCD_CERT_FILE=/etc/etcd/ssl/k8s-etcd.pem"
Environment="ETCD_KEY_FILE=/etc/etcd/ssl/k8s-etcd-key.pem"
Environment="ETCD_PEER_CLIENT_CERT_AUTH=true"
Environment="ETCD_PEER_TRUSTED_CA_FILE=/etc/etcd/ssl/ca.pem"
Environment="ETCD_PEER_CERT_FILE=/etc/etcd/ssl/k8s-etcd.pem"
Environment="ETCD_PEER_KEY_FILE=/etc/etcd/ssl/k8s-etcd-key.pem"
EOF
    },
  ]
}

data "template_file" "kubelet" {
  template = "${file("resources/services/kubelet.service")}"

  vars {
    kubelet_image_url = "${var.kubelet_image_url}"
    kubelet_image_tag = "${var.kubelet_image_tag}"
  }
}

data "ignition_systemd_unit" "kubelet" {
  name    = "kubelet.service"
  content = "${data.template_file.kubelet.rendered}"
}

data "template_file" "get-ssl" {
  template = "${file("resources/services/get-ssl.service")}"

  vars {}
}

data "ignition_systemd_unit" "get-ssl" {
  name    = "get-ssl.service"
  content = "${data.template_file.get-ssl.rendered}"
}

data "template_file" "install-kube-system-service" {
  template = "${file("resources/services/install-kube-system.service")}"

  vars {}
}

data "ignition_systemd_unit" "install-kube-system" {
  name    = "install-kube-system.service"
  content = "${data.template_file.install-kube-system.rendered}"
}
