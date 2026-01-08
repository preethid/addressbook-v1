# variable "vpc_id" {
#  description = "VPC ID"
# }
# variable "subnet_id" {
#  description = "Public Subnet ID"
# }
variable "instance_type" {
 description = "EC2 instance type"
 default     = "t2.micro"
}
variable env{
 }