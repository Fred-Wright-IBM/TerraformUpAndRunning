provider "aws" {
  region = "eu-west-2"
}

resource "aws_launch_configuration" "example" {
    image_id = "ami-006a0174c6c25ac06"
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.instance.id]
    key_name = "FWKeyPair"
    user_data = data.template_file.user_data.rendered

#required when using a launch configuration with an auto scaling group.
    lifecycle {
      create_before_destroy = true
    }
}

resource "aws_security_group" "instance" {
    name = "${var.cluster_name}-instance"

    ingress {
      from_port = var.server_port
      to_port = var.server_port
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_autoscaling_group" "example" {
    launch_configuration = aws_launch_configuration.example.name
    vpc_zone_identifier = data.aws_subnet_ids.private.ids

    target_group_arns = [aws_lb_target_group.asg.arn]
    health_check_type = "ELB"

    min_size = 2
    max_size = 10

    tag {
      key = "${var.cluster_name}-Name"
      value = "terraform-asg-example-FW"
      propagate_at_launch = true
    }
}


resource "aws_lb" "example" {
  name = "${var.cluster_name}-example"
  load_balancer_type = "application"
  subnets = data.aws_subnet_ids.private.ids
  security_groups = [aws_security_group.alb.id]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.example.arn
  port = 80
  protocol = "HTTP"

# By default, return a simple 404 page
default_action {
  type = "fixed-response"

  fixed_response {
    content_type = "text/plain"
    message_body = "404: page not found"
    status_code = 404
    }
  }
}

resource "aws_security_group" "alb" {
  name = "${var.cluster_name}-alb"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb_target_group" "asg" {
    name = "${var.cluster_name}-asg"
    port = var.server_port
    protocol = "HTTP"
    vpc_id = data.aws_vpc.default.id

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 15
    path = "/"
    protocol = "HTTP"
    matcher = "200"
  }
}

resource "aws_lb_listener_rule" "asg" {
    listener_arn = aws_lb_listener.http.arn
    priority = 100

    condition {
      field = "path-pattern"
      values = ["*"]
    }

    action {
      type = "forward"
      target_group_arn = aws_lb_target_group.asg.arn
    }
}

terraform {
  backend "s3" {
    bucket = "s3bucket-bootcamp-fw"
    key = "stage/services/webserver-cluster/terraform.tfstate"
    region = "eu-west-2"

    dynamodb_table = "dynamodb-bootcamp-fw"
    encrypt = true
  }
}
