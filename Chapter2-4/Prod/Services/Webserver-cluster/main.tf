
provider "aws" {
  region = "eu-west-2"
}

module "webserver_cluster" {
  source = "/Users/freddie.wright@ibm.com/Documents/Dev/TerraformUpAndRunning/chapter2-4/modules/services/webserver-cluster"
}
