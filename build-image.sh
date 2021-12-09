#!/usr/bin/env bash
set -euo pipefail

cd build
docker build -t notsosecure-webserver .
