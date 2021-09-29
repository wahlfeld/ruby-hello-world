ROOT=${PWD}

all: fmt validate docs clean

ci: validate test

.deps:
	brew bundle \
	&& npm install -g markdown-link-check \
	touch .deps

fmt: .phony
	terraform fmt --recursive

check: .phony
	pre-commit run -a \
	&& checkov --directory ${ROOT}/module

validate: tf-clean check
	cd ${ROOT}/template \
		&& terraform init --backend=false && terraform validate

test: tf-clean go-clean
	cd ${ROOT}/test \
	&& go test -v -timeout 20m

test-no-logs:
	SKIP_logs=true make test

docs: .phony
	terraform-docs markdown ${ROOT}/template --output-file ../README.md --hide modules --hide resources --hide requirements --hide providers

tf-clean: .phony
	for i in $$(find . -iname '.terraform' -o -iname '*.lock.*' -o -iname '*.tfstate*' -o -iname '.test-data'); do rm -rf $$i; done

go-clean: .phony
	rm -rf ${ROOT}/go.* \
	&& go mod init test \
	&& go mod tidy \

clean: .phony tf-clean go-clean

.PHONY: .phony
