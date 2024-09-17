resource "aws_security_group" "basic_sg" {
  name        = "dotlanche-security-group"
  description = "A basic security group"

  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Permitir tráfego de entrada de qualquer lugar
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Permitir tráfego de saída para qualquer lugar
  }

  tags = {
    Name = "dotlanche-security-group"
  }
}

output "security_group_id" {
  value = aws_security_group.basic_sg.id
}