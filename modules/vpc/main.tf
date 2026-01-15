resource "aws_vpc" "test_main" {
  cidr_block = var.cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = merge(var.tags, {
    Name = "${var.tags.Environment}-vpc"
  })
}