#!/bin/bash

set -eu -o pipefail
set -x

exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

function get_instance_id() {
    local instance=""

    instance="$(curl -sSq http://169.254.169.254/latest/meta-data/instance-id 2>/dev/null)"
    echo "$instance"
}

function get_instance_region() {
    local region=""

    region="$(curl -sSq http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r .region)"
    echo "$region"
}

function get_cluster_name() {
    local cluster_name=""

    cluster_name="$(aws ec2 describe-tags --region "$(get_instance_region)" --filters "Name=resource-id,Values=$(get_instance_id)" "Name=key,Values=eks:cluster-name" --output text | cut -f5)"
    echo "$cluster_name"
}

cluster_name="$(get_cluster_name)"

/etc/eks/bootstrap.sh \
    "$${cluster_name}" \
    %{if length(kubelet_extra_args) > 0   ~}--kubelet-extra-args ${kubelet_extra_args} \%{endif ~}
    %{if length(bootstrap_extra_args) > 0 ~}${bootstrap_extra_args}%{endif ~}

echo "completed user-data.sh successfully"
exit 0
