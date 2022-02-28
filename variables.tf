variable "assume_role" {
  type        = string
  default     = "ci"
  description = "IAM role assumed by Concourse when running Terraform"
}

variable "region" {
  type    = string
  default = "eu-west-2"
}

# variable "global_pool_cidr" {
#   type        = string
#   description = "The top level IPAM pool CIDR. Currently only supports a single CIDR."
# }

# variable "regional_pool_cidr" {
#   type        = string
#   description = "The top level IPAM pool CIDR. Currently only supports a single CIDR."
# }

