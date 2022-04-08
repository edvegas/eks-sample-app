module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.0"

  name = "poc-vpc"
  cidr = "10.10.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = ["10.10.0.0/20", "10.10.16.0/20", "10.0.32.0/20"]
  public_subnets       = ["10.10.48.0/24", "10.10.64.0/20", "10.0.80.0/20"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  tags = local.tags

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}