output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.addressbook.id
}

output "public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.addressbook.public_ip
}

output "public_dns" {
  description = "Public DNS name of the EC2 instance"
  value       = aws_instance.addressbook.public_dns
}

output "security_group_id" {
  description = "ID of the security group attached to the instance"
  value       = aws_security_group.addressbook.id
}
