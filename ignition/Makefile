TF := $(shell git rev-parse --show-toplevel)/ignition/bin/tf

cert-gen:
	./bin/cert-gen
install-certs:
	./bin/install-certs
http-cert-server:
	python2 -m SimpleHTTPServer 8000
ssh-master0:
	ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -lcore 192.168.1.100

### Terraform ###

clean:
	rm -f ic/*
plan:
	$(TF) plan $(ARGS)

apply:
	$(TF) apply $(ARGS)

silent-apply:
	$(TF) apply $(ARGS) 2>&1>/dev/null

output: clean silent-apply
	$(TF) output -json master          | jq '.value    | fromjson | .' >ic/master.ign
	$(TF) output -json dell-workers    | jq '.value[0] | fromjson | .' >ic/worker0.ign
	$(TF) output -json dell-workers    | jq '.value[1] | fromjson | .' >ic/worker1.ign
	$(TF) output -json storage-workers | jq '.value[0] | fromjson | .' >ic/storage-worker0.ign
	$(TF) output -json storage-workers | jq '.value[1] | fromjson | .' >ic/storage-worker1.ign
	$(TF) output -json atx-workers     | jq '.value[0] | fromjson | .' >ic/atx-worker0.ign
