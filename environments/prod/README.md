# prod environment

Root module for the **prod** environment. See
[environments/dev/README.md](../dev/README.md) for the workflow.

Notes specific to production:

- Three AZs by default (higher availability than dev/staging).
- `single_nat_gateway = false` — one NAT gateway per AZ.
- **Never** run `terraform apply` from a laptop against this environment
  without peer review. Wire it into a CI pipeline with mandatory `plan`
  approval.
