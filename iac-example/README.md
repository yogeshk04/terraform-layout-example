# IAC - terraform code for a project

## Getting started

### Install Terraform
Refernce the [link](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) to install terraform

### Open the iac project and cd into main folder
> cd iac/main


- To initialize the terraform repo
    >terraform init
- Plan the terraform code
    > terraform plan --var-file="../env/dev.tfvars"
- Apply the teraform code
    >terraform apply --var-file="../env/dev.tfvars"
- To destroy the infrastructure
    >terraform destroy --var-file=../env/dev.tfvars


```
End of the documentation
```

