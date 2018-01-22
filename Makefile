terraform_dir = $(shell find . -type f -name "*.tf" -exec dirname {} \;|sort -u)
terraform_example = $(shell find . -type f -name "*.tf" -exec dirname {} \;|sort -u)

.PHONY: terraform_tflint terraform_ansible

default: test

terraform_validate:
	@for m in $(modules); do (terraform validate "$$m" && echo "√ $$m") || exit 1 ; done

terraform_tflint:
	@for m in $(modules); do (terraform validate "$$m" && echo "√ $$m") || exit 1 ; done

example_files:
	@for m in $(modules); do (cp "$$m/terraform" terraform.tfvars) || exit 1 ; done
