# -- ALB -- 
# Creates ALB SG 
resource "aws_security_group" "alb" {
  name        = "alb_security_group"
  description = "ALB Security Group"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.allowed_alb_cidr_blocks
  }

  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-security-group"
  }
}

# Creates ALB on Public Subnet 
resource "aws_alb" "alb" {
  name            = "app-lb"
  security_groups = [aws_security_group.alb.id]
  subnets         = aws_subnet.public.*.id
  tags = {
    Name = "app-lb-servian"
  }
}

# Create new target group for ALB
resource "aws_alb_target_group" "group" {
  name     = "alb-tgt-grp"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id

  stickiness {
    type = "lb_cookie" # Defines stickiness, but not needed for now since DB is queried from backend
  }
  # Alter the destination of the health check 
  health_check {
    path = "/"
    port = 3000
  }
  tags = {
    Name = "alb-target-group"
  }
}

# Create listener for port 80 - HTTP traffic
resource "aws_alb_listener" "listener_http" {
  load_balancer_arn = aws_alb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.group.arn
    type             = "forward"
  }
}