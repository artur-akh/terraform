variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-3"
}
 
variable "instance_type" {            # выбор типа сервера
  description = "Please enter instance_type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {                 # ssh ключ сервера
  description = "Please enter key_name"
  type        = string
}