# {{cookiecutter.project_name}}

This project uses GCP App Engine to deploy WordPress inside src/{{cookiecutter.project_slug}}-installation.

The contents under src/{{cookiecutter.theme_slug}} will also be deployed as part of wp-content/themes/

## Pre-requisites

- Create {{cookiecutter.project_slug}} project in the Cloud Console.
- Install the [Cloud SDK].
- Enable the [Cloud SQL API].
- Install [Composer].

## Installation

0. Configure gcloud CLI to run the following commands on your newly created project

```sh
gcloud config set project {{cookiecutter.project_slug}}
```

1. Create the database

```sh
gcloud sql instances create {{cookiecutter.project_slug}} \
{%- if cookiecutter.environment == "prod" -%}
    --activation-policy=ALWAYS \
{%- else -%}
    --activation-policy=NEVER \
{% endif %}
{%- if cookiecutter.environment == "prod" -%}
    --tier=db-n1-standard-1 \
{%- else -%}
    --tier=db-f1-micro \
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

2. Create a new WordPress project

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

3. Migrating an existing WordPress project

Copy your existing WordPress project to the installation directory and run wp-gae

```sh
pwd  # check your path is at src/ directory
cp path/to/your/wp/project {{ cookiecutter.project_slug }}-installation
php vendor/bin/wp-gae update .
```

4. Add your custom theme to the WordPress installation folder

```sh
cp -fa {{ cookiecutter.theme_slug }} {{ cookiecutter.project_slug }}-installation/wp-content/themes/
```

5. Once everything is in place, deploy your project

```sh
cd {{ cookiecutter.project_slug }}-installation
gcloud app deploy app.yaml cron.yaml --promote --stop-previous-version
```

6. After successfully deploying WordPress to App Engine, complete the WordPress installation.

The [Google Cloud Storage plugin] will already be installed, so go to WordPress Admin and activate and configure the plugin.

It will allow you to upload media.

## Local development

1. Install [Cloud SQL Proxy] for your OS

2. Download JSON credentials for your project

3. Run cloud_sql_proxy on the background

```sh
cloud_sql_proxy \
    -instances=YOUR_PROJECT_ID:us-central1:{{cookiecutter.project_slug}}=tcp:{{cookiecutter.db_port}} \
    -credential_file=/path/to/YOUR_SERVICE_ACCOUNT_JSON_FILE.json &
```

4. After that, you will be able to connect to Cloud SQL database locally.

```sh
mysql -u {{ cookiecutter.db_user }} -p{{ cookiecutter.db_pwd }} {{ cookiecutter.project_slug }}
```

# References

Based on [Run WordPress on AppEngine Standard] guide.

[cloud sdk]: https://cloud.google.com/sdk
[cloud sql api]: https://console.cloud.google.com/flows/enableapi?apiid=sqladmin
[composer]: https://getcomposer.org/
[google cloud storage plugin]: https://wordpress.org/plugins/gcs/
[run wordpress on appengine standard]: https://cloud.google.com/community/tutorials/run-wordpress-on-appengine-standard
[cloud sql proxy]: https://cloud.google.com/sql/docs/mysql/quickstart-proxy-test
