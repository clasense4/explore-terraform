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
    mode=${1:-}
    stack=${2:-}
    env=${3:-}

    #start available stack
    local _STACK_OPTION_NETWORK="network"
    local _STACK_OPTION_APPLICATION="application"
    local _STACK_OPTION_TEST_EC2_PRIVATE="test/ec2_private_subnet"
    #end of list

    # Stack choose
    if [ "${stack}" = ${_STACK_OPTION_NETWORK} ]; then
        deploy
        terraform ${mode} -var-file="../vars/global.tfvars" -var-file="../vars/${stack}.tfvars"
    elif [ "${stack}" = ${_STACK_OPTION_APPLICATION} ]; then
        deploy
        terraform ${mode} -var-file="../vars/global.tfvars" -var-file="../vars/${stack}.tfvars"
    elif [ "${stack}" = ${_STACK_OPTION_TEST_EC2_PRIVATE} ]; then
        deploy
        terraform ${mode} -var-file="../../vars/global.tfvars"
    else
        echo "Stack not found. Available stack : ";
        ( set -o posix ; set ) | grep _STACK_OPTION_ | awk -F= '{print "    " $2}'
        exit 1
    fi
}

main ${@}