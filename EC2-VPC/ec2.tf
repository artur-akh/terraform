resource "aws_instance" "my_server" {
 count                  = 1                   # количество виртуалок
 ami                    = data.aws_ami.latest_aws.id
 instance_type          = var.instance_type
 vpc_security_group_ids = [aws_security_group.my_security.id]
 key_name               = var.key_name
 user_data              = file("script.sh")          # используем скрипт bash скрипт
 user_data_replace_on_change = true                  # переустановить сервер в случае изменения user_data bash скрипта
 subnet_id = aws_subnet.my_subnet_private1.id        # выбираем подсеть в котором создаем сервер

 tags = {
   Name = "AWS-LINUX"
 }
 # устанавливать только после my_server3 и 2
#  depends_on = [aws_instance.my_server3, aws_instance.my_server2]
}