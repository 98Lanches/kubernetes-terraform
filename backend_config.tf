terraform {
  backend "s3" {
    key    = "states/kubernetes-terraform"
    region = "us-east-1"
  }
}