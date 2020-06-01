
data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.default.id
  tags = {
    Name = "Private*"
  }
}


#Commenting out the below as wasn't able to create the the db_instance that this key relates to due to not having the
# policy in the AMI. Changing example to the uncommented code below
#This code receives data from the terraform.tfstate file that would have been created as a result of the db_instance located
# in the s3 bucket in the list key address

# data "terraform_remote_state" "db" {
#   backend = "s3"
#
#     config = {
#         bucket = "s3bucket-bootcamp-fw"
#         key = "stage/data-stores/mysql/terraform.tfstate"
#         region = "eu-west-2"
#     }
# }


#creating a data source that reads into the terraform.tfstate file in the global/s3 file within the s3 bucket
data "terraform_remote_state" "s3" {
  backend = "s3"

  config = {
    bucket = var.db_remote_state_bucket
    key = var.db_remote_state_key
    region = "eu-west-2"
  }
}

data "template_file" "user_data" {
  template = file("user-data.sh")

  vars = {
    server_port = var.server_port
    dynamodb_table_name = data.terraform_remote_state.s3.outputs.dynamodb_table_name
  }
}
