#####################################
## Network -    Variables ##
#####################################


variable "aws_region" {
  type = string
  description = "AWS region"
  default = "us-east-2"
}

variable "app_environment" {
  type        = string
  description = "Environment"
  default = "Dev"
}

variable "app_stg_app" {
  type        = string
  description = "Application name"
  default = "wil.com"
}


variable "app_name_app" {
  type        = string
  description = "Application name"
  default = "WILSA01"
}

variable "ec2_tag" {
  type        = string
  description = "Environment"
  default = "migO0SDOZVJMB"
}

variable "app_name_db1" {
  type        = string
  description = "Application name"
  default = "WILRP01"
}
variable "customer_name" {
  type        = string
  description = "customer name"
  default = "wil company"
}


variable "app_name_lic1" {
  type        = string
  description = "Application name"
  default = "WILLIC01"
}



variable "aws_az" {
  type        = list 
  description = "AWS AZ"
  default     = [ "us-east-2"]
}


variable "vpc_cidr" {
  type        = string
  description = "CIDR for the VPC"
  default     = "10.220.100.32/27"
}


variable "public_subnet_cidr-1" {
  type        = string
  description = "CIDR for the public subnet"
  default     = "10.220.100.32/28"
}

variable "public_subnet_cidr-2" {
  type        = string
  description = "CIDR for the private subnet"
  default     = "10.220.100.48/28"
}

variable "vpc_name" {
  type        = string
  description = "vpc name"
  default = "WILVPC01"
}



########################################
## EC2- Variables ##
########################################

variable "windows_instance_type" {
  type        = list
  description = "EC2 instance type for Windows Server"
  default     = ["t2.micro"]
}


variable "windows_associate_public_ip_address" {
  type        = bool
  description = "Associate a public IP address to the EC2 instance"
  default     = false
}

variable "windows_root_volume_size_app" {
  type        = number
  description = "Volumen size of root volumen of Windows Server"
  default     = "100"
}

variable "windows_data_volume_size_app" {
  type        = number
  description = "Volumen size of data volumen of Windows Server"
  default     = "600"
}

variable "windows_root_volume_size_db" {
  type        = number
  description = "Volumen size of root volumen of Windows Server"
  default     = "100"
}

variable "windows_data_volume_size_db" {
  type        = number
  description = "Volumen size of data volumen of Windows Server"
  default     = "100"
}

variable "windows_root_volume_size_lic" {
  type        = number
  description = "Volumen size of root volumen of Windows Server"
  default     = "100"
}

variable "windows_data_volume_size_lic" {
  type        = number
  description = "Volumen size of data volumen of Windows Server"
  default     = "100"
}

variable "windows_root_volume_type" {
  type        = string
  description = "Volumen type of root volumen of Windows Server. Can be standard, gp3, gp2, io1, sc1 or st1"
  default     = "gp2"
}

variable "windows_data_volume_type" {
  type        = string
  description = "Volumen type of data volumen of Windows Server. Can be standard, gp3, gp2, io1, sc1 or st1"
  default     = "gp2"
}

