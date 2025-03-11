# variable "sg_ports" {
#   type        = list(number)
#   description = "list of ingress ports"
#   default     = [8200, 8201,8300, 9200, 9500]
# }

# variable "vpc_id" {
#   description = "The VPC ID to create the security group in."
#   type        = string
# }

variable "security_group_name" {
  description = "The name of the security group"
  type        = string
  default     = "custom-security-group"  # Default name
}

variable "security_group_description" {
  description = "The description of the security group"
  type        = string
  default     = "Security group with custom inbound and outbound rules"  # Default description
}

variable "inbound_rules" {
  description = "List of inbound rules for the security group"
  type        = list(object({
    cidr_blocks = list(string)
    from_port   = number
    to_port     = number
    protocol    = string
  }))
  default = []
}

variable "outbound_rules" {
  description = "List of outbound rules for the security group"
  type        = list(object({
    cidr_blocks = list(string)
    from_port   = number
    to_port     = number
    protocol    = string
  }))
  default = []
}
