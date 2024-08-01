variable "loadbcervar" {
  type        = string
  default     = "NOTSOPRO"
}

variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_tags" {
  type        = string
  default     = "it is what it is"
}

# Subnet
variable "public_subnets" {
  type        = list(string)
  default     = []
}

variable "private_subnets" {
  type        = list(string)
  default     = []
}

variable "public_subnet_tags" {
  type        = string
  default     = "public"
}

variable "private_subnet_tags" {
  type        = string
  default     = "private"
} 

variable "igw_tags" {
  type        = string
  default     = "IGW"
}

variable "sg_public_ingress" {
  type        = list(map(string))
  default     = []
}

variable "sg_public_egress" {
  type        = list(string)
  default     = []
}

variable "sg_private_ingress" {

  type        = list(string)
  default     = []
}

variable "sg_private_egress" {
  type        = list(string)
  default     = []
}

variable "enable_nat_gateway" {
  type        = bool
  default     = false
}

variable "nat_gateway_destination_cidr_block" {
  type        = string
  default     = "0.0.0.0/0"
}

variable "reuse_nat_ips" {
  type        = bool
  default     = false
}

variable "external_nat_ip_ids" {
  type        = list(string)
  default     = []
}

