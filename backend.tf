terraform {
  backend "s3" {
    bucket         = "magento-terraform-state-prod"
    key            = "global/s3/terraform.tfstate"
    region         = "eu-west-3"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
