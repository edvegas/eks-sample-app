## Information

To be added for real usage:

* Store state in S3 and lock in DynamoDB

* Add cluster autoscaler

* Use real DNS names and validate certificate

* Use private Docker repo

* Use more flexible helm chart

* Use CI/CD tool

## Pre-requisites:

* Installed [Helm](https://helm.sh/docs/intro/install/)

* Installed [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) version >=1.0

## Prepare EKS and related resources:

```git clone https://github.com/edvegas/eks-sample-app.git```

```cd infra && terraform init```

Check resources that should be created

```terraform plan```

Apply changes

```terraform apply```

## Build and run application in EKS

Run bash script to build application docker image and push it to dockerhub (of course in real world this will be private repo).
Pass dockerhub username and repository name as arguments

```source build.sh YOURUSERNAME YOURREPO```

For example

```./build.sh edvegas edvegas/poc```

Enter your dockerhub repository password and press Enter.

Once image is pushed to repo, we are ready to run it in EKS

GO GO GO

Go to Helm Chart directory

```cd chart```

Change ```values.yaml``` file with appropriate values from your AWS account (DNS name, ACM https certificate ARN and container image location)

Run application in kubernetes:

```helm install poc ./```

External DNS will add entry to Route53 in 5 minutes so you'll be able to access application with HTTPS and custom domain name.
