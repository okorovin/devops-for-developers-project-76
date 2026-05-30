-include .env
export

.PHONY: install setup deploy ping

install:
	ansible-galaxy install -r requirements.yml

setup: install
	ansible-playbook playbook.yml --tags setup

deploy:
	ansible-playbook playbook.yml --tags deploy

ping:
	ansible all -m ping
