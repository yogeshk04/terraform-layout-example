# Bootstrap — Terraform remote state backend

Apply this **once per AWS account**, with **local** state, to create the
S3 bucket and DynamoDB table that every environment then uses as its
remote backend.

## Usage

```bash
cp terraform.tfvars.example terraform.tfvars
# edit terraform.tfvars — the bucket name must be globally unique
terraform init
terraform apply
```

The outputs (`state_bucket_name`, `lock_table_name`, `region`) go into
each environment's `backend.tf`.

## Notes

- `prevent_destroy = true` is set on both resources. To recreate them
  you must remove that lifecycle block first.
- The bucket is created with versioning + AES-256 encryption + full
  public-access block.
- The DynamoDB table uses on-demand billing and point-in-time recovery.
- Do not migrate this stack to the remote backend it creates —
  keep its state local (or in a separate, manually-managed bucket).
