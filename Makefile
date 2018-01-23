GIT_DIR=/home/travis/build/Otus-DevOps-2017-11/Maksov_Infra
terraform_vars = ${GIT_DIR}/terraform/terraform.tfvars.example
packer_vars = ${GIT_DIR}/packer/variables.json.examples
.PHONY: terraform_tflint terraform_validate packer_validate ansible_lint

default: test

packer_validate:
	cd ${GIT_DIR}/packer && packer validate -var-file=${GIT_DIR}/packer/variables.json.examples app.json
	pwd
	cd ${GIT_DIR}/packer && packer validate -var-file=${GIT_DIR}/packer/variables.json.examples db.json
	pwd
	cd ${GIT_DIR}/packer && packer validate -var-file=${GIT_DIR}/packer/variables.json.examples immutable.json
	pwd
	cd ${GIT_DIR}/packer && packer validate -var-file=${GIT_DIR}/packer/variables.json.examples ubuntu16.json
	pwd
terraform_validate:
	cd ${GIT_DIR}/terraform/stage && terraform init && terraform validate --var-file=${terraform_vars}
	cd ${GIT_DIR}/terraform/prod && terraform init && terraform validate --var-file=${terraform_vars}
terraform_tflint:
	cd ${GIT_DIR}/terraform/stage && tflint --var-file=${terraform_vars} --error-with-issues
	cd ${GIT_DIR}/terraform/prod &&  tflint --var-file=${terraform_vars} --error-with-issues
ansible_lint:
	cd $(GIT_DIR)/ansible
	find . -type f -name "*.yml" -exec ansible-lint {} -x ANSIBLE0002 \;
