variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "ap-south-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Name of an existing EC2 key pair (in this region) to enable SSH access"
  type        = string
}

variable "ssh_allowed_cidr" {
  description = "CIDR block allowed to SSH into the instance (restrict this to your own IP, e.g. 1.2.3.4/32)"
  type        = string
  default     = "0.0.0.0/0"
}

variable "app_port" {
  description = "Port the addressbook app (Tomcat/Docker container) listens on"
  type        = number
  default     = 8080
}

variable "project_name" {
  description = "Name prefix used to tag/name resources"
  type        = string
  default     = "addressbook"
}
