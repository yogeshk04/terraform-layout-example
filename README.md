# Terraform Layout Example (AWS)

An industry-standard Terraform layout for AWS. Fork it,
rename it, and start shipping infrastructure.

---

## TL;DR — get running in 5 steps

> Assumes you have Terraform `>= 1.5.0`, the AWS CLI, and an AWS account.

```bash
# 0. Configure AWS credentials once (see step 1 below)

# 1. Create the remote state backend (S3 bucket + DynamoDB lock table)
cd bootstrap
cp terraform.tfvars.example terraform.tfvars      # edit values
terraform init
terraform apply
terraform output                                  # copy these values

# 2. Point every environment's backend.tf at the values from step 1
#    (bucket name, region, DynamoDB table). See "Wiring the backend" below.

# 3. Deploy the dev environment
cd ../environments/dev
cp terraform.tfvars.example terraform.tfvars      # edit values
terraform init
terraform plan
terraform apply

# 4. Repeat step 3 for staging and prod when ready.
```

---

## Layout

```
.
├── bootstrap/          # One-time: creates the S3 state bucket + DynamoDB lock table.
│                       # Uses LOCAL state.
├── modules/            # Reusable building blocks. No provider blocks inside.
│   ├── vpc/
│   ├── security-group/
│   ├── ec2/
│   ├── alb/
│   ├── autoscaling/
│   ├── eks/
│   ├── rds/
│   └── s3/
├── environments/       # Root modules — one folder per environment,
│   ├── dev/            # each with its own remote state file.
│   ├── staging/
│   └── prod/
└── examples/           # Self-contained samples (local state) that
                        # demonstrate the modules.
```

### Why this shape?

- **`modules/` are pure building blocks.** They never declare `provider`
  or `terraform {}` blocks (only `versions.tf` for constraints). That
  keeps them reusable across environments, accounts, and regions.
- **`environments/*` are the only root modules** you run `terraform apply`
  from. Each has its own backend (own state file) and own provider
  config. A mistake in `dev` cannot corrupt `prod` state.
- **`bootstrap/`** is applied once, manually, with **local** state, to
  create the S3 bucket + DynamoDB table that every environment then uses
  as its remote backend.
- **`examples/`** show how the modules compose, without polluting the
  environments tree.

---

## Prerequisites

| Tool       | Version    |
| ---------- | ---------- |
| Terraform  | `>= 1.5.0` |
| AWS CLI    | `>= 2.0`   |
| An AWS account with permissions to create S3, DynamoDB, VPC, EC2, etc. |

Install Terraform: <https://developer.hashicorp.com/terraform/downloads>.

---

## Step 1 — Configure AWS credentials

Add a profile to `~/.aws/credentials` (Linux/macOS) or
`%USERPROFILE%\.aws\credentials` (Windows):

```ini
[default]
aws_access_key_id     = XXXXXXXXXXXXXXXX
aws_secret_access_key = XXXXXXXXXXXXXXXX
```

You can use named profiles per environment (e.g. `[dev]`, `[prod]`) and
reference them via the `profile` variable in each `terraform.tfvars`.

Verify:

```bash
aws sts get-caller-identity --profile default
```

---

## Step 2 — Bootstrap the remote state backend

Run this **once per AWS account**. It creates:

- An S3 bucket (versioned, encrypted, public-access blocked) for state.
- A DynamoDB table for state locking.

```bash
cd bootstrap
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars`:

```hcl
project_name      = "myapp"
region            = "eu-central-1"
profile           = "default"
state_bucket_name = "myapp-terraform-state-1234"   # must be globally unique
lock_table_name   = "myapp-terraform-locks"
```

Apply:

```bash
terraform init
terraform apply
terraform output
```

Note the outputs — you'll paste them into every environment's
`backend.tf` in the next step.

> `bootstrap/` uses **local state on purpose**. Do not migrate it into
> the bucket it creates. See [bootstrap/README.md](bootstrap/README.md).

---

## Step 3 — Wire the backend into each environment

Open `environments/<env>/backend.tf` and replace the placeholder values
with what `bootstrap` printed:

```hcl
terraform {
  backend "s3" {
    bucket         = "myapp-terraform-state-1234"    # from bootstrap output
    key            = "myapp/dev/terraform.tfstate"   # per-env; keep unique
    region         = "eu-central-1"                  # from bootstrap output
    dynamodb_table = "myapp-terraform-locks"         # from bootstrap output
    encrypt        = true
  }
}
```

Do this for `dev`, `staging`, and `prod`. The `key` **must differ per
environment** — that's what keeps their states isolated.

---

## Step 4 — Deploy an environment

```bash
cd environments/dev
cp terraform.tfvars.example terraform.tfvars
```

Edit the values (project name, region, VPC CIDRs, ...), then:

```bash
terraform init          # downloads providers + connects to the S3 backend
terraform fmt -check    # optional: verify formatting
terraform validate      # optional: static checks
terraform plan          # review what will change
terraform apply         # apply after reviewing the plan
```

To tear down:

```bash
terraform destroy
```

Repeat for `staging` and `prod` when you're ready.

---

## Step 5 — Add your own resources

Open `environments/dev/main.tf`. The commented-out `module "web"` and
`module "app_bucket"` blocks show the pattern — uncomment, fill in the
inputs, `terraform plan`, and apply.

Need a new type of resource? Add a module under `modules/<name>/` (see
[modules/README.md](modules/README.md)) and call it from the environment.

---

## Conventions cheat-sheet

| Topic                    | Convention                                                            |
| ------------------------ | --------------------------------------------------------------------- |
| Terraform version        | `>= 1.5.0` (pinned in every `versions.tf`)                            |
| AWS provider version     | `~> 5.0` in root modules; `>= 5.0` in reusable modules                |
| Naming                   | `{project}-{environment}-{resource}` (e.g. `myapp-dev-vpc`)           |
| Tags                     | Applied automatically via provider `default_tags`                     |
| State per environment    | `s3://<bucket>/<project>/<env>/terraform.tfstate`                     |
| Lock table               | Shared DynamoDB table (per-key locking, no contention across envs)    |
| Sensitive vars           | Marked `sensitive = true`; never committed to `.tfvars`               |
| `.tfvars` in git         | Only `*.tfvars.example` is committed. Real `*.tfvars` is git-ignored. |
| `.terraform.lock.hcl`    | **Committed** — pins exact provider versions for the whole team.      |

---

## Common tasks

### Add a new environment

1. Copy `environments/dev/` to `environments/<new-env>/`.
2. Edit `backend.tf` — change the `key` to a unique path.
3. Edit `terraform.tfvars.example`, then copy it to `terraform.tfvars`.
4. `terraform init && terraform apply`.

### Add a new module

1. Create `modules/<name>/{versions,main,variables,outputs}.tf`.
2. Call it from an environment: `module "x" { source = "../../modules/<name>" ... }`.

### Format everything

```bash
terraform fmt -recursive
```

---

## What this template does **not** include (yet)

Deliberately kept out to stay small; add when you actually need them:

- CI/CD pipeline (GitHub Actions, GitLab CI, ...).
- Pre-commit hooks (`terraform_fmt`, `tflint`, `tfsec`/`checkov`).
- Secrets manager wiring (AWS Secrets Manager / SSM Parameter Store).
- Multi-account setup with `assume_role` in the provider.
- Terragrunt / Terraform Cloud / Spacelift wrappers.

Each of these is a natural next step once the basics are in place.

---

## Troubleshooting

| Symptom                                              | Likely cause / fix                                                                    |
| ---------------------------------------------------- | ------------------------------------------------------------------------------------- |
| `Error: Backend configuration changed`               | You edited `backend.tf` after `init`. Run `terraform init -reconfigure`.              |
| `Error acquiring the state lock`                     | A previous run crashed. Check the DynamoDB table, or `terraform force-unlock <ID>`.   |
| `BucketAlreadyExists` while running bootstrap        | S3 bucket names are global. Pick a more unique `state_bucket_name`.                   |
| `No valid credential sources for AWS Provider`       | Wrong profile / expired session. Re-run `aws configure` or `aws sso login`.           |
| Module change plans to destroy + recreate            | Usually a `name` / `name_prefix` change. Rename in-place via `terraform state mv`.    |

---

## License

Use freely as a template for your own projects.
