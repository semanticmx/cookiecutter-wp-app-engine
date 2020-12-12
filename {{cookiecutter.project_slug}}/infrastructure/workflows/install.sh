#!/usr/bin/env bash

ROOT_PATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"/../../

# set gcloud default project
gcloud config set project {{ cookiecutter.project_slug }}-id

cd $ROOT_PATH/src

# install google cloud tools
composer require google/cloud-tools

# check WordPress AppEngine CLI is available
php vendor/bin/wp-gae

# get configured DB region
gcloud sql instances describe {{ cookiecutter.project_slug }} | grep region

# start configuration wizard and copy theme folder
php vendor/bin/wp-gae create --dir {{ cookiecutter.project_slug }}-installation && 
cp -fa {{ cookiecutter.theme_slug }} {{ cookiecutter.project_slug }}-installation/wp-content/themes/

# deploy project 
cd $ROOT_PATH/src/{{ cookiecutter.project_slug }}-installation
gcloud app deploy app.yaml cron.yaml --promote --stop-previous-version

gsutil defacl ch -u AllUsers:R gs://{{ cookiecutter.project_slug }}-id.appspot.com
echo -e "WordPress has been deployed!"
echo -e ""
echo -e "Do not forget to enable Google Cloud Storage plugin"
echo -e ""