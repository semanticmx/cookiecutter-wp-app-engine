#!/usr/bin/env bash

ROOT_PATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"/../../

if [ -d "$ROOT_PATH"/src/{{ cookiecutter.project_slug }}-installation ]
then
cd $ROOT_PATH
cp -fa "$ROOT_PATH"/etc/docker-compose/stack.yaml "$ROOT_PATH"/src/{{ cookiecutter.project_slug }}-installation
cd "$ROOT_PATH"/src/{{ cookiecutter.project_slug }}-installation
echo -e ""
echo -e "Launching server at http://localhost:{{ cookiecutter.port }}"
echo -e ""
docker-compose up
else
fi
