#!/bin/bash

set -u
set -x

BACKUP_DIR="${1:-/tmp/tgstates}"
WORKDIR=$(realpath . | xargs -L 1 basename)
TARGET_DIR="${BACKUP_DIR}/${WORKDIR}"

echo "+   finding terragrunt modules"
find ./* -type f -name "terragrunt.hcl" -mindepth 1 | grep -v -E '.terragrunt-cache' | while read -r tgfile; do
  echo "+++ Found $tgfile"
  dir=$(dirname "$tgfile")
  echo "++  Restoring $dir"
  if [ -d "${TARGET_DIR}/${dir}" ]; then
    cd "$dir"
    STATE="$(realpath "${TARGET_DIR}/${dir}/state.json")"
    if [ -f "${STATE}" ]; then
      terragrunt run-all \
        --terragrunt-parallelism 1 \
        --terragrunt-ignore-dependency-errors \
        --terragrunt-non-interactive \
        state push \
        "${STATE}"
    fi
  else
    echo "++  No state found for $dir"
  fi
  cd -
done
