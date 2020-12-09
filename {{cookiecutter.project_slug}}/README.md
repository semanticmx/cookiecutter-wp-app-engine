# {{cookiecutter.project_name}}

This project uses GCP App Engine to deploy WordPress inside src/{{cookiecutter.project_slug}}-installation.

The contents under src/{{cookiecutter.theme_slug}} will also be deployed as part of wp-content/themes/

## Pre-requisites

- Create {{cookiecutter.project_slug}}-{{cookiecutter.environment}} project in the Cloud Console.
- Install the [Cloud SDK].
- Enable the [Cloud SQL API].
- Install [Composer].

## Installation

1. Setup the database

```sh
gcloud sql instances create {{cookiecutter.project_slug}} \
    --activation-policy=ALWAYS \
{%- if cookiecutter.environment == "qa" -%}

    --tier=db-f1-micro \
{%- elif cookiecutter.environment == "prod" -%}

    --tier=db-n1-standard-1 \
{% endif %}
    --region=us-central1
```

Please adjust tier and region accordingly.

Now let's create the database for this instance

```sh
gcloud sql databases create {{cookiecutter.project_slug}}-db --instance {{cookiecutter.project_slug}}
```

And set a password for your instance

```sh
gcloud sql users set-password {{cookiecutter.db_user}} \
    --host=% \
    --instance {{cookiecutter.project_slug}} \
    --password={{cookiecutter.db_pwd}} # for production use a secure password
```

1. Install WordPress GAE tools

```sh
cd src/{{ cookiecutter.project_slug }}-installation
composer require google/cloud-tools
```

check that the wp-gae command is available

```sh
php vendor/bin/wp-gae
```

1. Create a new WordPress project

```sh
php vendor/bin/wp-gae create --dir .
```

After completing the wizard you will get an updated wp-config.php file for your Google App Engine configuration.

1. Migrating an existing WordPress project

Copy your existing WordPress project to the installation directory and run wp-gae

```sh
pwd  # check your path is at src/{{ cookiecutter.project_slug }}-installation
cp path/to/your/wp/project .
php vendor/bin/wp-gae update .
```

1. Add your custom theme to the WordPress installation folder

```sh
cp ../{{ cookiecutter.theme_slug }} wp-content/themes/
```

1. Once everything is in place, deploy your project

```sh
gcloud app deploy app.yaml cron.yaml
```

1. After successfully deploy WordPress to App Engine, install the [Google Cloud Storage plugin]

It will allow you to upload media.

[cloud sdk]: <https://cloud.google.com/sdk>
[cloud sql api]: <https://console.cloud.google.com/flows/enableapi?apiid=sqladmin>
[composer]: <https://getcomposer.org/>
[Google Cloud Storage plugin]: <https://wordpress.org/plugins/gcs/>
