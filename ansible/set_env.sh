#!/bin/bash

PROD_EMAIL=959980669321-compute@developer.gserviceaccount.com
PROD_PEM_FILE_PATH=~/ansible/.gce/account.json
PROD_PROJECT=infra-188917
STAGE_MAIL=959980669321-compute@developer.gserviceaccount.com
STAGE_PROJECT=infra-188917
STAGE_PEN_FILE_PATH=~/ansible/.gce/account.json


if [[ "$1" == "prod" ]] 
then
ANSIBLE_ENV=PRODUCTION
export GCE_EMAIL=$PROD_EMAIL
export GCE_PROJECT=$PROD_PROJECT
export GCE_PEM_FILE_PATH=$PROD_PEM_FILE_PATH
cat << 'EOF' > ansible.cfg
[defaults]
inventory = ~/ansible/environments/prod/gce.py
remote_user = Maksim
private_key_file = ~/.ssh/Maksim
host_key_checking = False
roles_path = ./roles
retry_files_enabled = False
	
[diff]
always = True
context = 5
EOF
cat << 'EOF' > ./playbooks/group_app_hosts.yml
group_app_hosts: tag_prod-app
EOF
cat << 'EOF' > ./playbooks/group_db_hosts.yml
group_db_hosts: tag_prod-db
EOF
elif [[ "$1" == "stage" ]]
then
ANSIBLE_ENV=STAGE
export GCE_EMAIL=$STAGE_EMAIL
export GCE_PROJECT=$STAGE_PROJECT
export GCE_PEM_FILE_PATH=$STAGE_PEM_FILE_PATH
cat << 'EOF' > ansible.cfg
[defaults]
inventory = ~/ansible/environments/stage/gce.py
remote_user = Maksim
private_key_file = ~/.ssh/Maksim
host_key_checking = False
roles_path = ./roles
retry_files_enabled = False
	
[diff]
always = True
context = 5
EOF
cat << 'EOF' > ./playbooks/group_app_hosts.yml
group_app_hosts: tag_stage-app
EOF
cat << 'EOF' > ./playbooks/group_db_hosts.yml
group_db_hosts: tag_stage-app
EOF
else
echo "Не задано Ansible окуржение"
fi
