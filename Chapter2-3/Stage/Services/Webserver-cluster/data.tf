
data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.default.id
  tags = {
    Name = "Private*"
  }
}


#Commenting out the below as wasn't able to creae the the db_instance that this key relates to due to not having the
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
    bucket = "s3bucket-bootcamp-fw"
    key = "global/s3/terraform.tfstate"
    region = "eu-west-2"
  }
}
