provider "aws" {
    region = "eu-west-2"
}

resource "aws_instance" "instance1" {
    ami = "ami-006a0174c6c25ac06"
    instance_type = "t2.micro"
    key_name = "FWKeyPair"

    tags = {
      Name = "terraform-workspace-example-fw"
    }
}

terraform {
  backend "s3" {
    bucket = "s3bucket-bootcamp-fw"
    key = "workspace-example/terraform.tfstate"
    region = "eu-west-2"

    dynamodb_table = "dynamodb-bootcamp-fw"
    encrypt = true
  }
}
