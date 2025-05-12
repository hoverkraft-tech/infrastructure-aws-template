locals {
  global = yamldecode(file(find_in_parent_folders("global.yaml")))
  env    = yamldecode(file(find_in_parent_folders("env.yaml")))
}

include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "/Users/frederic/Documents/_work/119_hoverkraft-tech/src/terraform-modules//aws/iam-policy"
  // source = "github.com/hoverkraft-tech/terraform-modules.git?ref=1.9.0//aws/iam-policy"
}

dependency "role" {
  config_path = "../../iam-roles/eks-nodegroup-role"

  mock_outputs_allowed_terraform_commands = ["validate"]
  mock_outputs = {
    arn = "arn:aws:iam::123456789012:role/test-role"
  }
}

dependency "k8s" {
  config_path = "../../eks/controlplane"

  mock_outputs_allowed_terraform_commands = ["validate"]
  mock_outputs = {
    name = "test-cluster"
  }
}

inputs = {
  name        = "KarpenterBase"
  customer    = local.env.customer.name
  environment = local.env.name
  tags        = local.env.tags
  policy = templatefile("policy.json", {
    eks_cluster_arn = dependency.k8s.outputs.arn
    eks_node_role_arn = dependency.role.outputs.arn
  })
}
