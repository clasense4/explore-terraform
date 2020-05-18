#!/usr/bin/env bash

set -o nounset
set -o errexit
set -o errtrace
set -o pipefail

function deploy() {
    cd ${stack}
    terraform workspace select ${env};
    workspace=$(terraform workspace show);

    # Deploy
    echo "Deploying";
    echo "Stack     : ${stack}";
    echo "Env       : ${env}";
    echo "Workspace : ${workspace}";

    if [ "${env}" != ${workspace} ]; then
        echo "workspace not match or not available, exit"
        exit 1
    fi
}

function main() {
    stack=${1:-}
    env=${2:-}

    #start available stack
    local _STACK_OPTION_NETWORK="network"
    local _STACK_OPTION_APPLICATION="application"
    #end of list

    # Stack choose
    if [ "${stack}" = ${_STACK_OPTION_NETWORK} ]; then
        deploy
        # terraform plan -var-file="../vars/global.tfvars" -var-file="../vars/${stack}.tfvars"
        terraform apply -var-file="../vars/global.tfvars" -var-file="../vars/${stack}.tfvars" -auto-approve
    elif [ "${stack}" = ${_STACK_OPTION_APPLICATION} ]; then
        deploy
        terraform plan -var-file="../vars/global.tfvars"
        # terraform apply -var-file="../vars/global.tfvars" -auto-approve
    else
        echo "Stack not found. Available stack : ";
        ( set -o posix ; set ) | grep _STACK_OPTION_ | awk -F= '{print "    " $2}'
        exit 1
    fi
}

main ${@}