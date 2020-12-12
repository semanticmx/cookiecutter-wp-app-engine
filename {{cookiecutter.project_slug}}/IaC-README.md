# {{ cookiecutter.project_name }}

This project uses GCP App Engine to deploy WordPress inside src/{{ cookiecutter.project_slug }}-installation.

The contents under src/{{ cookiecutter.theme_slug }} will also be deployed as part of wp-content/themes/

## Pre-requisites

The IaC project uses [terraform] to deploy and decommission resources to Google Cloud.

So you need to install it in order to run these scripts.

- Install terraform
- Create {{ cookiecutter.project_slug }} project in the Cloud Console.
- Install the [Cloud SDK].
- Enable the [Cloud SQL API].
- Install [Composer].

## Installation

1. Deploy the infrastructure to the cloud

```sh
bash infrastructure/workflows/deploy.sh qa
```

2. After successfully deploying you can now
   deploy your WordPress project to AppEngine.

```sh
bash infrastructure/workflows/install.sh
```

Next, browse to your new WordPress installation and complete the steps to configure it.

The [Google Cloud Storage plugin] will already be installed, so go to WordPress Admin and activate and configure the plugin.

It will allow you to upload media.

3. Everytime you make an update to src/{{ cookiecutter.theme_slug }} (theme folder) you need to re-deploy your environment, so just run:

```sh
bash infrastructure/workflows/re-deploy.sh
```

3. Finally, once you no longer need the project, you can automatically remove all resources by running:

```sh
bash infrastructure/workflows/decommission.sh
```

# References

Based on [Run WordPress on AppEngine Standard] guide.

[cloud sdk]: https://cloud.google.com/sdk
[cloud sql api]: https://console.cloud.google.com/flows/enableapi?apiid=sqladmin
[composer]: https://getcomposer.org/
[google cloud storage plugin]: https://wordpress.org/plugins/gcs/
[run wordpress on appengine standard]: https://cloud.google.com/community/tutorials/run-wordpress-on-appengine-standard
[terraform]: https://www.terraform.io/downloads.html
