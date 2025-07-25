output "ip"{
   value = aws_instance.webserver
}
output "public_ip" {
value = aws_instance.webserver.public_ip
}
