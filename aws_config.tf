# Указываем провайдер, который будет использоваться для развертывания
provider "aws" {
  region = "eu-central-1"
}

# Создаем key pair
resource "aws_key_pair" "my_key_pair" {
  key_name   = "my-key-pair"
  public_key = file("~/.ssh/my-key-pair")
}

# Создаем security group
resource "aws_security_group" "my_security_group" {
  name_prefix = "my-security-group"
  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Добавляем правило исходящего трафика
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "all"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# Создаем EC2 instance
resource "aws_instance" "my_instance" {
  ami           = "ami-0d1ddd83282187d18"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.my_key_pair.key_name
  vpc_security_group_ids = [aws_security_group.my_security_group.id]

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update
              sudo apt install -y python3-pip
              sudo apt install -y git
              git clone https://github.com/iso73-ops/flask_full_pipeline_pet
              cd flask_full_pipeline_pet
              pip3 install -r requirements.txt
              python3 app.py
              EOF
}

# Выводим публичный IP-адрес созданной инстанции
output "public_ip" {
  value = aws_instance.my_instance.public_ip
}
