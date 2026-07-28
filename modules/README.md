# modules

Reusable AWS building blocks. Every module here:

- Declares no `provider` or `terraform {}` block — those live in the
  calling root module (`environments/*` or `bootstrap/`).
- Follows the same file convention: `main.tf`, `variables.tf`,
  `outputs.tf`, and a short `README.md` where useful.
- Takes a `project_name`, `environment`, and `tags` input so callers
  get consistent naming and tagging out of the box.

## Available modules

| Module           | Purpose                                                       |
| ---------------- | ------------------------------------------------------------- |
| `vpc`            | VPC + public/private subnets + IGW + NAT + routing            |
| `security-group` | Generic Security Group with declarative ingress/egress rules  |
| `ec2`            | Single EC2 instance with optional Elastic IP                  |
| `alb`            | Application Load Balancer + target group + listener           |
| `autoscaling`    | Launch Template + Auto Scaling Group                          |
| `eks`            | EKS control plane + managed node groups                       |
| `rds`            | RDS instance + subnet group + security group                  |
| `s3`             | Private-by-default S3 bucket (versioned + encrypted)          |

## Adding a new module

```
modules/<name>/
├── versions.tf     # required Terraform + provider versions
├── main.tf         # resources only, no provider blocks
├── variables.tf    # every input has a `description` and `type`
├── outputs.tf      # every output has a `description`
└── README.md       # optional, but recommended
```
