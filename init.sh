#!/usr/bin/env bash
set -e

cd terraform
terraform destroy -auto-approve
terraform apply -auto-approve
terraform output -raw ansible_inventory > ../ansible/inventory.ini

cd ../ansible
ansible-playbook -i inventory.ini site.yml # -e "deploy_method=container"