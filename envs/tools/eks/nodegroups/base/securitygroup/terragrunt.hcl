locals {
  global = yamldecode(file(find_in_parent_folders("global.yaml")))
  env    = yamldecode(file(find_in_parent_folders("env.yaml")))
}

include "root" {
  path = find_in_parent_folders()
}

terraform {
  # FIXME
  source = "/Users/frederic/Documents/_work/119_hoverkraft-tech/src/terraform-modules//aws/security-group"
}

dependency "vpc" {
  config_path = "../../../../network/vpc"
  mock_outputs_allowed_terraform_commands = ["init", "validate"]
  mock_outputs = {
    vpc_id = "xxxx"
    private_subnet_ids = ["xxx", "yyy", "zzz"]
    public_subnet_ids = ["xxx", "yyy", "zzz"]
  }
}

dependency "cluster" {
  config_path = "../../../../eks/controlplane"
  mock_outputs_allowed_terraform_commands = ["init", "validate"]
  skip_outputs = true
  mock_outputs = {}
}

inputs = {
  name        = "eks-${local.env.aws.eks.cluster.name}-nodes"
  customer    = local.env.customer.name
  environment = local.env.name
  tags        = local.env.tags
  vpc_id      = dependency.vpc.outputs.vpc_id
  sg_rules = {
    ingress_nodes_22 = {
      description = "allow ssh in"
      type        = "ingress"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [local.env.aws.network.vpc.cidr]
    }
  }
}
