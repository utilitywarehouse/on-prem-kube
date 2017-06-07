TF := $(shell git rev-parse --show-toplevel)/ignition/bin/tf

cert-gen:
	./bin/cert-gen
install-certs:
	./bin/install-certs
parse-clc:
	./bin/parse-clc-files
http-cert-server:
	python2 -m SimpleHTTPServer 8000
ssh-master0:
	ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -lcore 192.168.1.100

### Terraform ###

plan:
	$(TF) plan $(ARGS)

apply:
	$(TF) apply $(ARGS)

output:
	$(TF) output -json master       | jq '.value    | fromjson | .' >ic/master.ign
	$(TF) output -json dell-workers | jq '.value[0] | fromjson | .' >ic/worker0.ign
	$(TF) output -json dell-workers | jq '.value[1] | fromjson | .' >ic/worker1.ign
	$(TF) output -json dell-workers | jq '.value[2] | fromjson | .' >ic/worker2.ign
	$(TF) output -json dell-workers | jq '.value[3] | fromjson | .' >ic/worker3.ign
	$(TF) output -json atx-workers  | jq '.value[0] | fromjson | .' >ic/atx-worker0.ign
