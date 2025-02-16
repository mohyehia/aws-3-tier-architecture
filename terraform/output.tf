# Define the Outputs
output "vpc_id" {
  value       = aws_vpc.demo_vpc.id
  description = "ID of the created VPC"
}

output "public_subnet_ids" {
  value = [aws_subnet.public_subnet_a.id, aws_subnet.public_subnet_b.id]
  description = "IDs of the public subnets"
}

output "app_private_subnet_ids" {
  value = [aws_subnet.app_private_subnet_a.id, aws_subnet.app_private_subnet_b.id]
  description = "IDs of the application private subnets"
}

output "db_private_subnet_ids" {
  value = [aws_subnet.db_private_subnet_a.id, aws_subnet.db_private_subnet_b.id]
  description = "IDs of the database private subnets"
}

output "internet_gateway_id" {
  value       = aws_internet_gateway.gateway.id
  description = "ID of the created Internet Gateway"
}

output "nat_gateway_id" {
  value       = aws_nat_gateway.nat_gateway.id
  description = "ID of the created NAT Gateway"
}

output "public_route_table_id" {
  value       = aws_route_table.public_route_table.id
  description = "ID of the public route table"
}

output "private_route_table_id" {
  value       = aws_route_table.private_route_table.id
  description = "ID of the private route table"
}

output "rds_endpoint" {
  value = aws_db_instance.demo_rds.endpoint
  description = "RDS endpoint"
}