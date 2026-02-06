locals {
  global        = yamldecode(file(find_in_parent_folders("global.yaml")))
  env           = yamldecode(file("env.yaml"))
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.env.aws.region}"
}
EOF
}

remote_state {
  backend = "s3"
  config = {
    bucket         = local.global.tfstates.bucket
    key            = "${local.env.name}/${path_relative_to_include()}/terraform.tfstate"
    region         = local.global.tfstates.region
    encrypt        = true
    dynamodb_table = local.global.tfstates.locks-table
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}
