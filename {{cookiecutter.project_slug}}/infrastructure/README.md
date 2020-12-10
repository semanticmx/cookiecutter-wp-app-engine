## IaC

Infrastructure as code for {{ cookiecutter.project_name }} using CGP

# Requirements

You need to know the GCP organization ID where this infrastructure will be deployed.

ie

```sh
gcloud projects describe <PROJECT_ID>
```

You also need to login using an authorized GCP account

```sh
gcloud auth application-default login
```

# Installation

Install the required terraform resources.

ie. deploy staging

```sh
cd stage/services/gcp_project
terraform init
terraform plan -out gcp_project.plan
terraform apply gcp_project.plan
```

# Uninstall

To remove resources run the destroy command

```sh
cd stage/services/gcp_project
terraform init
terraform plan -out gcp_project.plan
terraform destroy
```
