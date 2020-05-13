provider "aws" {
  region           = "{REGION}"
  profile          = "{PROFILE}"
}

data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "jamulus_terraform_state_bucket" {
    bucket = "terraform-jamulus-${data.aws_caller_identity.current.account_id}"
    region = "{REGION}"
}

resource "aws_dynamodb_table" "jamulus_terraform_state_dynamodb" {
    name = "terraform-jamulus"
    hash_key = "LockID"
    billing_mode = "PAY_PER_REQUEST"
    attribute {
      name = "LockID"
      type = "S"
    }
}

output "bucketname" {
    value = aws_s3_bucket.jamulus_terraform_state_bucket.bucket
}
