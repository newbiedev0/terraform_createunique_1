variable "agsvar" {
  description = "Name used across the resources created"
  type        = string
  default     = "NOTSOPRO"
}

variable "create_launch_template" {
  type        = bool
  default     = false
}

variable "launch_template_name" {
  type        = string
  default     = ""
}

variable "key_name" {
  type        = string
  default     = null
}

variable "image_id" {
  type        = string
  default     = ""
}

variable "instance_type" {
  type        = string
  default     = null
}

variable "user_data" {
  type        = string
  default     = null
}

variable "security_groups" {
  type        = list(string)
  default     = []
}

variable "desired_capacity" {
  type        = number
  default     = null
}

variable "min_size" {
   type        = number
  default     = null
}

variable "max_size" {
  type        = number
  default     = null
}

variable "health_check_type" {
  type        = string
  default     = null
}

variable "health_check_grace_period" {
  type        = number
  default     = null
}

variable "force_delete" {

  type        = bool
  default     = null
}

variable "vpc_zone_identifier" {
  type        = list(string)
  default     = null
}

variable "load_balancers" {
  type        = list(string)
  default     = []
}

