locals {
  global = yamldecode(file(find_in_parent_folders("global.yaml")))
  env    = yamldecode(file(find_in_parent_folders("env.yaml")))
}

include "root" {
  path = find_in_parent_folders()
}

terraform {
  # FIXME
  source = "/Users/frederic/Documents/_work/119_hoverkraft-tech/src/terraform-modules//aws/ssh-key-pair"
}

# TODO: use password store in blueprints
# dependency "public_key" {
#   config_path = "../data/password-store/ssh-key"
#   mock_outputs_allowed_terraform_commands = ["init", "validate"]
#   mock_outputs = {
#     #checkov:skip=CKV_SECRET_6: this is a mock
#     password = "thisisnotsecret"
#   }
# }

inputs = {
  name        = "${local.env.name}@${local.env.customer.domain}"
  customer    = local.env.customer.name
  environment = local.env.name
  tags        = local.env.tags
  aws_region  = local.env.aws.region
  public_key  = local.env.aws.eks.node-groups[0].ssh-public-key
}
