module "ec2" {
  source = "../../modules/aws/ec2"

  infra_env     = var.infra_env
  infra_role    = "user"
  instance_size = var.instance_size
  instance_ami  = "ami-0e067cc8a2b58de59"
  #instance_root_device_size = 12 # optional
}

/*
module "vpc" {
  source    = "../../modules/aws/vpc"
  infra_env = var.infra_env
}
*/
