#!/usr/bin/env bash

INFRA_PATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"/../

if [ -d "$INFRA_PATH/$1/data-stores" ];
then
echo -e "Creating $1 database"

# deploy database
cd $INFRA_PATH/$1/data-stores/mysql
terraform init
terraform plan -out mysql.plan
terraform apply mysql.plan

else
echo -e "Environment folder $1 not found"
exit 1
fi
