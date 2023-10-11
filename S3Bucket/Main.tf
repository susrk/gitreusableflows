## backend data for terraform
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }

  backend "remote" {
  hostname = "app.terraform.io"  
  organization = "surabhiterraform1234"

    workspaces {
      name = "surabhiterraform1234"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

