resource "aws_vpc" "my_vpc" {
  cidr_block       = var.vpc_cidr
  enable_dns_hostnames = true

  tags = merge(
    { "Name" = var.loadbcervar
      "project" = var.vpc_tags
	}
  )
}

resource "aws_internet_gateway" "my_igw" {
  count = length(var.public_subnets) > 0 ? 1 : 0
  vpc_id = aws_vpc.my_vpc.id

  tags = merge(
    { "Name" = var.loadbcervar
      "project" = var.igw_tags
	}
  )
}
data "aws_availability_zones" "all" {}

resource "aws_subnet" "public_subnet" {
  count = length(var.public_subnets)
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = element(var.public_subnets, count.index)
  availability_zone = data.aws_availability_zones.all.names[count.index]

  tags = merge(
    { "Name" = var.loadbcervar
      "project" = var.public_subnet_tags
	}
  )
  
}
resource "aws_route_table" "public" {
    count = length(var.public_subnets) > 0 ? 1 : 0
    vpc_id = aws_vpc.my_vpc.id

    tags = {
        Name = "test Public RouteTable - NOTSOPRO"
    }
}
resource "aws_route_table_association" "public" {
    count = length(var.public_subnets)
    subnet_id = element(aws_subnet.public_subnet.*.id, count.index)
    route_table_id = aws_route_table.public[0].id
}
resource "aws_route" "public_internet_gateway" {
  count = length(var.public_subnets) > 0 ? 1 : 0

  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_igw[0].id

  timeouts {
    create = "5m"
  }
}
resource "aws_security_group" "public" {
  count = length(var.public_subnets) > 0 ? 1 : 0
  vpc_id = aws_vpc.my_vpc.id

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

resource "aws_subnet" "private_subnet" {
  count = length(var.private_subnets)
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = element(var.private_subnets, count.index)
  availability_zone = data.aws_availability_zones.all.names[count.index]

  tags = merge(
    { "Name" = var.loadbcervar
      "project" = var.private_subnet_tags
        }
  )
}

resource "aws_route_table" "private" {
    count = length(var.private_subnets) > 0 ? 1 : 0
    vpc_id = aws_vpc.my_vpc.id

    tags = {
        Name = "test private RouteTable - notsopro"
    }
}

resource "aws_route_table_association" "private" {
    count = length(var.private_subnets)
    subnet_id = element(aws_subnet.private_subnet.*.id, count.index)
    route_table_id = aws_route_table.private[0].id
}

resource "aws_security_group" "private" {
  count = length(var.private_subnets) > 0 ? 1 : 0
  vpc_id = aws_vpc.my_vpc.id


   dynamic "egress" {
        for_each = var.sg_private_egress
        content {
            from_port   = egress.value
            to_port     = egress.value
            protocol    = "tcp"
            cidr_blocks = [ "0.0.0.0/0" ]
        }
    }
}

resource "aws_security_group_rule" "private" {
   count = length(var.sg_private_ingress) > 0 ? 1 : 0
   type              = "ingress"
   from_port         = var.sg_private_ingress[count.index]
   to_port           = var.sg_private_ingress[count.index]
   protocol          = "tcp"
   security_group_id = aws_security_group.private[0].id
   cidr_blocks = [ "0.0.0.0/0" ]
}


locals {
  nat_gateway_ips   = var.reuse_nat_ips ? var.external_nat_ip_ids : try(aws_eip.nat[*].id, [])
}

resource "aws_eip" "nat" {
  count =  var.enable_nat_gateway && length(var.public_subnets) > 0 ? 1 : 0
  domain = "vpc"

  depends_on = [aws_internet_gateway.my_igw]
}


resource "aws_nat_gateway" "public" {
  count =  var.enable_nat_gateway && length(var.public_subnets) > 0 ? 1 : 0
  allocation_id = element(local.nat_gateway_ips, count.index)
  subnet_id = aws_subnet.public_subnet[0].id

  depends_on = [aws_internet_gateway.my_igw]
}

resource "aws_route" "private_nat_gateway" {
  count =  var.enable_nat_gateway && length(var.public_subnets) > 0 ? 1 : 0

  route_table_id              = aws_route_table.private[0].id
  destination_cidr_block = var.nat_gateway_destination_cidr_block
  nat_gateway_id              = aws_nat_gateway.public[0].id

  timeouts {
    create = "5m"
  }
}
