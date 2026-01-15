locals {
  tags = {
    Owner       = var.owner
    Environment = var.environment
  }
}

# VPC
module "vpc" {
  source = "../../modules/vpc"

  cidr_block = "10.0.0.0/16"
  tags       = local.tags
}


# Private Subnets
module "private_subnets" {
  source = "../../modules/subnet"

  vpc_id     = module.vpc.id
  cidrs      = ["10.0.1.0/24", "10.0.2.0/24"]
  azs        = ["us-west-2a", "us-west-2b"]
  tags       = local.tags
}

# Route Tables
module "private_route_tables" {
  source = "../../modules/route-tables"

  vpc_id         = module.vpc.id
  subnet_ids = module.private_subnets.subnet_ids
  tags           = local.tags
}

# S3 Bucket
module "s3" {
  source = "../../modules/s3"

  bucket_name = "my-private-dev-bucket"
  tags        = local.tags
}

# VPC Endpoints
module "vpc_endpoints" {
  source = "../../modules/vpc-endpoints"

  vpc_id      = module.vpc.id
  route_table_ids = module.private_route_tables.ids
  region          = var.aws_region
  tags         = local.tags
}

