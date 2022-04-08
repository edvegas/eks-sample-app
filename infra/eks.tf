module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "18.19.0"
  cluster_name    = local.cluster_name
  cluster_version = "1.21"
  tags            = merge(local.tags, { Name = local.cluster_name })
  vpc_id          = module.vpc.vpc_id
  eks_managed_node_groups = {
    poc = {
      min_size       = 1
      max_size       = 3
      desired_size   = 1
      instance_types = ["t3.medium"]
      subnet_ids     = module.vpc.private_subnets
    }
  }
  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {}
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
  }
}

resource "aws_route53_zone" "poc" {
  name = local.dns_name
  tags = local.tags
}

module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "3.4.0"

  domain_name  = local.dns_name
  zone_id      = aws_route53_zone.poc.zone_id

  subject_alternative_names = [
    "*.${local.dns_name}",
  ]

  wait_for_validation = true

  tags = local.tags
}

module "external_dns_irsa_role" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version                       = "4.18.0"
  role_name                     = "external-dns"
  attach_external_dns_policy    = true
  external_dns_hosted_zone_arns = [aws_route53_zone.poc.arn]

  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:external-dns"]
    }
  }
  tags = local.tags
}

module "load_balancer_controller_irsa_role" {
  source                                 = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version                                = "4.18.0"
  role_name                              = "load-balancer-controller"
  attach_load_balancer_controller_policy = true

  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }
  tags = local.tags
}
