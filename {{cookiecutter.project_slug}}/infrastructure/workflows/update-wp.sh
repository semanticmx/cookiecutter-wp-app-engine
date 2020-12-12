#!/usr/bin/env bash

if test cloud_sql_proxy
  then
else
  echo -e "Please install cloud_sql_proxy before using this command"
  exit 1
fi

ROOT_PATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"/../../
WP_ROOT_PATH="$ROOT_PATH"/src/{{cookiecutter.project_slug}}-installation

# Install the wp-cli utility
cd $WP_ROOT_PATH
export WP_CLI_PHP_ARGS='-d include_path=vendor/google/appengine-php-sdk'
composer require wp-cli/wp-cli-bundle
# Update Wordpress itself
vendor/bin/wp core update $WP_ROOT_PATH
# Update all the plugins and themes
vendor/bin/wp plugin update --all
vendor/bin/wp theme update --all
