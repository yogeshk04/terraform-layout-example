/*
module "ec2" {
  source = "../../modules/aws/ec2"

  infra_env     = var.infra_env
  infra_role    = "user"
  instance_size = var.instance_size
  instance_ami  = "ami-0e067cc8a2b58de59"
  #instance_root_device_size = 12 # optional
}
*/

module "vpc" {
  source        = "../../modules/aws/vpc-2"
  vpc_cidr      = "10.0.0.0/16"
  public_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
}

module "ec2" {
  source         = "../../modules/aws/ec2-1"
  my_public_key  = "ars-aws-key"
  instance_type  = "t2.micro"
  security_group = "${module.vpc.security_group}"
  subnets        = "${module.vpc.public_subnets}"
}

module "alb" {
  source         = "../../modules/aws/alb"
  vpc_id         = "${module.vpc.aws_vpc_id}"
  instance1_id   = "${module.ec2.instance1_id}"
  instance2_id   = "${module.ec2.instance2_id}"
  subnet1        = "${module.vpc.subnet1}"
  subnet2        = "${module.vpc.subnet2}"
}

module "autoscale" {
  source         = "../../modules/aws/autoscale"
  vpc_id         = "${module.vpc.aws_vpc_id}"
  ami_id         = "${module.ec2.ami_id}"      
  instance1_id   = "${module.ec2.instance1_id}"
  instance2_id   = "${module.ec2.instance2_id}"
  subnet1        = "${module.vpc.subnet1}"
  subnet2        = "${module.vpc.subnet2}"
}