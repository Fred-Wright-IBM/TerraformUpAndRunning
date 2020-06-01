
provider "aws" {
  region = "eu-west-2"
}

module "webserver_cluster" {
  source = "/Users/freddie.wright@ibm.com/Documents/Dev/TerraformUpAndRunning/chapter2-4/modules/services/webserver-cluster"

  cluster_name           = "webservers-stage"
  db_remote_state_bucket = "s3bucket-bootcamp-fw"
  db_remote_state_key    = "global/s3/terraform.tfstate"
}
