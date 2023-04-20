terraform {
  required_version = ">=0.13.1"

  required_providers {
    aws = ">=4.63.0"
  }

  backend "s3" {
    bucket = "desafio-ton-redshift-tfstate-repository"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
