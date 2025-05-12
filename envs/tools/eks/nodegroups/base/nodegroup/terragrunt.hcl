locals {
  global = yamldecode(file(find_in_parent_folders("global.yaml")))
  env    = yamldecode(file(find_in_parent_folders("env.yaml")))
}

include "root" {
  path = find_in_parent_folders()
}

terraform {
  # FIXME
  source = "/Users/frederic/Documents/_work/119_hoverkraft-tech/src/terraform-modules//aws/eks-nodegroup"
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

dependency "eks" {
  config_path = "../../../controlplane"
  mock_outputs_allowed_terraform_commands = ["init", "validate"]
  mock_outputs = {
    name              = "test"
    security_group_id = "sg-1234567890"
  }
}

dependency "role" {
  config_path = "../../../../iam-roles/eks-nodegroup-role"
  mock_outputs_allowed_terraform_commands = ["init", "validate"]
  mock_outputs = {
    arn = "arn:aws:iam::1234567890:role/eks-node-role"
  }
}

dependency "launch_template" {
  config_path = "../../../launch-templates/base-node"
  mock_outputs_allowed_terraform_commands = ["init", "validate"]
  mock_outputs = {
    id             = "lt-1234567890"
    latest_version = 1
  }
}

inputs = {
  name                    = local.env.aws.eks.node-groups[0].name
  customer                = local.env.customer.name
  environment             = local.env.name
  tags                    = merge(local.env.tags, { backup-plan = "default" })
  cluster_name            = dependency.eks.outputs.name
  node_role_arn           = dependency.role.outputs.arn
  subnet_ids              = [dependency.vpc.outputs.private_subnet_ids[0]]
  launch_template_id      = dependency.launch_template.outputs.id
  launch_template_version = dependency.launch_template.outputs.latest_version
  desired_size            = local.env.aws.eks.node-groups[0].desired-size
  max_size                = local.env.aws.eks.node-groups[0].max-size
  min_size                = local.env.aws.eks.node-groups[0].min-size
}
