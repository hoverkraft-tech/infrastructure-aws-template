locals {
  global     = yamldecode(file(find_in_parent_folders("global.yaml")))
  env        = yamldecode(file(find_in_parent_folders("env.yaml")))
  kubeconfig = "${get_env("BLUEPRINT_DIR")}/.secrets/${local.env.aws.eks.cluster.name}.kubeconfig"
}

include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "github.com/hoverkraft-tech/terraform-modules.git?ref=1.9.0//k8s/kubeconfig"
}

dependency "cluster" {
  config_path = "../controlplane"
  mock_outputs_allowed_terraform_commands = ["init", "validate"]
  mock_outputs = {
    name                  = "myekscluster"
    endpoint              = "https://myekscluster.eks.amazonaws.com"
    aws_region            = "eu-west-1"
    certificate_authority = "ZmFrZSBjZXJ0"
  }
}

inputs = {
  filename                        = local.kubeconfig
  # TODO: check if we can do better upstream
  content =<<_EOF
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: ${dependency.cluster.outputs.certificate_authority}
    server: ${dependency.cluster.outputs.endpoint}
  name: ${dependency.cluster.outputs.name}
contexts:
- context:
    cluster: ${dependency.cluster.outputs.name}
    user: admin
  name: ${local.env.customer.name}-${local.env.name}
current-context: "${local.env.customer.name}-${local.env.name}"
kind: Config
preferences: {}
users:
- name: admin
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1beta1
      args:
      - --region
      - ${local.env.aws.region}
      - eks
      - get-token
      - --cluster-name
      - ${dependency.cluster.outputs.name}
      command: aws
_EOF
}
