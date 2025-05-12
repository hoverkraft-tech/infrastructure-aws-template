locals {
  global = yamldecode(file(find_in_parent_folders("global.yaml")))
  env    = yamldecode(file(find_in_parent_folders("env.yaml")))
}

include "root" {
  path = find_in_parent_folders()
}

terraform {
  # FIXME
  source = "/Users/frederic/Documents/_work/119_hoverkraft-tech/src/terraform-modules//k8s/local-kubectl"
}

dependency "kubeconfig" {
  config_path = "../kubeconfig"
  mock_outputs_allowed_terraform_commands = ["init", "validate"]
  mock_outputs = {
    kubeconfig_path = "/tmp/kubeconfig"
  }
}

dependency "addons" {
  config_path = "../addons"
  # we just want the command to be executed after addon aws-cni is created
  # we don't need the output
  skip_outputs = true
  mock_outputs_allowed_terraform_commands = ["init", "validate"]
  mock_outputs = {}
}

inputs = {
  kubeconfig = dependency.kubeconfig.outputs.kubeconfig_path
  namespace  = "kube-system"
  commands   = ["kubectl set env daemonset aws-node ENABLE_PREFIX_DELEGATION=true"]
}
