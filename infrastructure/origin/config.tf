# This is the Interconnection layer.
# Its sole purpose is to connect modules and resources at the project level.

# This main file belongs to the local *origin*.
# An *origin* is a way to describe a root module when your project does not
# have one but multiple connecting to the same underlying modules and resources.

terraform {
  required_version = "~> 0.12.9"
}

provider "aws" {
  region = var.region
}
