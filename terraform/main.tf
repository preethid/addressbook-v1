terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.27.0"
    }
  }
#    backend "s3" {
#    bucket         = "s3-tf-112"
#    key            = "terraform.tfstate"
#    region         = "ap-south-1"
#    encrypt        = true
#    dynamodb_table = "tf-1"
#    acl            = "private"
#  }

}

provider "aws" {
  # Configuration options
  region = "ap-south-1"

}

# module "vpc" {
#   source              = "./modules/vpc"
#    vpc_cidr_block      = var.vpc_cidr_block
#   subnet_cidr_block   = var.subnet_cidr_block
#   availability_zone   = var.availability_zone
#   env                 = var.env
  
# }

module "ec2" {
  source         = "./modules/ec2"
 
  instance_type  = var.instance_type
 
  env            = var.env
}
