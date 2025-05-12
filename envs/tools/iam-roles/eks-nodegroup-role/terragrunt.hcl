locals {
  global = yamldecode(file(find_in_parent_folders("global.yaml")))
  env    = yamldecode(file(find_in_parent_folders("env.yaml")))
}

include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "github.com/hoverkraft-tech/terraform-modules.git?ref=1.9.0//aws/iam-role"
}

inputs = {
  name        = "AmazonEKSNodeRole"
  customer    = local.env.customer.name
  environment = local.env.name
  tags        = local.env.tags
  managed_policies_arns = [
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy",
  ]
  assume_role_policy = file("assume_role_policy.json")
}
