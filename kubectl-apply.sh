!#/usr/bin/env bash
set -euo pipefail
source common.sh

kubectl --kubeconfig $HOME/.kube/<path_to_eks_cluster_kubeconfig> apply -f webserver.yaml")
