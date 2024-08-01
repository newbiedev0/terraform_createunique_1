provider "aws" {
  region = "ap-south-1"
}

locals {
  user_data = <<-EOT
    #!/bin/bash
    echo '<html><body><h1 style="font-size:70px;color:purple;">NOTSOPRO <br> <font style="color:yellow;"> www.notsopro.com <br> <font style="color:red;">  </h1> </body></html>' > index.html
    nohup busybox httpd -f -p 8080 &
  EOT
}

module "autoscaling" {
  source = "../../terraform manual projects/modules/autoscaling module"
  create_launch_template = true
  vpc_zone_identifier       = ["subnet-0b134c01fd2ce1ece", "subnet-0e15e72c9967f4bd1","subnet-0e56ccfe47eb41d47"]

  min_size                  = 1
  max_size                  = 2
  desired_capacity          = 1
  health_check_type         = "EC2"
  health_check_grace_period = 30

  launch_template_name        = "example-asg"
  image_id          = "ami-0a7cf821b91bcccbc"
  key_name          = "jan24master"
  instance_type     = "t3.micro"
  user_data         = base64encode(local.user_data)
  security_groups   = ["sg-024da43ccf9b0816d"]
}
