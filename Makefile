# Makefile — thin wrapper around the Terraform CLI.
#
# Usage:
#   make <target> [ENV=dev|staging|prod] [ARGS="--extra --terraform --flags"]
#
# Examples:
#   make init      ENV=dev
#   make plan      ENV=staging
#   make apply     ENV=prod
#   make destroy   ENV=dev
#   make output    ENV=dev
#   make check                        # fmt + validate everywhere
#   make bootstrap-apply               # one-time: create S3 + DynamoDB backend

# ------------------------------------------------------------------
# Config
# ------------------------------------------------------------------

ENV     ?= dev
ENV_DIR := environments/$(ENV)
TF      ?= terraform
ARGS    ?=

# Every env target verifies the env folder exists.
GUARD_ENV = @test -d "$(ENV_DIR)" \
	|| (echo "ERROR: environment '$(ENV)' not found (looked in $(ENV_DIR))." \
	    && echo "Valid: $$(ls -1 environments | grep -v README)" \
	    && exit 1)

.DEFAULT_GOAL := help

# ------------------------------------------------------------------
# Meta
# ------------------------------------------------------------------

.PHONY: help
help: ## Show this help
	@echo "Usage: make <target> [ENV=dev|staging|prod] [ARGS=\"...\"]"
	@echo ""
	@echo "Environment targets (set ENV=<env>):"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| grep -v '^bootstrap-' \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-18s %s\n", $$1, $$2}'
	@echo ""
	@echo "Bootstrap targets (run once per AWS account):"
	@grep -E '^bootstrap-[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-18s %s\n", $$1, $$2}'
	@echo ""
	@echo "Current ENV = $(ENV)"

# ------------------------------------------------------------------
# Environment targets
# ------------------------------------------------------------------

.PHONY: init
init: ## terraform init in environments/$ENV
	$(GUARD_ENV)
	cd $(ENV_DIR) && $(TF) init $(ARGS)

.PHONY: reconfigure
reconfigure: ## terraform init -reconfigure in environments/$ENV
	$(GUARD_ENV)
	cd $(ENV_DIR) && $(TF) init -reconfigure $(ARGS)

.PHONY: fmt
fmt: ## terraform fmt -recursive across the whole repo
	$(TF) fmt -recursive

.PHONY: fmt-check
fmt-check: ## Fail if any *.tf file is not formatted
	$(TF) fmt -recursive -check

.PHONY: validate
validate: ## terraform validate in environments/$ENV
	$(GUARD_ENV)
	cd $(ENV_DIR) && $(TF) validate $(ARGS)

.PHONY: plan
plan: ## terraform plan in environments/$ENV
	$(GUARD_ENV)
	cd $(ENV_DIR) && $(TF) plan $(ARGS)

.PHONY: apply
apply: ## terraform apply in environments/$ENV
	$(GUARD_ENV)
	cd $(ENV_DIR) && $(TF) apply $(ARGS)

.PHONY: destroy
destroy: ## terraform destroy in environments/$ENV
	$(GUARD_ENV)
	cd $(ENV_DIR) && $(TF) destroy $(ARGS)

.PHONY: output
output: ## terraform output in environments/$ENV
	$(GUARD_ENV)
	cd $(ENV_DIR) && $(TF) output $(ARGS)

.PHONY: refresh
refresh: ## terraform apply -refresh-only in environments/$ENV
	$(GUARD_ENV)
	cd $(ENV_DIR) && $(TF) apply -refresh-only $(ARGS)

.PHONY: console
console: ## Open an interactive terraform console in environments/$ENV
	$(GUARD_ENV)
	cd $(ENV_DIR) && $(TF) console

.PHONY: clean
clean: ## Remove .terraform/ caches (does NOT touch remote state)
	find . -type d -name ".terraform" -prune -exec rm -rf {} +
	find . -type f -name "*.tfplan" -delete
	@echo "Cleaned .terraform/ dirs and *.tfplan files."

# ------------------------------------------------------------------
# Bootstrap targets (run once per AWS account)
# ------------------------------------------------------------------

.PHONY: bootstrap-init
bootstrap-init: ## terraform init in bootstrap/
	cd bootstrap && $(TF) init $(ARGS)

.PHONY: bootstrap-plan
bootstrap-plan: ## terraform plan in bootstrap/
	cd bootstrap && $(TF) plan $(ARGS)

.PHONY: bootstrap-apply
bootstrap-apply: ## terraform apply in bootstrap/ (creates state bucket + lock table)
	cd bootstrap && $(TF) apply $(ARGS)

.PHONY: bootstrap-output
bootstrap-output: ## Show bootstrap outputs (bucket / table names)
	cd bootstrap && $(TF) output

# ------------------------------------------------------------------
# Cross-repo checks (useful in CI and pre-commit)
# ------------------------------------------------------------------

.PHONY: check
check: fmt-check ## Format-check + validate every root module
	@set -e; \
	for d in bootstrap environments/*/ examples/*/; do \
	  if [ -f "$$d/versions.tf" ] || [ -f "$$d/main.tf" ]; then \
	    echo "==> validating $$d"; \
	    (cd "$$d" && $(TF) init -backend=false -input=false >/dev/null && $(TF) validate); \
	  fi; \
	done
