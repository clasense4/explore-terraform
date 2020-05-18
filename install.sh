#!/usr/bin/env bash

set -o nounset
set -o errexit
set -o errtrace
set -o pipefail

cd application
terraform init
cd ..

cd network
terraform init
cd ..

cd test
terraform init
cd ..