locals {
  global = yamldecode(file(find_in_parent_folders("global.yaml")))
  env    = yamldecode(file(find_in_parent_folders("env.yaml")))
}

include "root" {
  path = find_in_parent_folders()
}

terraform {
  # FIXME: use GH source
  source = "/Users/frederic/Documents/_work/119_hoverkraft-tech/src/terraform-modules//aws/eks-cluster"
}

dependency "vpc" {
  config_path = "../../network/vpc"
  mock_outputs_allowed_terraform_commands = ["init", "validate"]
  mock_outputs = {
    vpc_id = "xxxx"
    private_subnet_ids = ["xxx", "yyy", "zzz"]
    public_subnet_ids = ["xxx", "yyy", "zzz"]
  }
}

dependency "role" {
  config_path = "../../iam-roles/eks-role"
  mock_outputs_allowed_terraform_commands = ["init", "validate"]
  mock_outputs = {
    arn = "arn:aws:iam::${local.env.aws.account.id}:role/EKSRole"
  }
}

inputs = {
  name                    = local.env.aws.eks.cluster.name
  customer                = local.env.customer.name
  environment             = local.env.name
  tags                    = merge(local.env.tags, { backup-plan = "default" })
  k8s_version             = local.env.aws.eks.cluster.version
  role_arn                = dependency.role.outputs.arn
  endpoint_public_access  = local.env.aws.eks.cluster.endpoint.public-access
  public_access_cidrs     = local.env.aws.eks.cluster.endpoint.public-access-cidrs
  endpoint_private_access = local.env.aws.eks.cluster.endpoint.private-access
  subnet_ids              = dependency.vpc.outputs.private_subnet_ids
  service_ipv4_cidr       = local.env.aws.eks.cluster.service-ipv4-cidr
}
