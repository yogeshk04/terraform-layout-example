# dev environment

Root module for the **dev** environment. Composes reusable modules from
`../../modules/`.

## Usage

```bash
cp terraform.tfvars.example terraform.tfvars
# edit terraform.tfvars

# One-time: update backend.tf with the bucket + lock table created by
# ../../bootstrap/.

terraform init
terraform plan
terraform apply
```

## What's here

- `versions.tf` — Terraform + provider version constraints.
- `backend.tf` — S3 remote state config (per-environment key).
- `providers.tf` — AWS provider + `default_tags`.
- `main.tf` — the actual composition of modules for this env.
- `variables.tf` — inputs consumed by this root module.
- `outputs.tf` — top-level outputs (VPC id, subnet ids, ...).
- `terraform.tfvars.example` — sample values; copy to `terraform.tfvars`.
