# Setup Environment

For convenience most of the configuration values we need to create and
manage our Lamp Managed Application we'll create a numer of
Environment Variables. In order to store any generated files and
configurations we will also create a workspace.

NOTE: If you are running these scripts through SimDem you can
customize these values by copying and editing `env.json` into
`env.local.json`.

## Setup for Publishing the Lamp Managed Application

``` bash
Lamp_MANAGED_APP_OWNER_GROUP_NAME=LampOwner
Lamp_MANAGED_APP_OWNER_NICKNAME=LampOwner
Lamp_SERVICE_CATALOG_LOCATION=southcentralus
Lamp_SERVICE_CATALOG_RG_NAME=LampManagedAppServiceCatalogRG
Lamp_MANAGED_APP_NAME=LampManagedApp
Lamp_MANAGED_APP_LOCK_LEVEL=ReadOnly
Lamp_MANAGED_APP_DISPLAY_NAME=Lamp
Lamp_MANAGED_APP_DESCRIPTION="Lamp on Azure as a Managed Application"
```

## Setup for Consuming the Lamp Managed Application

Create an id for the resource group that will be managed by the
managed application provider. This is the resource group that
infrastructure will be deployed into. The end user does not,
generally, manage this group.

``` bash
SUBSCRIPTION_ID=$(az account show --query id --output tsv)
Lamp_MANAGED_RG_ID=/subscriptions/$SUBSCRIPTION_ID/resourceGroups/LampInfrastructure
```

We'll also need a resource group for the application deployment. This is the
resource group into which the application is deployed. This is the resource group that
the provider of the managed application will have access to.

``` bash
Lamp_DEPLOYMENT_RG_NAME=LampManagedAppRG
Lamp_DEPLOYMENT_LOCATION=southcentralus
Lamp_DEPLOYMENT_NAME=LampManagedApp
```

## Workspace

We need a workspace for storing configuration files and other
per-deployment artifacts:

``` shell
Lamp_MANAGED_APP_WORKSPACE=~/.Lamp
mkdir -p $Lamp_MANAGED_APP_WORKSPACE/$Lamp_DEPLOYMENT_NAME
```

## SSH Key

We use SSH for secure communication with our hosts. The following line
will check there is a valid SSH key available and, if not, create one.

```
Lamp_SSH_KEY_FILENAME=~/.ssh/Lamp_managedapp_id_rsa
if [ ! -f "$Lamp_SSH_KEY_FILENAME" ]; then ssh-keygen -t rsa -N "" -f $Lamp_SSH_KEY_FILENAME; fi
```
