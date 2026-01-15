resource "aws_subnet" "private" {
  for_each = toset(var.cidrs)

  vpc_id                  = var.vpc_id
  cidr_block              = each.value
  availability_zone       = var.azs[index(var.cidrs, each.value)]
  map_public_ip_on_launch = false

  tags = merge(var.tags, {
    Name = "${var.tags.Environment}-private-${each.value}"
  })
}
