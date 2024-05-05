terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.47.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}



resource "aws_s3_bucket" "s3_bucket" {
  bucket = "northbay-test-bucket-3451100202"
}

resource "aws_kinesis_stream" "my_stream" {
  name = "my-stream"
  shard_count      = 1
}




