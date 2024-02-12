# Create a service linked role
resource "aws_iam_service_linked_role" "dataworks_aws_ipam_service_linked_role" { # only required for single account IPAM.
  aws_service_name = "ipam.amazonaws.com"
  description      = "Service linked role for AWS VPC IP address manager"
}

# Create IPAM resource, default scope is created and can be referenced from
resource "aws_vpc_ipam" "dataworks_aws_ipam" {
  description = "This is AWS IPAM for Dataworks."
  operating_regions {
    region_name = var.region
  }
  depends_on = [
    aws_iam_service_linked_role.dataworks_aws_ipam_service_linked_role # This role can only be deleted after linked IPAM resource is deleted creating a dependency to allow IPAM to be deleted first.
  ]
}

# Create a top-level pool for Dataworks_AWS_IPAM with private scope only. Note scopes are created by default.
# Scopes enable you to represent networks where you have overlapping IP space.  
resource "aws_vpc_ipam_pool" "dataworks_aws_ipam_global_pool" {
  description    = "It is the top level Dataworks_AWS_IPAM pool"
  address_family = "ipv4"
  ipam_scope_id  = aws_vpc_ipam.dataworks_aws_ipam.private_default_scope_id
}

# Provision IPAM Pool CIDR for top-level pool
resource "aws_vpc_ipam_pool_cidr" "dataworks_aws_ipam_global_pool_cidr" {
  ipam_pool_id = aws_vpc_ipam_pool.dataworks_aws_ipam_global_pool.id
  cidr         = local.global_pool_cidr
}

# Create regional pools
resource "aws_vpc_ipam_pool" "dataworks_aws_ipam_regional_pool" {
  description         = "Dataworks AWS IPAM Regional Pool"
  address_family      = "ipv4"
  ipam_scope_id       = aws_vpc_ipam.dataworks_aws_ipam.private_default_scope_id
  source_ipam_pool_id = aws_vpc_ipam_pool.dataworks_aws_ipam_global_pool.id
  locale              = var.region
  auto_import         = true
}

resource "aws_vpc_ipam_pool_cidr" "dataworks_aws_ipam_regional_pool_cidr" {
  ipam_pool_id = aws_vpc_ipam_pool.dataworks_aws_ipam_regional_pool.id
  cidr         = local.regional_pool_cidr
}

