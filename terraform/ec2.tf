# Creates EC2 instances to serve the application
resource "aws_key_pair" "deployer" {
  key_name   = "terraform_deployer"
  public_key = file(var.public_key_path)
}

# Create Bastion SG
resource "aws_security_group" "bastionsg" {
  name   = "bastion-security-group"
  vpc_id = aws_vpc.vpc.id

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastion_sg"
  }
}

resource "aws_security_group" "ec2" {
  name        = "security_group_private_ec2"
  description = "SG for EC2 instances"
  vpc_id      = aws_vpc.vpc.id

  # Allow outbound internet access.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allowing SSH - best practice is to create a bastion host instead of allowing directly.
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastionsg.id]
  }

  ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  tags = {
    Name = "security_group_private_ec2"
  }
}

# Create Bastion Host on Public Subnet
resource "aws_instance" "bastion" {
  ami                         = "ami-0c635ee4f691a2310"
  instance_type               = var.instance_type
  associate_public_ip_address = true
  key_name                    = aws_key_pair.deployer.id
  vpc_security_group_ids      = [aws_security_group.bastionsg.id]
  subnet_id                   = aws_subnet.public[0].id

  tags = {
    Name = "bastion-host-public"
  }
}

# Configures Launch Config
resource "aws_launch_configuration" "launch_config" {
  name_prefix                 = "ec2-app-instances"
  image_id                    = lookup(var.amis, var.region)
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.deployer.id
  security_groups             = [aws_security_group.ec2.id]
  user_data                   = data.template_file.provision.rendered
  depends_on                  = [aws_db_instance.default]
  associate_public_ip_address = true

  # Lifecycle hook defines new launch config to be created before being destroyed
  lifecycle {
    create_before_destroy = true
  }
}

# Configures auto scaling group
resource "aws_autoscaling_group" "autoscaling_group" {
  launch_configuration = aws_launch_configuration.launch_config.id
  min_size             = var.autoscaling_group_min_size
  max_size             = var.autoscaling_group_max_size
  target_group_arns    = [aws_alb_target_group.group.arn]
  vpc_zone_identifier  = aws_subnet.private_ec2.*.id

  # refresh instance when group is updated
  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["tag"]
  }

  tag {
    key                 = "Name"
    value               = "app-autoscaling-group"
    propagate_at_launch = true
  }
}
