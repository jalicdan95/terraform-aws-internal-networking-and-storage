output "vpc_id" {
  value = module.vpc.id
}

output "private_subnets" {
  value = module.private_subnets.subnet_ids
}

output "s3_bucket" {
  value = module.s3.bucket_id
}
