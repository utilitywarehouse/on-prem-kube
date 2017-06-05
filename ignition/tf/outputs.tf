output "master" {
  value = "${data.ignition_config.master.rendered}"
}

output "dell-workers" {
  value = ["${data.ignition_config.dell-worker.*.rendered}"] 
}

output "atx-workers" {
  value = ["${data.ignition_config.atx-worker.*.rendered}"] 
}
