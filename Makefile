SHELL := /bin/bash

.PHONY: nomad.conf

menu:
	@perl -ne 'printf("%20s: %s\n","$$1","$$2") if m{^([\w+-]+):[^#]+#\s(.+)$$}' Makefile

nomad: # Run dev server
	$(MAKE) nomad.conf INPUT=nomad.conf.tmpl
	set -a; source .env && nomad agent \
		-config=./nomad.conf \
		-data-dir="$(PWD)/mnt/nomad" \
		-dc="$${NOMAD_DC}" \
		-region="$${NOMAD_REGION}" \
		-node="$$(uname -n | cut -d. -f1)" \
		-consul-checks-use-advertise \
		-bootstrap-expect 1

nomad.conf: # Generate nomad.conf
	cat $(INPUT) | sed 's#x.x.x.x#$(shell bin/my-ip)#' > nomad.conf.1
	mv -f nomad.conf.1 nomad.conf

job-docker: # Submit nomad docker job
	set -a source .env && env VAULT_TOKEN="$$(pass-vault-helper get)" nomad job run docker.nomad

job-raw-exec: # Submit nomad rawe_xec job
	set -a source .env && env VAULT_TOKEN="$$(pass-vault-helper get)" nomad job run raw_exec.nomad

screen: # Run nomad in a screen
	screen -DRR yurt -m bash -c 'env VAULT_TOKEN=$$(pass $(pass)) make nomad'
