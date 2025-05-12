locals {
  global      = yamldecode(file(find_in_parent_folders("global.yaml")))
  env         = yamldecode(file(find_in_parent_folders("env.yaml")))
  cluster_dns = cidrhost(local.env.aws.eks.cluster.service-ipv4-cidr, 10) # 10 is always the index of the DNS service
}

include "root" {
  path = find_in_parent_folders()
}

terraform {
  # FIXME
  source = "/Users/frederic/Documents/_work/119_hoverkraft-tech/src/terraform-modules//aws/launch-template"
}

dependency "cluster" {
  config_path = "../../controlplane"
  mock_outputs = {
    security_group_id = "sg-1234567890"
  }
}

dependency "sg" {
  config_path = "../../nodegroups/base/securitygroup"
  mock_outputs = {
    id = "sg-mock"
  }
}

dependency "ssh-key" {
  config_path = "../../../ssh-keys/base"
  skip_outputs = true
  mock_outputs = {}
}

inputs = {
  name              = "base-node-${local.env.aws.eks.node-groups[0].availability-zones[0]}"
  customer          = local.env.customer.name
  environment       = local.env.name
  tags              = merge(local.env.tags, { backup-plan = "default" })
  availability_zone = local.env.aws.eks.node-groups[0].availability-zones[0]
  root_volume_size  = local.env.aws.eks.node-groups[0].root-volume.size
  root_volume_type  = local.env.aws.eks.node-groups[0].root-volume.type
  ami_id            = local.env.aws.eks.node-groups[0].ami-id
  instance_type     = local.env.aws.eks.node-groups[0].instance-type
  key_name          = "${local.env.name}@${local.env.customer.domain}"
  security_groups_ids = [
    dependency.cluster.outputs.security_group_id,
    dependency.sg.outputs.id
  ]
  user_data = base64encode(templatefile("./user-data.sh", {
    bootstrap_extra_args = "--dns-cluster-ip ${local.cluster_dns} --use-max-pods false"
    kubelet_extra_args   = "'--max-pods=110'"
  }))
}
