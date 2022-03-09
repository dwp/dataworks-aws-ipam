locals {
  global_pool_cidr   = local.cidr_block[local.environment][var.region]
  regional_pool_cidr = local.cidr_block[local.environment][var.region] #The whole global pool is assigned to selected region
}
