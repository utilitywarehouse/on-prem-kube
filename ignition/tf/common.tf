data "ignition_disk" "devsda" {
  device     = "/dev/sda"
  wipe_table = true

  partition {
    label = "ROOT"
  }
}

data "ignition_filesystem" "root" {
  name = "root"

  mount {
    device  = "/dev/sda1"
    format  = "ext4"
    create  = true
    force   = true
    options = ["-L", "ROOT"]
  }
}
