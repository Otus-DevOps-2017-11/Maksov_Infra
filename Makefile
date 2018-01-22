terraform_dir = $(shell find . -type f -name "*.tf" -exec dirname {} \;|sort -u)

.PHONY: test fmt

default: test

terraform_validate:
	@for m in $(modules); do (terraform validate "$$m" && echo "√ $$m") || exit 1 ; done

terraform_tflint:
	@for m in $(modules); do (terraform validate "$$m" && echo "√ $$m") || exit 1 ; done
