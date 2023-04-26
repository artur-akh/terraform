# создать свою VPC
resource "aws_vpc" "my_vpc" {
 cidr_block       = "192.168.0.0/16"
 enable_dns_hostnames = true
 tags = {
   Name = "my_vpc192"
 }
}
# создать gateway для доступа в интернет для my_vpc. Нужно чтобы был доступ к интернету у нашей подсети
resource "aws_internet_gateway" "my_gateway" {
 vpc_id = aws_vpc.my_vpc.id
 tags = {
   Name = "my_gateway192"
 }
}

# PUBLIC - имеет публичный адрес и доступ в инет
# Private - не имеет публичного IP адреса, но доступ в сеть будет осуществляться с помощью NAT gateway сервер
# Database - тот private, но только нет доступа к сети

# создать 2 PUBLIC подсети в разных дата центрах (availability_zones)
resource "aws_subnet" "my_subnet_public1" {
 vpc_id     = aws_vpc.my_vpc.id
# может быть равен data source 
# vpc_id     = data.aws_vpc.my_vpc_tag.id
 cidr_block = "192.168.1.0/24"
 # привязка к дату центру 1: eu-central-1a
 availability_zone = data.aws_availability_zones.my_zone_data.names[0]
 # выдача публичного адреса подсети Auto-assign public IPv4
 map_public_ip_on_launch = true
 tags = {
 # добавить переменную в имя
   Name = "subnet_${data.aws_availability_zones.my_zone_data.names[0]}"
   Account = "my account ${data.aws_caller_identity.my_account_id.account_id}"
   Region = "my region ${data.aws_region.my_region_id.description}"
 }
}
# Создаем вторую public сеть
resource "aws_subnet" "my_subnet_public2" {
 vpc_id     = aws_vpc.my_vpc.id
 cidr_block = "192.168.2.0/24"
 availability_zone = data.aws_availability_zones.my_zone_data.names[1]
 map_public_ip_on_launch = true
 tags = {
   Name = "my_subnet_public2"
 }
}
# создать public router для маршрутизации
resource "aws_route_table" "my_router_public" {
 vpc_id = aws_vpc.my_vpc.id
 route {
   cidr_block = "0.0.0.0/0"
   # указать наш gateway созданный ранее
   gateway_id = aws_internet_gateway.my_gateway.id
 }
 tags = {
   Name = "my_router_public"
 }
}
# настроить маршрутизацию между подсетями в PUBLIC: с подсети public на publicRouter
resource "aws_route_table_association" "a" {
 subnet_id      = aws_subnet.my_subnet_public1.id
 route_table_id = aws_route_table.my_router_public.id
}
resource "aws_route_table_association" "b" {
 subnet_id      = aws_subnet.my_subnet_public2.id
 route_table_id = aws_route_table.my_router_public.id
}
# создать 2 PRIVATE сети
resource "aws_subnet" "my_subnet_private1" {
 vpc_id     = aws_vpc.my_vpc.id
 cidr_block = "192.168.11.0/24"
 availability_zone = data.aws_availability_zones.my_zone_data.names[0]
 tags = {
   Name = "my_subnet_private1"
 }
}

resource "aws_subnet" "my_subnet_private2" {
 vpc_id     = aws_vpc.my_vpc.id
 cidr_block = "192.168.12.0/24"
 availability_zone = data.aws_availability_zones.my_zone_data.names[1]
 tags = {
   Name = "my_subnet_private2"
 }
}
# создать маршрутизацию PRIVATE router 1, нужно 2, т.к используется 2NAT с эластик IP
resource "aws_route_table" "my_router_private1" {
 vpc_id = aws_vpc.my_vpc.id
 route {
   cidr_block = "0.0.0.0/0"
   nat_gateway_id = aws_nat_gateway.my_nat_gateway1.id
 }
 tags = {
   Name = "my_router_private1"
 }
}

resource "aws_route_table_association" "c" {
 subnet_id      = aws_subnet.my_subnet_private1.id
 route_table_id = aws_route_table.my_router_private1.id
}
# создать маршрутизацию PRIVATE router 2
resource "aws_route_table" "my_router_private2" {
 vpc_id = aws_vpc.my_vpc.id
 route {
   cidr_block = "0.0.0.0/0"
   nat_gateway_id = aws_nat_gateway.my_nat_gateway2.id
 }
 tags = {
   Name = "my_router_private2"
 }
}
resource "aws_route_table_association" "d" {
 subnet_id      = aws_subnet.my_subnet_private2.id
 route_table_id = aws_route_table.my_router_private2.id
}
# создать 2 DataBase подсети
resource "aws_subnet" "my_subnet_db1" {
 vpc_id     = aws_vpc.my_vpc.id
 cidr_block = "192.168.21.0/24"
 availability_zone = data.aws_availability_zones.my_zone_data.names[0]
 tags = {
   Name = "my_subnet_db1"
 }
}

resource "aws_subnet" "my_subnet_db2" {
 vpc_id     = aws_vpc.my_vpc.id
 cidr_block = "192.168.22.0/24"
 availability_zone = data.aws_availability_zones.my_zone_data.names[1]
 tags = {
   Name = "my_subnet_db2"
 }
}
# создаем маршрутизацию DB router
resource "aws_route_table" "my_router_db" {
 vpc_id = aws_vpc.my_vpc.id
 tags = {
   Name = "my_router_db"
 }
}
resource "aws_route_table_association" "e" {
 subnet_id      = aws_subnet.my_subnet_db1.id
 route_table_id = aws_route_table.my_router_db.id
}
resource "aws_route_table_association" "f" {
 subnet_id      = aws_subnet.my_subnet_db2.id
 route_table_id = aws_route_table.my_router_db.id
}
# подключить elastic ip к aws_instance.my_server1.id
resource "aws_eip" "my_ip_nat1" {
 # эластик ip для конкретного instance
 # instance = aws_instance.my_server1.id
 vpc = true
 tags = {
   Name = "ip_nat1"
 }
}
resource "aws_eip" "my_ip_nat2" {
 vpc = true
 tags = {
   Name = "ip_nat2"
 }
}
# Создание nat gateway1
resource "aws_nat_gateway" "my_nat_gateway1" {
 allocation_id = aws_eip.my_ip_nat1.id
 subnet_id     = aws_subnet.my_subnet_public1.id
 tags = {
   Name = "my_nat_gateway1"
 }
}
# Создание nat gateway2
resource "aws_nat_gateway" "my_nat_gateway2" {
 allocation_id = aws_eip.my_ip_nat2.id
 subnet_id     = aws_subnet.my_subnet_public2.id
 tags = {
   Name = "my_nat_gateway2"
 }
}
