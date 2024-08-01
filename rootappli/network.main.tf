provider "aws" {
  region = "ap-south-1"
}

module "vpc" {
  source = "../../terraform manual projects/modules/network module"

  vpc_cidr = "10.0.0.0/16"
  
  sg_public_ingress = [
    {
      description = "Allows SSH access"
      port        = 22
      protocol    = "tcp"
    },
    {
      description = "Allows HTTP traffic"
      port        = 80
      protocol    = "tcp"
    },
  ]
  
  sg_public_egress  =  [443]
  
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  sg_private_ingress = [3306]

  sg_private_egress  =  [443]

  private_subnets  = ["10.0.11.0/24"]

  enable_nat_gateway = true
}