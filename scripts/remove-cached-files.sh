#!/bin/bash

set -eu -o pipefail

find . -type d -name ".terragrunt-cache" -prune -exec rm -rf {} \;
find . -type d -name ".terraform" -prune -exec rm -rf {} \;
