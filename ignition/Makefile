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
	-rm saved-plan
	$(TF) plan -out=saved-plan $(ARGS)
	$(TF) apply $(ARGS) saved-plan

output:
	$(TF) output
