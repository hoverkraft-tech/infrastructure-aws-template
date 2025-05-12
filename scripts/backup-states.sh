#!/bin/bash

set -eu -o pipefail
set -x

BACKUP_DIR="${1:-/tmp/tgstates}"
WORKDIR=$(realpath . | xargs -L 1 basename)
TARGET_DIR="${BACKUP_DIR}/${WORKDIR}"

echo "+   finding terragrunt modules"
find . -type f -name "terragrunt.hcl" | grep -v -E '.terragrunt-cache' | while read -r tgfile; do
  echo "+++ Found $tgfile"
  dir=$(dirname "$tgfile")
  echo "++  Backing up $dir"
  cd "$dir"
  mkdir -p "${TARGET_DIR}/${dir}"
  terragrunt run-all state pull --terragrunt-ignore-external-dependencies --terragrunt-non-interactive > "${TARGET_DIR}/${dir}/state.json"
  cd -
done
