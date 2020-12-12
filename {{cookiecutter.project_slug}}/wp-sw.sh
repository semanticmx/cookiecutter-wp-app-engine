#!/usr/bin/env bash

ROOT_PATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

function createproject {
  echo -e "Creating project..."
  bash $ROOT_PATH/infrastructure/workflows/deploy.sh $2
  echo -e ""
  echo -e "Before continuing please enable Cloud SQL Admin API"
  echo -e "and App Engine Admin API"
  echo -e "https://console.cloud.google.com/apis/library?project={{ cookiecutter.project_slug }}-id&supportedpurview=project"
}

function createremotedb {
  echo -e "Creating remote database..."
  bash $ROOT_PATH/infrastructure/workflows/add-mysql.sh $2
  echo -e ""
  echo -e "Please setup a billing account"
  echo -e "https://console.cloud.google.com/sql/instances?folder=&project={{ cookiecutter.project_slug }}-id&supportedpurview=project"
}

function decommission {
  echo -e "Decommissioning infra..."
  bash $ROOT_PATH/infrastructure/workflows/decommission.sh $2
}

function install {
  echo -e "Configuring WordPress..."
  bash $ROOT_PATH/infrastructure/workflows/install.sh
}

function redeploy {
  echo -e "Publishing WordPress..."
  bash $ROOT_PATH/infrastructure/workflows/re-deploy.sh
}

function updatewp {
  echo -e "Updating WordPress components..."
  bash $ROOT_PATH/infrastructure/workflows/update-wp.sh
}

function initdb {
  gcloud config set project {{ cookiecutter.project_slug }}-id
  gcloud sql instances patch {{ cookiecutter.project_slug }} --activation-policy ALWAYS
}

function haltdb {
  gcloud config set project {{ cookiecutter.project_slug }}-id
  gcloud sql instances patch {{ cookiecutter.project_slug }} --activation-policy NEVER
}

function localdb {
  cloud_sql_proxy -instances {{ cookiecutter.project_slug}}-id:us-central1:{{ cookiecutter.project_slug}}=tcp:3306 &
}

function dbconnect {
  mysql --host=127.0.0.1 -u {{ cookiecutter.db_user}} -p{{ cookiecutter.db_pwd }} {{ cookiecutter.project_slug }}-db
}

if test $1
then

case $1 in
deploy)
  if [ -d "$ROOT_PATH/infrastructure/$2/services" ];
  then
    deploy $1 $2
  else
    echo -e "Please specify the environment you want to deploy: {{ cookiecutter.environment }} or prod"
    exit 1
  fi
  ;;
decommission)
  if [ -d "$ROOT_PATH/infrastructure/$2/services" ];
  then
    decommission $1 $2
  else
    echo -e "Please specify the environment you want to decommisse: {{ cookiecutter.environment }} or prod"
    exit 1
  fi
  ;;
create-project)
  if [ -d "$ROOT_PATH/infrastructure/$2/services" ];
  then
    createproject $1 $2
  else
    echo -e "Please specify the environment you want to deploy: {{ cookiecutter.environment }} or prod"
    exit 1
  fi
  ;;
create-remote-db)
  if [ -d "$ROOT_PATH/infrastructure/$2/services" ];
  then
    createremotedb $1 $2
  else
    echo -e "Please specify the environment you want to decommisse: {{ cookiecutter.environment }} or prod"
    exit 1
  fi
  ;;
login)
  gcloud auth application-default login
  ;;
install)
  install
  ;;
re-deploy)
  redeploy
  ;;
update-wp)
  updatewp
  ;;
init-db)
  initdb
  ;;
halt-db)
  haltdb
  ;;
local-db)
  if test cloud_sql_proxy
  then
    localdb
  else
    echo -e "Please install Cloud SQL Proxy before using this command."
    exit 1
  fi
  ;;
db-connect)
  dbconnect
  ;;
*)
  Message="Invalid argument."
  ;;
esac

else
echo -e "Usage $0 <command>"
echo -e "    available commands:"
echo -e "======= Infrastructure ======="
echo -e "    login:                 Login to Google"
echo -e "    create-project <ENV>:  Deploys infrastructure to Google Cloud Platform"
echo -e "    create-remote-db <ENV>:Deploys database to Google Cloud Platform"
echo -e "====== Local Development ======"
echo -e "    install:               Installs WordPress locally"
echo -e "    local-db:              Starts Cloud SQL Proxy daemon"
echo -e "    db-connect:            Connects to local database"
echo -e "    update-wp:             Updates local version of WordPress including plugins and themes"
echo -e "    re-deploy:             Re-deploys local WordPress installation"
echo -e "====== Database Management ======"
echo -e "    init-db:               Starts Cloud SQL database"
echo -e "    halt-db:               Stops Cloud SQL database"
echo -e "====== Destroy Environment ======"
echo -e "    decommission <ENV>:    Removes infrastructure from Google Cloud Platform"
exit 1
fi
