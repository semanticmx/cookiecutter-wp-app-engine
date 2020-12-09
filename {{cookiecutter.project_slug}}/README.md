# {{cookiecutter.project_name}}

This project uses GCP App Engine to deploy WordPress inside src/{{cookiecutter.project_slug}}-installation.

The contents under src/{{{{cookiecutter.theme_slug}}}} will also be deployed as part of wp-content/themes/

## Pre-requisites

- Create {{cookiecutter.project_slug}}-{{cookiecutter.environment}} project in the Cloud Console.
- Install the [Cloud SDK].
- Enable the [Cloud SQL API].
- Install [Composer].

[cloud sdk]: <https://cloud.google.com/sdk>
[cloud sql api]: <https://console.cloud.google.com/flows/enableapi?apiid=sqladmin>
[composer]: <https://getcomposer.org/>

## Installation

1. Setup the database

- Create a new MySql instance

```sh
$ gcloud sql instances create {{cookiecutter.project_slug}}-{{cookiecutter.environment}}-db \
    --activation-policy=ALWAYS \
{%- if cookiecutter.environment == "qa" -%}
    --tier=db-f1-micro \
{%- elif cookiecutter.environment == "prod" -%}
    --tier=db-n1-standard-1 \
{% endif %}
    --region=us-central1
```

Please adjust tier and region accordingly.