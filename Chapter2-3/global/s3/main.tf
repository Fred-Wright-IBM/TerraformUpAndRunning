provider "aws" {
  region = "eu-west-2"
}

resource "aws_s3_bucket" "terraform_state" {
    bucket = "s3bucket-bootcamp-fw"

#prevent acidental deletion of this s3 bucket
    lifecycle {
      prevent_destroy = true
    }

#enable versioning so can see the full version history of the state files
    versioning {
      enabled = true
      }

#enable server-side encription by default
    server_side_encryption_configuration {
      rule {
        apply_server_side_encryption_by_default {
          sse_algorithm = "AES256"
        }
      }
    }
}

resource "aws_dynamodb_table" "terraform_locks" {
    name = "dynamodb-bootcamp-fw"
    billing_mode = "PAY_PER_REQUEST"
    hash_key =  "LockID"

    attribute {
      name = "LockID"
      type = "S"
    }
}

terraform {
  backend "s3" {
    bucket = "s3bucket-bootcamp-fw"
    key = "global/s3/terraform.tfstate"
    region = "eu-west-2"

    dynamodb_table = "dynamodb-bootcamp-fw"
    encrypt = true
  }
}
