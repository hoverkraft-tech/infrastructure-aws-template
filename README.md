# infrastructure

<!-- markdownlint-disable MD013 -->

![GitHub Verified Creator](https://img.shields.io/badge/GitHub-Verified%20Creator-4493F8?logo=data:image/svg%2bxml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAxNiAxNiIgd2lkdGg9IjE2IiBoZWlnaHQ9IjE2IiBmaWxsPSJyZ2IoNjgsIDE0NywgMjQ4KSI%2BCiAgPHBhdGggZD0ibTkuNTg1LjUyLjkyOS42OGMuMTUzLjExMi4zMzEuMTg2LjUxOC4yMTVsMS4xMzguMTc1YTIuNjc4IDIuNjc4IDAgMCAxIDIuMjQgMi4yNGwuMTc0IDEuMTM5Yy4wMjkuMTg3LjEwMy4zNjUuMjE1LjUxOGwuNjguOTI4YTIuNjc3IDIuNjc3IDAgMCAxIDAgMy4xN2wtLjY4LjkyOGExLjE3NCAxLjE3NCAwIDAgMC0uMjE1LjUxOGwtLjE3NSAxLjEzOGEyLjY3OCAyLjY3OCAwIDAgMS0yLjI0MSAyLjI0MWwtMS4xMzguMTc1YTEuMTcgMS4xNyAwIDAgMC0uNTE4LjIxNWwtLjkyOC42OGEyLjY3NyAyLjY3NyAwIDAgMS0zLjE3IDBsLS45MjgtLjY4YTEuMTc0IDEuMTc0IDAgMCAwLS41MTgtLjIxNUwzLjgzIDE0LjQxYTIuNjc4IDIuNjc4IDAgMCAxLTIuMjQtMi4yNGwtLjE3NS0xLjEzOGExLjE3IDEuMTcgMCAwIDAtLjIxNS0uNTE4bC0uNjgtLjkyOGEyLjY3NyAyLjY3NyAwIDAgMSAwLTMuMTdsLjY4LS45MjhjLjExMi0uMTUzLjE4Ni0uMzMxLjIxNS0uNTE4bC4xNzUtMS4xNGEyLjY3OCAyLjY3OCAwIDAgMSAyLjI0LTIuMjRsMS4xMzktLjE3NWMuMTg3LS4wMjkuMzY1LS4xMDMuNTE4LS4yMTVsLjkyOC0uNjhhMi42NzcgMi42NzcgMCAwIDEgMy4xNyAwWk03LjMwMyAxLjcyOGwtLjkyNy42OGEyLjY3IDIuNjcgMCAwIDEtMS4xOC40ODlsLTEuMTM3LjE3NGExLjE3OSAxLjE3OSAwIDAgMC0uOTg3Ljk4N2wtLjE3NCAxLjEzNmEyLjY3NyAyLjY3NyAwIDAgMS0uNDg5IDEuMThsLS42OC45MjhhMS4xOCAxLjE4IDAgMCAwIDAgMS4zOTRsLjY4LjkyN2MuMjU2LjM0OC40MjQuNzUzLjQ4OSAxLjE4bC4xNzQgMS4xMzdjLjA3OC41MDkuNDc4LjkwOS45ODcuOTg3bDEuMTM2LjE3NGEyLjY3IDIuNjcgMCAwIDEgMS4xOC40ODlsLjkyOC42OGMuNDE0LjMwNS45NzkuMzA1IDEuMzk0IDBsLjkyNy0uNjhhMi42NyAyLjY3IDAgMCAxIDEuMTgtLjQ4OWwxLjEzNy0uMTc0YTEuMTggMS4xOCAwIDAgMCAuOTg3LS45ODdsLjE3NC0xLjEzNmEyLjY3IDIuNjcgMCAwIDEgLjQ4OS0xLjE4bC42OC0uOTI4YTEuMTc2IDEuMTc2IDAgMCAwIDAtMS4zOTRsLS42OC0uOTI3YTIuNjg2IDIuNjg2IDAgMCAxLS40ODktMS4xOGwtLjE3NC0xLjEzN2ExLjE3OSAxLjE3OSAwIDAgMC0uOTg3LS45ODdsLTEuMTM2LS4xNzRhMi42NzcgMi42NzcgMCAwIDEtMS4xOC0uNDg5bC0uOTI4LS42OGExLjE3NiAxLjE3NiAwIDAgMC0xLjM5NCAwWk0xMS4yOCA2Ljc4bC0zLjc1IDMuNzVhLjc1Ljc1IDAgMCAxLTEuMDYgMEw0LjcyIDguNzhhLjc1MS43NTEgMCAwIDEgLjAxOC0xLjA0Mi43NTEuNzUxIDAgMCAxIDEuMDQyLS4wMThMNyA4Ljk0bDMuMjItMy4yMmEuNzUxLjc1MSAwIDAgMSAxLjA0Mi4wMTguNzUxLjc1MSAwIDAgMSAuMDE4IDEuMDQyWiI%2BPC9wYXRoPgo8L3N2Zz4K)
<!-- markdownlint-enable MD013 -->

[![PRs welcome](https://img.shields.io/badge/PRs-welcome-brightgreen)](https://github.com/hoverkraft-tech/infrastructure-aws-template/issues)
[![GitHub Stars](https://img.shields.io/github/stars/hoverkraft-tech/infrastructure-aws-template?style=social)](https://github.com/hoverkraft-tech/infrastructure-aws-template)

Infrastructure as Code for your environment

## prerequisites

This repo uses the following dependencies :

- direnv for load env vars in `.envrc` files
- asdf for managing binary versions of the needed tools
- aws-vault (optional) to manage all aws accounts securely

You can find more details about each tool on their official websites :

- [direnv](https://direnv.net/)
- [asdf](https://asdf-vm.com)
- [aws-vault](https://github.com/99designs/aws-vault)

### asdf-vm

- install asdf
- run these commands :

```sh
asdf plugin add awscli
asdf plugin add checkov
asdf plugin add infracost
asdf plugin add terraform
asdf plugin add terraform-docs
asdf plugin add terragrunt
asdf plugin add tflint
asdf plugin add tfsec
asdf plugin add tfupdate
asdf install
```

## setup a new env

- copy one of the prod env and rename the top level folder
- remove terraform states files (`find . -type f -name '.terraform.lock.hcl' -exec rm {} \; && find . -type d -name '.terragrunt-cache' -exec rm -rf {} \;`)
- search and replace `/old/new/` in the just created folder
- create an SSH ED25519 key `ssh-keygen -t ed25519 -C '<env>@acme.net' -f <env>` and store it in password store repository
- customize the `env.yaml` file to suits your needs

## deploy an env (or partial subfolder)

```shell
cd envs/xxxxxxxxx
cd <part you want to apply> # if you want to deploy full env just skip this step
aws-vault exec <acme-env-aws-account> -- terragrunt run-all apply
```

NOTE: you can add the following arguments in order to fully automate the deployment

- `--terragrunt-non-interactive`
- `--terragrunt-ignore-external-dependencies`

## depploy apps to an env

- take the outputs you need from the step above
- see [argo-app-of-apps](../argo-app-of-apps) repository

## limitations

There is still some steps that need to be done manually

- Tags subnets for EKS usage (`kubernetes.io/role/elb=1|kubernetes.io/role/internal-elb=1` and `kubernetes.io/cluster/<LZname>=owned`)
- Create a wildcard ACM certificate for `*.<landingZone>.aws.acme.net`
- Create Wafv2 default ruleset used by ALB or Cloudfront distribution
