resource "aws_db_subnet_group" "default" {
  name        = format("%s-subnet-group", var.rds_instance_identifier)
  description = "RDS Subnet Group within private subnets"
  subnet_ids  = aws_subnet.private_rds.*.id
}

# Creates security group for PostgreSQL DB
resource "aws_security_group" "rds" {
  name        = "rds_security_group"
  description = "RDS Postgresql security group"
  vpc_id      = aws_vpc.vpc.id

  # Keep the instance private by only allowing traffic from default VPC's SG.
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2.id]
  }
  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "rds-security-group"
  }
}

# Creates RDS PostgreSQL DB resource
resource "aws_db_instance" "default" {
  identifier                = var.rds_instance_identifier
  allocated_storage         = 5
  engine                    = "postgres"
  engine_version            = "11.10"
  instance_class            = "db.t2.micro"
  name                      = var.database_name
  username                  = var.database_user
  password                  = var.database_password
  db_subnet_group_name      = aws_db_subnet_group.default.id
  vpc_security_group_ids    = [aws_security_group.rds.id]
  skip_final_snapshot       = true
  final_snapshot_identifier = "Ignore"
  max_allocated_storage     = 0
  multi_az                  = false
  publicly_accessible       = false

  tags = {
    Name = "rds-db-instance"
  }
}