#!/usr/bin/env bash

set -o nounset
set -o errexit
set -o errtrace
set -o pipefail

function main() {
    stack=${1:-}
    env=${2:-prod}

    #start available stack
    local _STACK_OPTION_NETWORK="network"
    #end of list

    if [ "${stack}" = ${_STACK_OPTION_NETWORK} ]; then
        # Select terraform network
        cd network;
        terraform workspace select ${env};
        workspace=$(terraform workspace show);

        echo "Deploying";
        echo "Stack     : ${stack}";
        echo "Env       : ${env}";
        echo "Workspace : ${workspace}";

        if [ "${env}" != ${workspace} ]; then
            echo "workspace not match or not available, exit"
            exit 1
        fi

        # echo "Continue";
        # terraform plan -var-file="vars/${env}.tfvars"
        terraform apply -var-file="vars/${env}.tfvars" -auto-approve
    else
        echo "Stack not found. Available stack : ";
        ( set -o posix ; set ) | grep _STACK_OPTION_ | awk -F= '{print "    " $2}'
    fi
}

main ${@}