#!/usr/bin/env bash

ROOT_PATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"/../../

# set gcloud default project
gcloud config set project {{ cookiecutter.project_slug }}-id

cd $ROOT_PATH/src

# update theme files
cp -fa {{ cookiecutter.theme_slug }} {{ cookiecutter.project_slug }}-installation/wp-content/themes/

# deploy project 
cd $ROOT_PATH/src/{{ cookiecutter.project_slug }}-installation
gcloud app deploy app.yaml cron.yaml --promote --stop-previous-version
