resource "aws_security_group" "mywebsecurity" {
 name        = "my_web_security"
 
 ingress {
   description = "HTTP"
   from_port   = 8080
   to_port     = 8080
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
 }
 ingress {
   description = "SSH"
   from_port   = 22
   to_port     = 22
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
 }
egress {
from_port = 0
to_port = 0
protocol = "-1"
cidr_blocks = ["0.0.0.0/0"]
ipv6_cidr_blocks = ["::/0"]
}
 tags = {
   Name = "${var.env}-sg"
 }
}
data "aws_ami" "latest-amazon-linux-image" {
   most_recent = true
   owners = ["amazon"]
   filter {
       name = "name"
       values = ["amzn2-ami-kernel-*-x86_64-gp2"]
   }
   filter {
       name = "virtualization-type"
       values = ["hvm"]
   }
}
resource "aws_instance" "webserver" {
 ami           = data.aws_ami.latest-amazon-linux-image.id
 instance_type = var.instance_type
 associate_public_ip_address = true
 
 vpc_security_group_ids = [aws_security_group.mywebsecurity.id]
 key_name="demo"
 //user_data =file("userdata.sh")
 tags={
   Name= "${var.env}-webserver"
 }
}