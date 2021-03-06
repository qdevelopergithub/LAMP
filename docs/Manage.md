# Managing a Scalable Lamp Cluster in Azure

This document provides an overview of how to perform various
management tasks on a scalable Lamp cluster on Azure.

## Prerequisites

In order to configure our deployment and tools we'll set up some
[environment variables](./Environment-Variables.md) to ensure consistency.

In order to manage a cluster it is clearly necessary to first [deploy
a scalable Lamp cluster on Azure](./Deploy.md).

For convenience and readability this document also assumes that essential [deployment details for your cluster have been assigned to environment variables](./Get-Install-Data.md).

## Updating Lamp code/settings

Your controller Virtual Machine has Lamp/LAMP code and data stored in
`/azlamp`. The site code is stored in `/azlamp/html/<yoursitename>/`. If `gluster` or
`nfs-ha` is selected for the `fileServerType` parameter at the deployment time, this
data is replicated across dual gluster or NFS-HA nodes to provide high
availability. This directory is also mounted to your autoscaled
frontends so all changes to files on the controller VM are immediately
available to all frontend machines (when the `htmlLocalCopySwitch` in `azuredeploy.json`
is false--otherwise, see below). Note that any updates on Lamp code/settings
(e.g., additional plugin installations, Lamp version upgrade) have to be done
on the controller VM using shell commands, not through a web browser, because the
HTML directory's permission is read-only for the web frontend VMs (thus any web-based
Lamp code updates will fail).

Depending on how large your Gluster/NFS disks are sized, it may be helpful
to keep multiple older versions (`/azlamp/html/site1`, `/azlamp/html-backups/site1`, etc) to
roll back if needed.

To connect to your Controller VM use SSH with a username of
`azureadmin` and the SSH provided in the `sshPublicKey` input
parameter. For example, to retrieve a listing of files and directories
in the `/azlamp` directory use:

```
ssh -o StrictHostKeyChecking=no azureadmin@$Lamp_CONTROLLER_INSTANCE_IP ls -l /azlamp
```

Results:

```
Warning: Permanently added '52.228.45.38' (ECDSA) to the list of known hosts.
total 32
drwxr-xr-x 2 root root  4096 Aug 28 18:27 bin
drwxr-xr-x 5 root root  4096 Aug  8 16:49 certs
drwxr-xr-x 5 root root  4096 Aug  8 16:52 data
drwxr-xr-x 5 root root  4096 Aug  8 16:48 html
```

**IMPORTANT NOTE**

It is important to realize that the `-o StrictHostKeyChecking=no`
option in the above SSH command presents a security risk. It is
included here to facilitate automated validation of these commands. It
is not recommended to use this option in production environments,
instead run the command manually and validate the host key.
Subsequent executions of an SSH command will not require this
validation step. For more information there is an excellent
[superuser.com
Q&A](https://superuser.com/questions/421074/ssh-the-authenticity-of-host-host-cant-be-established/421084#421084).

### If you set `htmlLocalCopySwitch` to true (this is the default now)

Originally the `/azlamp/html` directory was accessed by web server processes directly across all autoscaled
web VMs through the specified file server (Gluster or NFS), and this is
not good for web response time. Therefore, we introduced the
`htmlLocalCopySwitch` that'll copy the `/azlamp/html` directory to
`/var/www/html` in each autoscaled web VM and reconfigures the web
server (apache/nginx)'s server root directory accordingly, when it's set
to true. This now requires directory sync between `/azlamp/html` and
`/var/www/html`, and currently it's addressed by simple polling
(minutely). Therefore, if you are going to update your Lamp
code/settings with the switch set to true, please follow the
following steps:

* Put your Lamp site to maintenance mode.
  * This will need to be done on the contoller VM with some shell command.
  * It should be followed by running the following command to propagate the change to all autoscaled web VMs:
    ```bash
    $ sudo /usr/local/bin/update_last_modified_time.Lamp_on_azure.sh
    ```
  * Once this command is executed, each autoscaled web VM will pick up (sync) the changes within 1 minute, so wait for one minute.
* Then you can start updating your Lamp code/settings, like installing/updating plugins or upgrading Lamp version or changing Lamp configurations. Again, note that this should be all done on the controller VM using some shell commands.
* When you are done updating your Lamp code/settings, run the same command as above to let each autoscaled web VM pick up (sync) the changes (wait for another minute here, for the same reason).

Please do let us know on this Github repo's Issues if you encounter any problems with this process.

## Getting an SQL dump

By default a daily sql dump of your database is taken at 02:22 and
saved to `/azlamp/data/<your_Lamp_site_fqdn>/db-backup.sql.gz`. This file can be retrieved
using SCP or similar. For example:

``` bash
scp azureadmin@$Lamp_CONTROLLER_INSTANCE_IP:/azlamp/data/<your_Lamp_site_fqdn>/db-backup.sql.gz /tmp/Lamp-db-backup.sql.gz
```

To obtain a more recent SQL dump you run the commands appropriate for
your chosen database on the Controller VM. The following sections will
help with this task.

#### Postgres

Postgress provides a `pg_dump` command that can be used to take a
snapshot of the database via SSH. For example, use the following
command:

``` bash
ssh azureadmin@$Lamp_CONTROLLER_INSTANCE_IP 'pg_dump -Fc -h $Lamp_DATABASE_DNS -U $Lamp_DATABASE_ADMIN_USERNAME Lamp > /azlamp/data/<your_Lamp_site_fqdn>/db-snapshot.sql'
```

See the Postgres documentation for full details of the [`pg_dump`](https://www.postgresql.org/docs/9.5/static/backup-dump.html) command.

#### MySQL

MySQL provides a `mysql_dump` command that can be used to take a
snapshot of the database via SSH. For example, use the following
command:

``` bash
ssh azureadmin@$Lamp_CONTROLLER_INSTANCE_IP 'mysqldump -h $mysqlIP -u ${azureLampdbuser} -p'${Lampdbpass}' --databases ${Lampdbname} | gzip > /azlamp/data/<your_Lamp_site_fqdn>/db-backup.sql.gz'
```

## Backup and Recovery

If you have set the `azureBackupSwitch` in the input parameters to `1`
then Azure will provide VM backups of your Gluster node. This is
recommended as it contains both your Lamp code and your sitedata.
Restoring a backed up VM is outside the scope of this doc, but Azure's
documentation on Recovery Services can be found here:
https://docs.microsoft.com/en-us/azure/backup/backup-azure-vms-first-look-arm

## Resizing your Database

Note: This process involves site downtime and should therefore only be
carried out during a planned maintenance window.

At the time of writing Azure does not support resizing MySQL or
Postgres databases. You can, however, create a new database instance,
with a different size, and change your config to point to that. To get
a different size database you'll need to:

  1. [Place your Lamp site into maintenance
     mode](https://docs.Lamp.org/34/en/Maintenance_mode). You can do
     this either via the web interface or the command line on the
     controller VM.
  2. Perform an SQL dump of your database. See above for more details.
  3. Create a new Azure database of the size you want inside your
     existing resource group.
  4. Using the details in your `/azlamp/html/<your_Lamp_site_fqdn>/config.php` create a
     new user and database matching the details in config.php. Make
     sure to grant all rights on the db to the user.
  5. On the controller instance, change the db setting in
     `/azlamp/html/<your_Lamp_site_fqdn>/config.php` to point to the new database.
  6. Take Lamp site out of maintenance mode.
  7. Once confirmed working, delete the previous database instance.

How long this takes depends entirely on the size of your database and
the speed of your VM tier. It will always be a large enough window to
make a noticeable outage.

## Changing the SSL cert

The self-signed cert generated by the template is suitable for very
basic testing, but a public website will want a real cert. After
purchasing a trusted certificate, it can be copied to the following
files to be ready immediately:

  - `/azlamp/certs/<your_Lamp_site_fqdn>/nginx.key`: Your certificate's private key
  - `/azlamp/certs/<your_Lamp_site_fqdn>/nginx.crt`: Your combined signed certificate and trust chain certificate(s).

## Managing Azure DDoS protection

By default, every plublic IP is protected by Azure DDoS protection Basic SKU. 
You can find more information about Azure DDoS protection Basic SKU [here](https://docs.microsoft.com/en-us/azure/virtual-network/ddos-protection-overview).

If you want more protection, you can activate Azure DDoS protection Standard SKU by setting 
the ddosSwith to true. You can find how to work with Azure DDoS 
protection plan [here](https://docs.microsoft.com/en-us/azure/virtual-network/manage-ddos-protection#work-with-ddos-protection-plans).

If you want to disable the Azure DDoS protection, you can follow the instruction 
[here](https://docs.microsoft.com/en-us/azure/virtual-network/manage-ddos-protection#disable-ddos-for-a-virtual-network). 

Be careful, disabling the Azure DDoS protection on your vnet will not stop the fee.
You have to delete the Azure DDoS protection plan if you want to stop the fee.

If you have deployed your cluster without Azure DDoS protection plan, you still can activate the 
Azure DDoS protection plan thanks to the instruction [here](https://docs.microsoft.com/en-us/azure/virtual-network/manage-ddos-protection#enable-ddos-for-an-existing-virtual-network).

## Next Steps

  1. [Retrieve configuration details using CLI](./Get-Install-Data.md)
