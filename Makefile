.DEFAULT_GOAL := help
.PHONY: help virtualenv kind image deploy

VIRTUALENV ?= "./virtualenv/"
ANSIBLE = $(VIRTUALENV)/bin/ansible-playbook

help:
	@echo GLHF

virtualenv:
	python3 -m venv virtualenv
	. virtualenv/bin/activate
	pip3 install -r requirements.txt

kind:
	kind create cluster --config environment/default/kind_config.yaml --name demo

image:
	 docker build -t ansible .

deploy:
	$(ANSIBLE) site.yaml

test.cluster:
	$(ANSIBLE) site.yaml --tags=cluster-info
