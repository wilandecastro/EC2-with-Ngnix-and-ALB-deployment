output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_1_id" {
  description = "ID of the first public subnet"
  value       = aws_subnet.public_subnet_1.id
}

output "public_subnet_2_id" {
  description = "ID of the second public subnet"
  value       = aws_subnet.public_subnet_2.id
}

output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.allow_http_ssh.id
}
output "instance_public_ip" {
  value = aws_instance.amazon_linux_2.public_ip
}



