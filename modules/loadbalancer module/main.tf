resource "aws_security_group" "elb" {
  vpc_id = var.vpc_id


dynamic "egress" {
        for_each = var.sg_public_egress
        content {
            from_port   = egress.value
            to_port     = egress.value
            protocol    = "tcp"
            cidr_blocks = [ "0.0.0.0/0" ]
        }
    }

 
dynamic "ingress" {
    for_each = var.sg_public_ingress
    content {
      cidr_blocks = [ "0.0.0.0/0" ]
      description      = ingress.value["description"]
      from_port        = ingress.value["port"]
      to_port          = ingress.value["port"]
      protocol         = ingress.value["protocol"]
     }
  }

}              
resource "aws_elb" "demo" {
  count = var.create_elb ? 1 : 0

  name                 = var.elb1
  subnets              = var.subnets
  internal             = var.internal
  security_groups      = [aws_security_group.elb.id]

  cross_zone_load_balancing     = var.cross_zone_load_balancing
  idle_timeout                  = var.idle_timeout
  connection_draining           = var.connection_draining
  connection_draining_timeout   = var.connection_draining_timeout

  dynamic "listener" {
    for_each = var.listener
    content {
      instance_port      = listener.value.instance_port
      instance_protocol  = listener.value.instance_protocol
      lb_port            = listener.value.lb_port
      lb_protocol        = listener.value.lb_protocol
     
    }
  }
  health_check {
    healthy_threshold   = lookup(var.health_check, "healthy_threshold")
    unhealthy_threshold = lookup(var.health_check, "unhealthy_threshold")
    target              = lookup(var.health_check, "target")
    interval            = lookup(var.health_check, "interval")
    timeout             = lookup(var.health_check, "timeout")
  }
}

