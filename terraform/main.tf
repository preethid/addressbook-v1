terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.4.0"
    }
  }
  #   backend "s3" {
  #    bucket         = "tf-bucket-01111"
  #    key            = "terraform.tfstate"
  #    region         = "ap-south-1"
  #    encrypt        = true
  #    dynamodb_table = "dynamo-table-1"
  #    acl            = "private"
  #  }
}

provider "aws" {
  # Configuration options
    region     = "ap-south-1"
  #   access_key = "my-access-key"
  #   secret_key = "my-secret-key"
}



module "ec2" {
  source              = "./modules/ec2"
  instance_type       = var.instance_type
  env                 = var.env
}