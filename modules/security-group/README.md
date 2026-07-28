# security-group

Generic Security Group module. Feeds `ingress_rules` and `egress_rules`
as lists so you can define any SG declaratively.

## Notes

- Uses the modern `aws_vpc_security_group_{ingress,egress}_rule` resources
  (one rule per resource) — safer than the legacy inline rules.
- `egress_rules = []` (default) becomes a single allow-all-outbound rule.
  Pass an explicit list to lock egress down.
- Each rule takes exactly **one** CIDR in `cidr_blocks`. Split multi-CIDR
  rules into multiple entries so each shows up as its own SG rule.

## Example

```hcl
module "web_sg" {
  source = "../../modules/security-group"

  project_name = "myapp"
  environment  = "dev"
  name         = "web"
  vpc_id       = module.vpc.vpc_id

  ingress_rules = [
    {
      description = "HTTP from anywhere"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "HTTPS from anywhere"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
  ]
}
```
