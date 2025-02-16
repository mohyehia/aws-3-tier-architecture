resource "aws_db_subnet_group" "demo_db_subnet_group" {
  name = "db-subnet-group"
  subnet_ids = [aws_subnet.db_private_subnet_a.id, aws_subnet.db_private_subnet_b.id]
  tags = {
    Name = "db-subnet-group"
  }
}

resource "aws_security_group" "db-security-group" {
  name = var.rds_security_group_name
  description = var.rds_security_group_description
  vpc_id = aws_vpc.demo_vpc.id
  tags = {
    Name = var.rds_security_group_name
  }

  ingress {
    from_port = 5432
    to_port = 5432
    protocol = "TCP"
    # ONLY allow access from the application security group
    security_groups = [aws_security_group.app_security_group.id]
  }
}

resource "aws_vpc_security_group_egress_rule" "allow_all_outbound" {
  ip_protocol       = "-1"
  security_group_id = aws_security_group.db-security-group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 0
  to_port           = 0
}

resource "aws_db_instance" "demo_rds" {
  instance_class = var.rds_instance_class
  identifier = var.db_identifier
  allocated_storage = 6
  db_name = var.db_name
  engine = var.engine
  engine_version = "15"
  username = var.username
  password = var.password
  db_subnet_group_name = aws_db_subnet_group.demo_db_subnet_group.name
  parameter_group_name = "default.postgres15"
  vpc_security_group_ids = [aws_security_group.db-security-group.id]
  publicly_accessible = false
  multi_az = false
  skip_final_snapshot = true
  tags = {
    Name = var.db_name
  }
}