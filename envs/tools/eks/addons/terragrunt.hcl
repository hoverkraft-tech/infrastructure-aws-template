locals {
  global = yamldecode(file(find_in_parent_folders("global.yaml")))
  env    = yamldecode(file(find_in_parent_folders("env.yaml")))
}

include "root" {
  path = find_in_parent_folders()
}

terraform {
  # FIXME
  source = "/Users/frederic/Documents/_work/119_hoverkraft-tech/src/terraform-modules//aws/eks-addons"
}

dependency "cluster" {
  config_path = "../controlplane"
  mock_outputs_allowed_terraform_commands = ["init", "validate"]
  mock_outputs = {
    name = "myekscluster"
  }
}

dependency "nodes" {
  # NOTE : we need a nodegroup to addons pods to be scheduled and succeed
  skip_outputs = true
  config_path = "../nodegroups/base/nodegroup"
  mock_outputs_allowed_terraform_commands = ["init", "validate"]
  mock_outputs = {}
}

inputs = {
  name         = "eks-addons"
  customer     = local.env.customer.name
  environment  = local.env.name
  tags         = merge(local.env.tags, { backup-plan = "default" })
  addons       = local.env.aws.eks.addons
  cluster_name = dependency.cluster.outputs.name
}
