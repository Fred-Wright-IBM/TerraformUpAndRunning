provider "aws" {
  region = "eu-west-2"
}

#Create an MySQL database on Amazon's RDS (Amazons relational database), with 10gb of storage on an db.t2.micro instance
# which has 1 virtual CUP, 1gb memory which is part of the free tier. Don't want to intsert the password as plain text
# so we use a variable that that passes the password from a third part source, such as 1Password, or we can use
# AWS secrets manager
resource "aws_db_instance" "example" {
  identifier_prefix = "terraform-up-and-running"
  engine = "mysql"
  allocated_storage = 10
  instance_class = "db.t2.micro"
  name = "example_database_fw"
  username = "admin"
  password = var.db_password
}

terraform {
  backend = "s3" {
    bucket = "s3bucket-bootcamp-fw"
    key = "stage/data-stores/mysql/terraform.tfstate"
    region = "eu-west-2"

    dynamodb = "dynamodb-bootcamp-fw"
    encrypt = true
  }  
}
