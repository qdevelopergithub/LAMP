# Environment Variables

In order to configure our deployment and tools we'll set up some
environment variables to ensure consistency. If you are running these
scripts through SimDem you can customize these values by copying and
editing `env.json` into `env.local.json`.

We'll need a unique name for our Resource Group in Azure, but when
running in an automated mode it is useful to have a (mostly) unique
name for your deployment and related resources. We'll use a timestamp.
If the environmnt variable `Lamp_RG_NAME` is not set we will
create a new value using a timestamp:


``` shell
if [ -z "$Lamp_RG_NAME" ]; then Lamp_RG_NAME=Lamp_$(date +%Y-%m-%d-%H); fi
```

Other configurable values for our Azure deployment include the
location and depoloyment name. We'll standardize these, but you can
use different values if you like.

``` shell
Lamp_RG_LOCATION=southcentralus
Lamp_DEPLOYMENT_NAME=MasterDeploy
```

We also need to provide an SSH key. Later we'll generate this if it
doesn't already exist but to enable us to reuse an existing key we'll
store it's filename in an Environment Variable.

``` shell
Lamp_SSH_KEY_FILENAME=~/.ssh/Lamp_id_rsa
```

We need a workspace for storing configuration files and other
per-deployment artifacts:

``` shell
Lamp_AZURE_WORKSPACE=~/.Lamp
```

## Create Workspace

Ensure the workspace for this particular deployment exists:

```
mkdir -p $Lamp_AZURE_WORKSPACE/$Lamp_RG_NAME
```

## Validation

After working through this file there should be a number of
environment variables defined that will be used to provide a common
setup for all our Lamp on Azure work.

The resource group name defines the name of the group into which all
resources will be, or are, deployed. 

```bash
echo "Resource Group for deployment: $Lamp_RG_NAME"
```

Results:

```
Resource Group for deployment: southcentralus
```

The resource group location is:

```bash
echo "Deployment location: $Lamp_RG_LOCATION"
```

Results:

```
Deployment location: southcentralus
```

When deploying a Lamp cluster the deployment will be given a name so
that it can be identified later should it be neceessary to debug.


```bash
echo "Deployment name: $Lamp_DEPLOYMENT_NAME"
```

Results:

```
Deployment name: MasterDeploy
```

The SSH key to use can be found in a file, if necessary this will be
created as part of these scripts.

``` shell
echo "SSH key filename: $Lamp_SSH_KEY_FILENAME"
```

Results:

```
SSH key filename: ~/.ssh/Lamp_id_rsa
```

Configuration files will be written to / read from a customer directory:

``` shell
echo "Workspace directory: $Lamp_AZURE_WORKSPACE"
```

Results:

```
Workspace directory: ~/.Lamp
```

Ensure the workspace directory exists:


``` bash
if [ ! -f "$Lamp_AZURE_WORKSPACE/$Lamp_RG_NAME" ]; then echo "Workspace exists"; fi
```

Results:

```
Workspace exists
```
