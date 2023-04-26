# вывод публичного IP адреса сервера terraform show
output "name" {
  value = aws_instance.aws_vpn.public_ip
}

#----- находим самый актуальный AMI --------
data "aws_ami" "latest_aws" {
  most_recent      = true
  owners           = ["137112412989"]
#  owners           = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.*-x86_64-gp2"]
  }
}
# выводит ami id: ami-06616b7884ac98cdd
output "aws_ami_id" {
    value = data.aws_ami.latest_aws.id
}
# выводит ami name: amzn2-ami-kernel-5.10-hvm-2.0.20230307.0-x86_64-gp2
output "aws_ami_name" {
    value = data.aws_ami.latest_aws.name
}

#-----REGION and ZONE --------
# получить дата центры в регионе к примеру "eu-central-1a, 1b, 1с"
data "aws_availability_zones" "my_zone_data" {}
# вывести дата центры в регионе
# выводит только первый дата центр [0]
output "data_aws_availability_zones" {
  value = data.aws_availability_zones.my_zone_data.names
  #value = data.aws_availability_zones.my_zone_data.names[0]
}
# получить название региона: eu-central-1"
data "aws_region" "my_region_id" {}
# вывести название региона
output "data_aws_region_name" {
 value = data.aws_region.my_region_id.name
}
# Другой вариант вывода именно переменной, которую я задал
output "region" {
  description = "AWS region"
  value       = var.region
}

# вывести описание региона: "Europe (Frankfurt)"
output "data_aws_region_description" {
 value = data.aws_region.my_region_id.description
}

#-----AWS Account ID --------
# получить аккаунт ID aws: "005268342"
data "aws_caller_identity" "my_account_id" {}
# вывод аккаунт ID aws
output "data_aws_caller_identity" {
 value = data.aws_caller_identity.my_account_id.account_id
}

#-----VPC--------
# получить все VPC: "vpc-0a9b37748ce2ed116"
data "aws_vpcs" "my_vpc_full" {}
# вывести все VPC
output "data_vpc" {
 value = data.aws_vpcs.my_vpc_full.ids
}

#-----Специальные параметры только для этого проекта--------
# имеется VPC у которого tag (имя) - my_test_vpc и его необходимо вывести: "vpc-0a9b37748ce2ed116"
# data "aws_vpc" "my_vpc_tag" {
#  tags = {
#    Name = "my_test_vpc"
#  }
# }
# вывести VPC id - my_test_vpc: "vpc-0a9b37748ce2ed116"
# output "my_vpc_tag" {
#  value = data.aws_vpc.my_vpc_tag.id
# }

# покажет адрес подсети (cidr) - my_test_vpc: "192.168.3.0/24"
# output "my_vpc_cidr" {
#  value = data.aws_vpc.my_vpc_tag.cidr_block
# }
