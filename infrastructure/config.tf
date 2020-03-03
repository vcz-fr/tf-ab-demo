# [INFO] Define global Terraform attributes
terraform {
  required_version = "~> 0.12.18"
}

# [INFO] Define the default deployment region
# eu-west-1 -> Ireland
provider "aws" {
  region  = "eu-west-1"
  version = "~> 2.51"
}
