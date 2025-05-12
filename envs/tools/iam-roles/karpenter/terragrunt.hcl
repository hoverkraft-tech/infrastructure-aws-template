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

dependency "oidc_provider" {
  config_path = "../../eks/oidc-provider"
  mock_outputs = {
    arn = "arn:aws:iam::123456789012:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/12345678901234567890123456789012"
    url = "https://oidc.eks.us-east-1.amazonaws.com/id/12345678901234567890123456789012"
  }
}

dependency "policy-main" {
  config_path = "../../iam-policies/karpenter-main"
  mock_outputs = {
    arn = "arn:aws:iam::123456789012:policy/karpenter1"
  }
}

dependency "policy-extras" {
  config_path = "../../iam-policies/karpenter-extras"
  mock_outputs = {
    arn = "arn:aws:iam::123456789012:policy/karpenter2"
  }
}

inputs = {
  name        = "KarpenterTools"
  customer    = local.env.customer.name
  environment = local.env.name
  tags        = local.env.tags
  assume_role_policy = templatefile("assume_role_policy.json", {
    oidc_provider_arn = dependency.oidc_provider.outputs.arn
    oidc_provider_url = dependency.oidc_provider.outputs.url
    namespace         = "karpenter"
    service_account   = "karpenter"
  })
  managed_policies_arns = [
    dependency.policy-main.outputs.arn,
    dependency.policy-extras.outputs.arn
  ]
}
