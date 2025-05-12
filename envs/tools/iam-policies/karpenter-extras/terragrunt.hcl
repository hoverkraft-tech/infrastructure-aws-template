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

inputs = {
  name        = "KarpenterExtras"
  customer    = local.env.customer.name
  environment = local.env.name
  tags        = local.env.tags
  policy = file("policy.json")
}
