locals {
  global = yamldecode(file(find_in_parent_folders("global.yaml")))
  env    = yamldecode(file(find_in_parent_folders("env.yaml")))
}

include "root" {
  path = find_in_parent_folders()
}

terraform {
  # FIXME
  source = "/Users/frederic/Documents/_work/119_hoverkraft-tech/src/terraform-modules//aws/vpc"
}

inputs = {
  name = "${local.env.name}"
  customer = "acme"
  environment = local.env.name

  public_subnets = { for subnet in local.env.aws.network.public.subnets:
    subnet.availability-zone => {
      name = "pub-${subnet.availability-zone}"
      cidr = subnet.cidr
    }
  }
  private_subnets = { for subnet in local.env.aws.network.private.subnets:
    subnet.availability-zone => {
      name = "priv-${subnet.availability-zone}"
      cidr = subnet.cidr
    }
  }

}
