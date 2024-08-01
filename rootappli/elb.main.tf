provider "aws" {
  region = "ap-south-1"
}

module "elb" {
  source = "../../terraform manual projects/modules/loadbalancer module"
  
  vpc_id = "vpc-08b3ea433e2014c6a"
  internal        = false

  sg_public_ingress = [
    {
      description = "Allows HTTP traffic"
      port        = 80
      protocol    = "tcp"
    },
  ]

  sg_public_egress  =  [443]

  subnets         = ["subnet-0b134c01fd2ce1ece", "subnet-0e15e72c9967f4bd1","subnet-0e56ccfe47eb41d47"]

  listener = [
    {
      instance_port     = 8080
      instance_protocol = "http"
      lb_port           = 80
      lb_protocol       = "http"
      #ssl_certificate_id = "arn:aws:acm:eu-west-1:235367859451:certificate/6c270328-2cd5-4b2d-8dfd-ae8d0004ad31"
    },
  ]

  health_check = {
     target              = "HTTP:80/"
     interval            = 30
     healthy_threshold   = 2
     unhealthy_threshold = 2
     timeout             = 5
  }
}
