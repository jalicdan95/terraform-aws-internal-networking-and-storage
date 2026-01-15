output "route_table_ids" {
  value = values(aws_route_table.private)[*].id
}