.PHONY: install setup deploy ping edit-vault view-vault

install:
	ansible-galaxy install -r requirements.yml

setup: install
	ansible-playbook playbook.yml --tags setup

deploy:
	ansible-playbook playbook.yml --tags deploy

ping:
	ansible all -m ping

edit-vault:
	ansible-vault edit group_vars/webservers/vault.yml

view-vault:
	ansible-vault view group_vars/webservers/vault.yml
