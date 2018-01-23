GIT_DIR=~
terraform_vars = ${GIT_DIR}/terraform/terraform.tfvars.example
.PHONY: terraform_tflint terraform_validate packer_validate ansible_lint

default: test

packer_validate:
	cd ${GIT_DIR}/packer
	find . -type f -name "*.json" -exec packer validate {} -var-file=~/packer/variables.json.example

terraform_validate:
	cd ${GIT_DIR}/terraform/stage && terraform init && terraform validate --var-file=${terraform_vars}
	cd ${GIT_DIR}/terraform/prod && terraform init && terraform validate --var-file=${terraform_vars}

terraform_tflint:
	cd ${GIT_DIR}/terraform/stage && tflint --var-file=${terraform_vars} --error-with-issues
	cd ${GIT_DIR}/terraform/prod &&  tflint --var-file=${terraform_vars} --error-with-issues
ansible_lint:
	cd $(GIT_DIR)/ansible
	find . -type f -name "*.yml" -exec ansible-lint {} -x ANSIBLE0002 \;
