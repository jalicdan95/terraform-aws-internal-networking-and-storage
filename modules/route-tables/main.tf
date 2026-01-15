resource "aws_route_table" "private" {
  for_each = toset(var.subnet_ids)

  vpc_id = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.tags.Environment}-rt-${each.key}"
  })
}

resource "aws_route_table_association" "private" {
  for_each = aws_route_table.private

  subnet_id      = each.key
  route_table_id = each.value.id
}
