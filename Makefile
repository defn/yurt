SHELL := /bin/bash

.PHONY: nomad.conf

menu:
	@perl -ne 'printf("%20s: %s\n","$$1","$$2") if m{^([\w+-]+):[^#]+#\s(.+)$$}' Makefile

nomad-dev: # Run dev server
	$(MAKE) nomad.conf INPUT=dev.conf.example
	nomad agent -config=./nomad.conf -node="$(shell basename $(shell uname -n) .local)" -consul-checks-use-advertise -bootstrap-expect 1

nomad-server: # Run nomad server
	$(MAKE) nomad.conf INPUT=server.conf.example
	nomad agent -config=./nomad.conf -node="$(shell basename $(shell uname -n) .local)" -consul-checks-use-advertise -bootstrap-expect 1

nomad.conf: # Generate nomad.conf
	cat $(INPUT) | sed 's#x.x.x.x#$(shell bin/my-ip)#' > nomad.conf.1
	mv -f nomad.conf.1 nomad.conf

nomad-demo: # Subit nomad job
	nomad job run docs.nomad
