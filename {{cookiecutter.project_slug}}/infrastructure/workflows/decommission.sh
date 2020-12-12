#!/usr/bin/env bash

INFRA_PATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"/../

if test $1
then
echo -e "Decommissioning $1 environment"

# cd to environment folder
if [ -d "$INFRA_PATH/$1/services/gcp_project" ];
then
# cd to environment folder
cd $INFRA_PATH/$1/services/gcp_project
# remove project
terraform destroy
else
echo -e "Environment folder $1 not found"
exit 1
fi
else
echo -e "Usage $0 <prod|qa>"
exit 1
fi
