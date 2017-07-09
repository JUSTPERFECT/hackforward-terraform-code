##launch_configuration creation

resource "aws_launch_configuration" "hackforward-lc" {
  name          = "hackforward-lc"
  image_id      = "${lookup(var.AWS_AMIS, var.AWS_REGION)}"
  instance_type = "${var.INSTANCE_TYPE}"
iam_instance_profile="${var.INSTANCE_ROLE}"
security_groups = ["${aws_security_group.hackforward_sg.id}"]
user_data       = "${file("install.sh")}"
  key_name        = "${var.AWS_KEY_NAME}"
}

##security_groups creation

resource "aws_security_group" "hackforward_sg" {
  name        = "hackforward_sg"
  description = "Used for controlling SSH and HTTP traffic"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


## aws_autoscaling_group creation

resource "aws_autoscaling_group" "hackforward-asg" {
  availability_zones   = ["${split(",", var.AVAILABILITY_ZONES)}"]
  name                 = "hackforward-asg"
  max_size             = "${var.ASG_MAX}"
  min_size             = "${var.ASG_MIN}"
  desired_capacity     = "${var.ASG_DESIRED}"
  force_delete         = true
  launch_configuration = "${aws_launch_configuration.hackforward-lc.name}"
  load_balancers       = ["${aws_elb.hackforward-elb.name}"]

  tag {
    key                 = "Name"
    value               = "web-asg"
    propagate_at_launch = "true"
  }
}

##elastic load balancer creation

resource "aws_elb" "hackforward-elb" {
  name = "hackforward-elb"

  availability_zones = ["${split(",", var.AVAILABILITY_ZONES)}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }
}

## creation of route53 record set

resource "aws_route53_record" "hackforward" {
  zone_id = "${var.ZONE_ID}"
  name    = "${var.RECORD_SET}"
  type    = "A"

  alias {
    name                   = "${aws_elb.hackforward-elb.dns_name}"
    zone_id                = "${aws_elb.hackforward-elb.zone_id}"
    evaluate_target_health = true
  }
}
