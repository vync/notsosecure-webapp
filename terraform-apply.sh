#!/usr/bin/env bash
set -euo pipefail

terraform init

#here it is assumed that Jenkins is run on an EC2 instance, ECS task of EKS pod and therefore credentials for the associated are injected as environment variables or leased from the EC2 instance metadata service.
terraform apply
