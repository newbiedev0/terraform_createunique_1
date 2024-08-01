variable "create_elb" {
  type        = bool
  default     = true
}
variable "elb1" {
  type        = string
  default     = "notsopro"
}

variable "vpc_id" {
  type        = string
  default = null
}

variable "sg_public_ingress" {
  type        = list(map(string))
  default     = []
}

variable "sg_public_egress" {
  description = "List of egress rules to set on the security group"
  type        = list(string)
  default     = []
}

variable "subnets" {
  type        = list(string)
}

variable "internal" {
  type        = bool
}

variable "cross_zone_load_balancing" {
  type        = bool
  default     = true
}

variable "idle_timeout" {
  type        = number
  default     = 60
}

variable "connection_draining" {
  type        = bool
  default     = false
}

variable "connection_draining_timeout" {
  type        = number
  default     = 300
}

variable "tags" {
  type        = map(string)
  default     = {}
}

variable "listener" {
  type        = list(map(string))
}

variable "access_logs" {
  type        = map(string)
  default     = {}
}

variable "health_check" {
  type        = map(string)
}
