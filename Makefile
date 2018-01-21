modules = $(shell find . -type f -name "*.tf" -exec dirname {} \;|sort -u)

.PHONY: test fmt

default: test

test:
	@for m in $(modules); do (terraform validate "$$m" && echo "√ $$m") || exit 1 ; done
