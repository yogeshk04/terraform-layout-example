# example: VPC + S3

Self-contained example that provisions a VPC (with public and private
subnets, IGW, NAT) and a private S3 bucket, using the modules in
`../../modules/`.

**No remote state backend** — uses local state, so it's easy to spin up
and tear down for a quick smoke test.

## Usage

```bash
cp terraform.tfvars.example terraform.tfvars
# edit terraform.tfvars — the bucket name must be globally unique
terraform init
terraform apply
# ...
terraform destroy
```
