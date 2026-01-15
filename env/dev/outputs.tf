output "vpc_id" {
  value = module.vpc.id
}

output "private_subnets" {
  value = module.private_subnets.ids
}

output "s3_bucket" {
  value = module.s3.bucket_id
}
