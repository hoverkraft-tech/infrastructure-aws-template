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
  name        = "EKSRole"
  customer    = local.env.customer.name
  environment = local.env.name
  tags        = local.env.tags
  managed_policies_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
  ]
  assume_role_policy = templatefile("assume_role_policy.json", {
    aws_extra_principal = local.env.aws.control-tower.administrator-access-role-arn
  })
}
