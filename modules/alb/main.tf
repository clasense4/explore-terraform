################
# Application Load Balancer
################
resource "aws_lb" "this" {
  name                       = "${var.name}-aws-alb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.public_alb_sg.id]
  subnets                    = var.public_subnets_id
  enable_deletion_protection = true
  tags = {
    Name = "${var.name}_aws_alb"
  }
}

resource "aws_security_group" "public_alb_sg" {
  name        = "${var.name}_default_public_alb_sg"
  description = "${var.name} default public ALB SG"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}_public_alb_sg"
  }
}

resource "aws_lb_target_group" "alb_tg" {
  name     = "${var.name}-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  depends_on = [
    aws_lb.this
  ]
}

resource "aws_alb_listener" "http_listener" {
  load_balancer_arn = aws_lb.this.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.id
  }
}

# resource "aws_lb_listener" "https_listener" {
#   load_balancer_arn = aws_lb.this.id
#   port              = "443"
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn   = "arn:aws:acm:ap-southeast-1:437419956954:certificate/b016f189-b98b-4d9f-8b78-dcfce6e6137e"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.alb_tg.id
#   }
# }
