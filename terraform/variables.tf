variable "instance_type" {
 description = "EC2 instance type"
 default     = "t2.micro"
}
variable "env" {
}
variable "vpc_cidr_block" {
 description = "CIDR block for the VPC"
 default     = "10.0.0.0/16"
}
variable "subnet_cidr_block" {
 description = "CIDR block for the public subnet"
 default     = "10.0.1.0/24"
}
variable "availability_zone" {
 description = "Availability zone for the subnet"
 default     = "ap-south-1a"
}