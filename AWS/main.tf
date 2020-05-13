provider "aws" {
  region           = "{REGION}"
  profile          = "{PROFILE}"
}

terraform {
  required_version = ">= 0.12"
  backend "s3" {
    bucket         = "{BUCKET}"
    region         = "{REGION}"
    profile        = "{PROFILE}"

    key            = "aws.tfstate"
    dynamodb_table = "terraform-jamulus"
  }
  required_providers {
    aws            = "~> 2.61"
  }
}
