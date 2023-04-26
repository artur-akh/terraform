resource "aws_security_group" "my_security" {
 name = "my_security"  
 
 # динамическое открытие портов, чтобы сразу несколько портов
 dynamic "ingress" {
   for_each = ["500", "4500"]
   content {
     from_port   = ingress.value
     to_port     = ingress.value
     protocol    = "udp"
     cidr_blocks = ["0.0.0.0/0"]
   }
 }
 # то что приходит на сервер
 ingress {
   from_port   = 22
   to_port     = 22
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
 }
 # то что уходит
 egress {
   from_port   = 0
   to_port     = 0
   protocol    = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }

 tags = {
   Name = "my_security"
 }
}