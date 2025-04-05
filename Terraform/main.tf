terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.94.1"
    }
  }
}

provider "aws" {
 region = "us-east-1"
}

# Jenkins Agent EC2 Instance
resource "aws_instance" "jenkins_agent" {
  ami           = "ami-0f9de6e2d2f067fca"  # Ubuntu 22.04
  instance_type = "t2.micro"
  key_name      = "jonewkeypair"
  security_groups = ["launch-wizard-1"]

  tags = {
    Name = "Jenkins-Agent"
  }
}

# Flask App Servers (2 Instances)
resource "aws_instance" "flask_app_servers" {
  count         = 2
  ami           = "ami-00a929b66ed6e0de6"  # CentOS AMI
  instance_type = "t2.micro"
  key_name      = "jonewkeypair"
  security_groups = ["launch-wizard-1"]

  tags = {
    Name = "Flask-App-Server-${count.index + 1}"
  }
}

# Elastic Load Balancer (ELB) for Flask App
resource "aws_elb" "flask_lb" {
  name               = "flask-load-balancer"
  availability_zones = ["us-east-1a", "us-east-1b"]

  listener {
    instance_port     = 5000
    instance_protocol = "HTTP"
    lb_port          = 80
    lb_protocol      = "HTTP"
  }

  health_check {
    target              = "HTTP:5000/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  instances = aws_instance.flask_app_servers[*].id

  tags = {
    Name = "Flask-Load-Balancer"
  }
}

# Database Server (Ubuntu)
resource "aws_instance" "db_server" {
  ami           = "ami-0f9de6e2d2f067fca"  # Ubuntu 22.04
  instance_type = "t2.micro"
  key_name      = "jonewkeypair"
  security_groups = ["launch-wizard-1"]

  tags = {
    Name = "db-server"
  }
}

# S3 Bucket for Jenkins Artifacts
resource "aws_s3_bucket" "joanne_artifacts" {
  bucket = "joanne-artifacts-bucket"
}