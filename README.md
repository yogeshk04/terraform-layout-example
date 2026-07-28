# Terraform Layout Example (AWS)

An opinionated, industry-standard Terraform layout for AWS. Use it as the
starting point for a new infrastructure repository.

## Layout

```
.
├── bootstrap/          # One-time setup for the remote state backend
│                       # (S3 bucket for tfstate + DynamoDB table for locking)
├── modules/            # Reusable building blocks. No provider blocks inside.
│   ├── vpc/
│   ├── ec2/
│   ├── alb/
│   ├── autoscaling/
│   ├── eks/
│   ├── rds/
│   └── s3/
├── environments/       # Root modules — one folder per environment.
│   ├── dev/            # Each folder is an independent Terraform state.
│   ├── staging/
│   └── prod/
└── examples/           # Standalone reference examples (not part of the
                        # main pipeline).
```

### Why this shape?

- **`modules/` are pure building blocks.** They never declare `provider` or
  `terraform {}` blocks. That keeps them reusable across environments,
  accounts, and regions.
- **`environments/*` are the only root modules.** Each one has its own
  backend (its own state file) and its own `providers.tf`. This isolates
  blast radius: a mistake in `dev` cannot corrupt `prod` state.
- **`bootstrap/`** is applied once, manually, with local state, to create
  the S3 bucket + DynamoDB table that every other environment then uses
  as its remote backend.
- **`examples/`** are self-contained samples you can point people at
  without polluting the main tree.

## Getting started

### 1. Configure AWS credentials

`~/.aws/credentials`:

```ini
[default]
aws_access_key_id     = XXXXXXXXXXXXXXXX
aws_secret_access_key = XXXXXXXXXXXXXXXX
```

You can use named profiles per environment (e.g. `[dev]`, `[prod]`) and
reference them from each environment's `terraform.tfvars`.

### 2. Bootstrap the remote state backend (once per account)

```bash
cd bootstrap
cp terraform.tfvars.example terraform.tfvars   # edit the values
terraform init
terraform apply
```

Note the outputs — you'll plug the bucket name and DynamoDB table name into
each environment's `backend.tf`.

### 3. Deploy an environment

```bash
cd environments/dev
cp terraform.tfvars.example terraform.tfvars   # edit the values
terraform init
terraform plan
terraform apply
```

Repeat for `staging` and `prod`.

## Conventions

| Topic                  | Convention                                                            |
| ---------------------- | --------------------------------------------------------------------- |
| Terraform version      | `>= 1.5.0` (pinned in each `versions.tf`)                             |
| AWS provider version   | `~> 5.0`                                                              |
| Naming                 | `{project}-{environment}-{resource}` (e.g. `myapp-dev-vpc`)           |
| Tags                   | Every resource is tagged via provider `default_tags`                  |
| State per environment  | `s3://<bucket>/<project>/<env>/terraform.tfstate`                     |
| Sensitive vars         | Marked `sensitive = true`; never committed to `.tfvars`               |
| `.tfvars` in git       | Only `*.tfvars.example` is committed. Real `*.tfvars` is git-ignored. |

## Extending

- Add a new module: create `modules/<name>/{main,variables,outputs}.tf`.
- Add a new environment: copy `environments/dev/` to `environments/<new>/`
  and update `backend.tf` key + `terraform.tfvars`.
- Add a new cloud (e.g. Azure): create a sibling `modules/azure/` tree and
  matching environment folders — do not mix providers inside one module.

