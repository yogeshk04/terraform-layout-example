# vpc

Creates a VPC with public + private subnets spread across the supplied
availability zones, plus internet gateway, NAT gateway(s), and routing.

## Design

- The number of public and private subnets is driven by the length of
  `public_subnet_cidrs` / `private_subnet_cidrs`. Those lists must be
  aligned with `availability_zones`.
- `enable_nat_gateway = true` (default) creates NAT gateway(s) so private
  subnets can reach the internet outbound.
- `single_nat_gateway = true` (default) uses one NAT for all AZs — cheaper
  but a single-AZ failure domain. Set to `false` in `prod` to get one
  NAT per AZ.

## Example

```hcl
module "vpc" {
  source = "../../modules/vpc"

  project_name         = "myapp"
  environment          = "dev"
  cidr_block           = "10.10.0.0/16"
  availability_zones   = ["eu-central-1a", "eu-central-1b"]
  public_subnet_cidrs  = ["10.10.0.0/24",  "10.10.1.0/24"]
  private_subnet_cidrs = ["10.10.10.0/24", "10.10.11.0/24"]
  single_nat_gateway   = true
}
```
