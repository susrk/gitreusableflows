terraform {
	required_providers {
		aws = {
			source = "hashicorp/aws"
		}
	}

	backend "remote" {
		hostname = "app.terraform.io"
		organization = "Surabhiterraform1234"

		workspaces {
			name = "EKS-Terraform"
		}
	}
}

provider "aws" {
	region = "us-east-1"
}
