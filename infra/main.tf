provider "aws" {
  region = local.region
}

data "aws_availability_zones" "available" {}

locals {
  cluster_name    = "poc"
  cluster_version = "1.21"
  region          = "us-west-2"
  dns_name        = "poc.example.com"
  tags = {
      createdWith = "terraform"
  }
}

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.8.0"
    }
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "~> 2.2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 3.2.1"
    }
  }
}
