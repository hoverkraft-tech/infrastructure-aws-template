locals {
  global = yamldecode(file(find_in_parent_folders("global.yaml")))
  env    = yamldecode(file(find_in_parent_folders("env.yaml")))
}

include "root" {
  path = find_in_parent_folders()
}

terraform {
  # FIXME
  source = "/Users/frederic/Documents/_work/119_hoverkraft-tech/src/terraform-modules//aws/iam-eks-oidc-provider"
}

dependency "cluster" {
  config_path = "../controlplane"
  mock_outputs_allowed_terraform_commands = ["init", "validate"]
  mock_outputs = {
    name              = "test"
    security_group_id = "sg-1234567890"
    oidc_issuer_url   = "https://oidc.eks.us-east-1.amazonaws.com/id/1234567890"
    sha1_fingerprint  = "1234567890"
  }
}

inputs = {
  name            = "${local.env.name}-oidc-provider"
  customer        = local.env.customer.name
  environment     = local.env.name
  tags            = local.env.tags
  url             = dependency.cluster.outputs.oidc_issuer_url
  thumbprint_list = [dependency.cluster.outputs.sha1_fingerprint]
}
