# Terraform + GKE + Cloud SQL example

This example project demonstrates how to use [Garden](https://github.com/garden-io/garden) to spin up a GKE cluster and a Cloud SQL database via Garden's Terraform plugin.

The example was made to accompany [this guide](). And here's video a that shows the entire workflow:

[![Video](https://img.youtube.com/vi/iHyeD97GrE4/maxresdefault.jpg)](https://youtu.be/iHyeD97GrE4/T-D1KVIuvjA)

## Setup

> [See here]() for a detailed step-by-step guide.

You need to have [Garden installed](https://docs.garden.io/installation) to use this project.

### Step 1 - Install the Google Cloud SDK and authenticate

If you haven't already, follow the instructions [here](https://cloud.google.com/sdk/docs/quickstarts) to install the `gcloud` tool, and authenticate with GCP:

```sh
gcloud auth application-default login
```

### Step 2 - Set up a GCP project

Choose a project ID for the demo project and run the following (skip individual steps as appropriate):

```sh
export PROJECT_ID=<id>
# (Skip if you already have a project)
gcloud projects create $PROJECT_ID
# If you haven't already, enable billing for the project (required for the APIs below).
# You need an account ID (of the form 0X0X0X-0X0X0X-0X0X0X) to use for billing.
gcloud alpha billing projects link $PROJECT_ID --billing-account=<account ID>
# Enable the required APIs (this can sometimes take a while).
gcloud services enable compute.googleapis.com container.googleapis.com servicemanagement.googleapis.com servicenetworking.googleapis.com --project $PROJECT_ID
```

### Step 3 - Set your stack variables

Set you're own GCP project ID in the project level `garden.yml`:

```yaml
variables:
  gcp_project_id: my-gcp-project # <--- Replace this with your GCP project ID
  gcp_region: europe-west1 # <--- And optionally this...
  gcp_zone: europe-west1-b # <--- ... and this
```

### Step 4 - Initialize the cluster

Install the cluster-wide services Garden needs by running:

```sh
garden plugins kubernetes cluster-init
```

This will take a while because the cluster needs to be provisioned, and some services installed when it's ready.

### Step 5 - Deploy your services

The project has two environments configured:

* a **development** environment that uses a Postgres Helm chart for the database
* a **staging** environment where Garden provisions a Cloud SQL database

Deploy to `dev` with:

```sh
garden deploy
```

and to `staging` with:

```sh
garden deploy --env staging
```

## Cleanup

Simply delete your GCP project, and the Terraform state:

```sh
gcloud projects delete $PROJECT_ID
rm -rf .terraform terraform.tfstate
```
