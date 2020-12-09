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

Please adjust --region and --tier accordingly; you can choose from db-f1-micro which is the cheaper to db-g1-small or db-n1-standard-1.

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
cd src
composer require google/cloud-tools
```

check that the wp-gae command is available

```sh
php vendor/bin/wp-gae
```

1. Create a new WordPress project

Before creating the project, take note of the database instance region:

```sh
gcloud sql instances describe {{cookiecutter.project_slug}} | grep region
```

Additional information you will be asked for:

- Google Project ID (available from Google Cloud Console)
- Database instance ({{ cookiecutter.project_slug }})
- Database name ({{ cookiecutter.project_slug }}-db)
- Database username ({{ cookiecutter.db_user }})
- Database password ({{ cookiecutter.db_pwd }})

```sh
php vendor/bin/wp-gae create --dir {{ cookiecutter.project_slug }}-installation
```

After completing the wizard you will get an updated wp-config.php file for your Google App Engine configuration.

1. Migrating an existing WordPress project

Copy your existing WordPress project to the installation directory and run wp-gae

```sh
pwd  # check your path is at src/ directory
cp path/to/your/wp/project {{ cookiecutter.project_slug }}-installation
php vendor/bin/wp-gae update .
```

1. Add your custom theme to the WordPress installation folder

```sh
cp -fa {{ cookiecutter.theme_slug }} {{ cookiecutter.project_slug }}-installation/wp-content/themes/
```

1. Once everything is in place, deploy your project

```sh
cd {{ cookiecutter.project_slug }}-installation
gcloud app deploy app.yaml cron.yaml --promote --stop-previous-version
```

1. After successfully deploying WordPress to App Engine, complete the WordPress installation. 

The [Google Cloud Storage plugin] will already be installed, so go to WordPress Admin and activate and configure the plugin.

It will allow you to upload media.

# References

Based on [Run WordPress on AppEngine Standard] guide.

[cloud sdk]: <https://cloud.google.com/sdk>
[cloud sql api]: <https://console.cloud.google.com/flows/enableapi?apiid=sqladmin>
[composer]: <https://getcomposer.org/>
[Google Cloud Storage plugin]: <https://wordpress.org/plugins/gcs/>
[Run WordPress on AppEngine Standard]: <https://cloud.google.com/community/tutorials/run-wordpress-on-appengine-standard>
