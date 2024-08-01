provider "aws" {
  region = "ap-south-1"
}

locals {
  user_data = <<-EOT
    #!/bin/bash
    echo '<html><body><h1 style="font-size:75px;color:orange;">NOTSOPRO <br> <font style="color:red;"> www.notsopro.com <br> <font style="color:green;">  </h1> </body></html>' > index.html
    nohup busybox httpd -f -p 8080 &
  EOT
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
     target              = "HTTP:8080/"
     interval            = 30
     healthy_threshold   = 2
     unhealthy_threshold = 2
     timeout             = 5
  }
}

module "autoscaling" {
  source =  "../../terraform manual projects/modules/autoscaling module"

  depends_on = [module.elb]
  create_launch_template = true
  vpc_zone_identifier       = ["subnet-0b134c01fd2ce1ece", "subnet-0e15e72c9967f4bd1","subnet-0e56ccfe47eb41d47"]
  load_balancers            = ["NOTSOPRO"]
  min_size                  = 1
  max_size                  = 2
  desired_capacity          = 1
  health_check_type         = "ELB"
  health_check_grace_period = 30

  launch_template_name        = "example-asg"
  image_id          = "ami-0a7cf821b91bcccbc"
  key_name          = "jan24master"
  instance_type     = "t3.micro"
  user_data         = base64encode(local.user_data)
  security_groups   = ["sg-024da43ccf9b0816d"]
}
