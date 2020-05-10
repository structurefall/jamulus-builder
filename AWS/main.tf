provider "aws" {
  region           = "us-west-1"
  profile          = "personal"
}

terraform {
  required_version = ">= 0.12"
  backend "s3" {
    bucket         = "terraform-jamulus"
    region         = "us-west-1"
    profile        = "personal"

    key            = "aws.tfstate"
    dynamodb_table = "terraform-jamulus"
  }
  required_providers {
    aws            = "~> 2.61"
  }
}
