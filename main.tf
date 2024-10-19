resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = var.vpc_name
    Environment = var.app_environment
  }
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidr_1
  availability_zone = "${var.aws_region}a"
  map_public_ip_on_launch = true 
  

  tags = {
    Name        = "${var.vpc_name}-public-subnet-1"
    Environment = var.app_environment
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidr_2
  availability_zone = "${var.aws_region}b"

  tags = {
    Name        = "${var.vpc_name}-public-subnet-2"
    Environment = var.app_environment
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.vpc_name}-igw"
    Environment = var.app_environment
  }
}

resource "aws_route_table_association" "public-rt-association-1" {
  subnet_id      = aws_subnet.public_subnet_1.id
   route_table_id = aws_route_table.public.id

}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name        = "${var.vpc_name}-public-rt"
    Environment = var.app_environment
  }
}

resource "aws_security_group" "allow_http_ssh" {
  name        = "allow_http_ssh"
  description = "Allow HTTP and SSH inbound traffic"
  vpc_id      = aws_vpc.main.id

ingress {
    description = "ICMP from anywhere"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]  # This allows ping from any IP. Adjust as needed for security.
  }

ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["112.204.173.11/32"]
  }

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  ingress {
    description = "SSH from My IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["112.204.173.11/32"]  # using my actual IP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_http_ssh"
  }
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]
}

resource "aws_instance" "amazon_linux_2" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet_1.id
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.allow_http_ssh.id]

  key_name = "id_rsa"  # Make sure to replace this with your actual key pair name

  tags = {
    Name        = "${var.vpc_name}-example-instance"
    Environment = var.app_environment
  }
}

resource "aws_instance" "nginx_instance_app1" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet_1.id
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.allow_http_ssh.id]

  key_name = "id_rsa"  # Make sure to replace this with your actual key pair name

    user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y nginx
              systemctl start nginx
              systemctl enable nginx
              echo "<h1>Hello from App1 Terraform</h1>" > /var/www/html/index.html
              EOF

  tags = {
    Name        = "${var.vpc_name}-nginx-instance"
    Environment = var.app_environment
  }
}

resource "aws_instance" "nginx_instance_app2" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet_1.id
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.allow_http_ssh.id]

  key_name = "id_rsa"  # Make sure to replace this with your actual key pair name

    user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y nginx
              systemctl start nginx
              systemctl enable nginx
              echo "<h1>Hello from App2 Terraform</h1>" > /var/www/html/index.html
              EOF

  tags = {
    Name        = "${var.vpc_name}-nginx-instance"
    Environment = var.app_environment
  }
}

#Create Application Load Balancer and Target Group
resource "aws_lb" "alb" {
  name               = "ngnixalb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [ aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id ]

  security_groups = [
    aws_security_group.alb_sg.id,
  ]

  tags = {
    Name = "ngnixalb"
  }
}

resource "aws_security_group" "alb_sg" {
  name_prefix = "alb-"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["112.204.173.11/32"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["112.204.173.11/32"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ngnixalb"
  }
}

resource "aws_lb_target_group" "tg" {
  name_prefix      = "alb-"
  port             = 80
  protocol         = "HTTP"
  vpc_id           = aws_vpc.main.id
  target_type      = "instance"
}

resource "aws_lb_target_group_attachment" "tgattach" {
  count = 4

  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = element(concat(aws_instance.nginx_instance_app1.*.id,aws_instance.nginx_instance_app2.*.id), count.index)
  port             = 80
}

# Create a listener for port 80
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}


