# environments

Every folder here is an **independent root module** with its own remote
state file. That means:

- `terraform init/plan/apply` are run from **inside** the environment
  folder — not from the repo root.
- State for each environment is fully isolated (own S3 key, own lock
  row). Applying `dev` cannot touch `prod`.
- Provider config, backend config, and variable values are per-env.
  Reusable logic lives in `../modules/`, not here.

## Adding a new environment

1. Copy an existing environment folder (e.g. `dev/`) to your new name.
2. Update `backend.tf` — change the `key` so it points at a new state file
   path (e.g. `myapp/qa/terraform.tfstate`).
3. Update `terraform.tfvars.example` with realistic per-env values, then
   copy it to `terraform.tfvars`.
4. `terraform init` (fresh backend) and `terraform apply`.

## Folder shape

```
<env>/
├── versions.tf              # Terraform + provider version pins
├── backend.tf               # Remote state (S3 + DynamoDB lock)
├── providers.tf             # AWS provider config + default_tags
├── main.tf                  # Composition of ../modules/*
├── variables.tf             # Inputs to this root module
├── outputs.tf               # Top-level outputs
├── terraform.tfvars.example # Sample values (safe to commit)
└── README.md
```
