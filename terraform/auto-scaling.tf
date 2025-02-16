# Create the FE security group
resource "aws_security_group" "fe_security_group" {
    name = var.fe_security_group_name
    description = var.fe_security_group_description
    vpc_id = aws_vpc.demo_vpc.id
    tags = {
        Name = var.fe_security_group_name
    }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_access" {
    ip_protocol       = "TCP"
    security_group_id = aws_security_group.fe_security_group.id
    cidr_ipv4         = "0.0.0.0/0"
    from_port         = 80
    to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_fe_outbound_traffic" {
    ip_protocol       = "-1"
    security_group_id = aws_security_group.fe_security_group.id
    cidr_ipv4         = "0.0.0.0/0"
    from_port         = 0
    to_port           = 0
}

# Create Load Balancer security group
resource "aws_security_group" "alb_security_group" {
    name        = var.alb_security_group_name
    description = var.alb_security_group_description
    vpc_id      = aws_vpc.demo_vpc.id
    tags = {
        Name = var.alb_security_group_name
    }
    ingress {
        from_port = 80
        to_port = 80
        protocol = "TCP"
        security_groups = [aws_security_group.fe_security_group.id]
    }
    ingress {
        from_port = 443
        to_port   = 443
        protocol  = "TCP"
        security_groups = [aws_security_group.fe_security_group.id]
    }
}

resource "aws_vpc_security_group_egress_rule" "allow_alb_outbound_traffic" {
    ip_protocol       = "-1"
    security_group_id = aws_security_group.alb_security_group.id
    cidr_ipv4         = "0.0.0.0/0"
    from_port         = 0
    to_port           = 0
}

# create Application security group
resource "aws_security_group" "app_security_group" {
    name        = var.app_security_group_name
    description = var.app_security_group_description
    vpc_id      = aws_vpc.demo_vpc.id
    tags = {
        Name = var.app_security_group_name
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "TCP"
        security_groups = [aws_security_group.fe_security_group.id]
    }
    ingress {
        from_port = 80
        to_port = 80
        protocol = "TCP"
        security_groups = [aws_security_group.alb_security_group.id, aws_security_group.fe_security_group.id]
    }
}

resource "aws_vpc_security_group_egress_rule" "allow_app_outbound_traffic" {
    ip_protocol       = "-1"
    security_group_id = aws_security_group.app_security_group.id
    cidr_ipv4         = "0.0.0.0/0"
    from_port         = 0
    to_port           = 0
}

# Create the ALB
resource "aws_lb" "app_load_balancer" {
    name = "app-load-balancer"
    internal = true
    load_balancer_type = "application"
    security_groups = [aws_security_group.alb_security_group.id]
    subnets = [aws_subnet.app_private_subnet_a.id, aws_subnet.app_private_subnet_b.id]
    enable_deletion_protection = false # Set to true for production to prevent accidental deletion
    tags = {
        Name = "app-load-balancer"
    }
}

# Create the target group
resource "aws_lb_target_group" "app_target_group" {
    name = "app-target-group"
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.demo_vpc.id
    target_type = "instance"
    health_check {
        path = "/" # Change this to your desired health check path for ex: '/api/actuator/health'
        protocol = "HTTP"
        matcher = "200" # Expects a 200 OK response
        healthy_threshold = 3
        unhealthy_threshold = 3
        timeout = 10 # timeout after 10 seconds
        interval = 30 # check every 30 seconds
    }
    tags = {
        Name = "app-target-group"
    }
}

# Retrieve the created launch template from AWS
data "aws_launch_template" "be_launch_template" {
    name = "demo-be-template"
}

# Create the Auto Scaling Group
resource "aws_autoscaling_group" "app_asg" {
    name = "app_asg"
    max_size = 2
    min_size = 1
    desired_capacity = 1
    launch_template {
        id = data.aws_launch_template.be_launch_template.id
        version = data.aws_launch_template.be_launch_template.latest_version
    }
    vpc_zone_identifier = [aws_subnet.app_private_subnet_a.id, aws_subnet.app_private_subnet_b.id]
    target_group_arns = [aws_lb_target_group.app_target_group.arn]
}

# Create the target tracking policy
resource "aws_autoscaling_policy" "cpu_target_tracking_policy" {
    name                   = "cpu-target-tracking-policy"
    autoscaling_group_name = aws_autoscaling_group.app_asg.name
    policy_type = "TargetTrackingScaling"
    target_tracking_configuration {
        predefined_metric_specification {
            predefined_metric_type = "ASGAverageCPUUtilization"
        }
        target_value = 50.0
    }
}