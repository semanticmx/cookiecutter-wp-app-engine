# {{cookiecutter.project_name}}

This project uses GCP App Engine to deploy WordPress inside src/{{cookiecutter.project-slug}}-installation.

The contents under src/{{{{cookiecutter.theme-slug}}}} will also be deployed as part of wp-content/themes/

## Pre-requisites

- Create {{cookiecutter.project_name}}-{{cookiecutter.environment}} project in the Cloud Console.
- Install the [Cloud SDK].
- Enable the [Cloud SQL API].
- Install [Composer].

[cloud sdk]: <https://cloud.google.com/sdk>
[cloud sql api]: <https://console.cloud.google.com/flows/enableapi?apiid=sqladmin>
[composer]: <https://getcomposer.org/>
