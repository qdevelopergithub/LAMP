
# Deploy and Manage a Scalable LAMP Cluster on Azure

This repo contains guides and [Azure Resource Manager](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-overview) templates designed to help you deploy and manage a highly available and scalable
[LAMP](https://en.wikipedia.org/wiki/LAMP_(software_bundle)) cluster on Azure. Please note that this work is a derivative of the [Lamp on Azure project](https://github.com/Azure/Lamp/tree/master) and as such may contain references to Lamp (a specific LAMP application) in either the documentation or the scripts provided here. This project is currently a work in progress and will be continuously updated. Finally, the template(s) provided here deploy an *empty* infrastructure/stack to deploy any general LAMP application.   

If you have Azure account you can deploy LAMP via the [Azure portal](https://portal.azure.com) using the button below. Please note that while you can use an [Azure free account](https://azure.microsoft.com/en-us/free/) to get started depending on which template configuration you choose you will likely be required to upgrade to a paid account. 

## Fully configurable deployment

The following button will allow you to specify various configurations for your LAMP cluster
deployment. The number of configuration options might be overwhelming, so some pre-defined/restricted deployment options for
typical LAMP scenarios follow this.

[![Deploy to Azure Fully Configurable](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fqdevelopergithub%2FLAMP%2Fmaster%2Fazuredeploy-large-ha.json)  [![Visualize](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/visualizebutton.png)](http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2Fqdevelopergithub%2FLAMP%2Fmaster%2Fazuredeploy-large-ha.json)

NOTE:  All of the deployment options require you to provide a valid SSH protocol 2 (SSH-2) RSA public-private key pairs with a minimum length of 2048 bits. Other key formats such as ED25519 and ECDSA are not supported. If you are unfamiliar with SSH then you should read this [article](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/mac-create-ssh-keys) which will explain how to generate a key using the Windows Subsystem for Linux (it's easy and takes only a few minutes).  If you are new to SSH, remember SSH is a key pair solution. What this means is you have a public key and a private key, and the one you will be using to deploy your template is the public key.

## Predefined deployment options
Below is a HA (High Availibility) pre-defined/restricted deployment option based on typical deployment scenarios (i.e. dev/test, production etc.) All configurations are fixed and you just need to pass your ssh public key to the template for logging in to the deployed VMs. Please note that the actual cost will be bigger with potentially autoscaled VMs, backups and network cost.

| Deployment Type | Description | Estimated Cost | Launch |
| --- | --- | --- | ---
|Large size deployment (with high availability)| Supporting more than 2000 concurrent users. This deployment will use Gluster (for high availability, requiring 2 VMs), MySQL (16 vCores) and redis cache, without other options like elastic search. |[link](https://azure.com/e/078f7294ab6544e8911ddc2ee28850d7)|[![Deploy to Azure Minimally](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fqdevelopergithub%2FLAMP%2Fmaster%2Fazuredeploy-large-ha.json)

NOTE: Depending on the region you choose to deploy the stack in - the deployment might fail due to SKUs being hardcoded in the template where they are not available. For example, today our small-mid-size deployment option hard codes Gen-4 Azure MySQL SKUs into the template, and if a region where that is currently not available in (i.e. westus2) is used, your deployment will fail.  If your deployment fails, please revert to the fully configurable template where possible and change the SKU paramater to one that exists in your region (i.e. Gen-5) or alternatively change your deployment region to one in which the SKU is available (i.e. southcentralus).     

## Stack Architecture

- 1 Storage account (Details of user account, subscription etc.)
An Azure Storage Account contains all of your Azure Storage data objects: blobs, files, queues, 	tables, and disks. Data in your Azure storage account is durable and highly available, secure, 	massively scalable, and accessible from anywhere in the world over HTTP or HTTPS.
- 1 Controller for Network Security Group
You can filter network traffic to and from Azure resources in an Azure virtual network with a network security group. A network security group contains security rules that allow or deny inbound network traffic to, or outbound network traffic from, several types of Azure resources. 
- 1 Controller for managing public IP addresses/all IP addresses
You can assign IP addresses to Azure resources to communicate with other Azure resources, 	your on-premises network, and the Internet. There are two types of IP addresses you can use in 	Azure:
Public IP addresses: Used for communication with the Internet, including Azure public-facing 	services.
Private IP addresses: Used for communication within an Azure virtual network (VNet), and your 	on-premises network, when you use a VPN gateway or ExpressRoute circuit to extend your 	network to Azure.

- 1 Virtual disk for Controller
 	This is a virtual disk which will be used for Controller VM to store all its data.

- 1 VM for Controller 
This is a virtual machine created for controller with ubuntu server os intalled on it.

- 1 NIC for Controller 
It will link Virtual disk and VM and other components with each other.

- 1 MySQL database resource
Managed MySQL database used by the PHP applications.

- 2 Virtual disks for Cluster(Gluster FS with 4 disk per Gluster)
 It will use for load balance and hence there will be high availability.

- 2 NIC(Network interface cards) for Gluster file server

- 2 VM (Virtual machine) will make for Gluster Fileserver

- 1 security group resource to manage all the file security and authorized access control

- 1 Virtual Network Resource which will link all resources with each other

- 1 Load Balancer for Cluster( Gluster File server for load balancing) for HA(High availability)

- 1 IP address resource for load balancer

- 1 resource for Redis Cache
Managed instance of the Redis key-value storage. Your PHP applications can connect to this to store sessions and other transient data. Redis store data in-memory, so it’s very fast. Azure Cache for Redis is a distributed, managed cache that helps you build highly scalable and responsive applications by providing super-fast access to your data.

- 1 VM resource for scale set

- 1 Storage Account for VM scale set
When you create a scale set in the portal, a load balancer is created. Network Address 	Translation (NAT) rules are used to distribute traffic to the scale set instances for remote 	connectivity such as RDP or SSH.

With scale sets, all VM instances are created from the same base OS image and configuration. This approach lets you easily manage hundreds of VMs without additional configuration tasks or network management. When you have many VMs that run your application, it's important to maintain a consistent configuration across your environment. For reliable performance of your application, the VM size, disk configuration, and application installs should match across all VMs. 

#### NOTE: - 
There is no additional cost to scale sets. You only pay for the underlying compute resources such as the VM instances, load balancer, or Managed Disk storage.


This template set deploys the following infrastructure core to your LAMP instance:
- Autoscaling web frontend layer (Nginx for https termination, Varnish for caching, Apache/php or nginx/php-fpm)
- Private virtual network for frontend instances
- Controller instance running cron and handling syslog for the autoscaled site
- [Azure Load balancer](https://azure.microsoft.com/en-us/services/load-balancer/) to balance across the autoscaled instances
- [Azure Database for MySQL](https://azure.microsoft.com/en-us/services/mysql/) or [Azure Database for PostgreSQL](https://azure.microsoft.com/en-us/services/postgresql/) or [Azure SQL Database](https://azure.microsoft.com/en-us/services/sql-database/) 
- Dual [GlusterFS](https://www.gluster.org/) nodes or NFS for high availability access to LAMP files

## Next Steps

# Prepare deployed cluster for LAMP applications

If you chose Apache as your `webServerType` and `true` for the `htmlLocalCopy` switch at your LAMP cluster deployment time, you can install additional LAMP sites on your  cluster, utilizing Apache's VirtualHost feature (we call this "LAMP generalization"). To manage your installed cluster, you'll first need to login to the LAMP cluster controller virtual machine. The directory you'll need to work out of is `/azlamp`. You will need privileged access which means that you'll either need to be root (superuser) or have *sudo* access. 


## Configuring the controller for a specific LAMP application (WordPress)


### Installation Destination
An example LAMP application (WordPress) is illustrated here for the sake of clarity. The approach is similar to any LAMP application out there. 

Download a latest version of Wordpress. Once that's done and you've downloaded the latest version of WordPress, please follow the instructions here to complete configuring a database and finishing a [WordPress install](https://codex.wordpress.org/Installing_WordPress#Famous_5-Minute_Installation). 

Below is a Full script which will run and install WordPress on the cluster. 

```
wget -c http://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz
sudo mkdir -p /var/www/html/
sudo rsync -av wordpress/* /var/www/html/
sudo chown -R www-data:www-data /var/www/html/
sudo chmod -R 755 /var/www/html/

```

## Configuring the controller for a specific LAMP application (Drupal)

Download a latest version of Drupal. Once that's done and you've downloaded the latest version of Drupal, please follow the instructions here to complete configuring a database and finishing a [Drupal install](https://www.drupal.org/documentation/install/developers). 

Below is a Full script which will run and install Drupal on the cluster.

```
wget -c https://ftp.drupal.org/files/projects/drupal-7.2.tar.gz
tar -xzvf drupal-7.2.tar.gz
sudo mkdir -p /var/www/html/
sudo rsync -av drupal-7.2/* /var/www/html/
sudo chown -R www-data:www-data /var/www/html/
sudo chmod -R 755 /var/www/html/

```
## Configuring the controller for a specific LAMP application (Joomla)

Download a latest version of Joomla. Once that's done and you've downloaded the latest version of Joomla, please follow the instructions here to complete configuring a database and finishing a [Joomla install](https://docs.joomla.org/Installing_Joomla_on_Debian_Linux). 

Below is a Full script which will run and install Joomla on the cluster.

```
Wget https://downloads.joomla.org/cms/joomla3/3-9-1/joomla_3-9-1-stable-full_package-zip?format=zip
sudo apt-get install unzip
sudo mkdir -p /var/www/html/
sudo unzip Joomla*.zip -d /var/www/html/joomla
sudo chown -R www-data:www-data /var/www/html/
sudo chmod -R 755 /var/www/html/

```

### Update Apache configurations on all web frontend instances

Once the correspnding html/data/certs directories are configured, we need to reconfigure all Apache services on web frontend instances, so that newly created sites are added to the Apache VirtualHost configurations and deleted sites are removed from them as well. This is done by the `/azlamp/bin/update-vmss-config` hook (executed every minute on each and every VMSS instance using a cron job), which requires us to provide the commands to run (to reconfigure Apache service) on each VMSS instance. There's already a utility script installed for that, so it's easy to achieve as follows.

On the controller machine, look up the file `/azlamp/bin/update-vmss-config`. If you haven't modified that file, you'll see the following lines in the file:

```
        #1)
        #    . /azlamp/bin/utils.sh
        #    reset_all_sites_on_vmss true VMSS apache
        #;;
```

Remove all the leading `#` characters from these lines (uncommenting) and save the file, then wait for a minute. After that, your newly added sites should be available through the domain names specified/used as the directory names (Of course this assumes you set up your DNS records for your new site FQDNs so that their CNAME records point to the deployed Lamp cluster's load balancer DNS name, whis is of the form `lb-xyz123.an_azure_region.cloudapp.azure.com`).

If you are adding sites for the second or later time, you'll already have the above lines commented out. Just create another `case` block, copying the 4 lines, but make sure to change the number so that it's one greater than the last VMSS config version number (you should be able to find that from the script). As an example, the final text would look like:

```
        1)
            . /azlamp/bin/utils.sh
            reset_all_sites_on_vmss true VMSS apache
        ;;
        2)
            . /azlamp/bin/utils.sh
            reset_all_sites_on_vmss true VMSS apache
        ;;
```


The last step is to let the `/azlamp/html` directory sync with `/var/www/html` in every VMSS instance. This should be done by running `/usr/local/bin/update_last_modified_time.azlamp.sh` script on the controller machine as root. Once this is run and after a minute, the `/var/www/html` directory on every VMSS instance should be the same as `/azlamp/html`, and the newly added sites should be available.

At this point, your LAMP application is setup to use in the LAMP cluster. If you'd like to install a separate LAMP application (WordPress or otherwise), you'll have to repeat the process listed here with a new domain for the new application.



##Azure deployment Steps
Step 1: Go to the Azure Portal https://portal.azure.com. Login into the Portal with your credentials.
Step 2: Visit the URL https://github.com/qdevelopergithub/lamp. 
Step 3: Scroll down the page and click on the “Deploy to Azure” button as highlighted below:
	
Step 4: Clicking the button will take you to the Azure Portal page as below:


Step 5: In above page, fill:
i.Subscription : The subscription you want to use(if you have more than one)
ii.Resource group: Create a new Resource group. Resource groups are logical grouping units for all related Azure resources.
iii.Location: Please select a location from drop down, where you want your VM deployed.
iv._artifacts Location: This field is automatically filled.
v. _artifacts Location SAS Token: This token is automatically generated when the template is deployed.
vi.SSH public key: This key is required to access the VM. Below are the steps to generate this key:
Steps to generate SSH key on Windows
1.Download the PuTTY software. It can be downloaded from here: https://www.putty.org/
2.Run the PuTTYGen program from your system.
3.Click the “Generate” button on the window as shown below. Move the mouse randomly as highlighted(to generate same entropy).


4.After key is generated. Click the button “Save public key” and save it on your system.
5.Provide the passphrase to encrypt the private key on disk.

6.Lastly, click “Save private key” button and save the file on your machine.
Step 6: Copy the SSH key from the public key file and paste it in the SSH field in Azure Portal.
Step 7: Click the “Purchase” button on the Azure Portal page. It will deploy the VM cluster.








 
Steps to access VM on Windows
Step 1: Open the PuTTY software which was installed on your machine.
Step 2: Enter the host name. You will get the hostname after deployment is completed on azure portal.

Step 3: Click Connection=> SSH=> Auth. Load the private key file which was saved earlier.

Step 4: Click on the “Open” button and this will open the SSH connection to VM.
Cluster maintenance
Resources: Below is the list of resources deployed on the cluster:

1)1 Storage account (Details of user account, subscription etc.)
An Azure Storage Account contains all of your Azure Storage data objects: blobs, files, queues, 	tables, and disks. Data in your Azure storage account is durable and highly available, secure, 	massively scalable, and accessible from anywhere in the world over HTTP or HTTPS.
2)1 Controller for Network Security Group
You can filter network traffic to and from Azure resources in an Azure virtual network with a network security group. A network security group contains security rules that allow or deny inbound network traffic to, or outbound network traffic from, several types of Azure resources. 
3)1 Controller for managing public IP addresses/all IP addresses
You can assign IP addresses to Azure resources to communicate with other Azure resources, 	your on-premises network, and the Internet. There are two types of IP addresses you can use in 	Azure:
Public IP addresses: Used for communication with the Internet, including Azure public-facing 	services.
Private IP addresses: Used for communication within an Azure virtual network (VNet), and your 	on-premises network, when you use a VPN gateway or ExpressRoute circuit to extend your 	network to Azure.

4)1 Virtual disk for Controller
 	This is a virtual disk which will be used for Controller VM to store all its data.

5)1 VM for Controller 
This is a virtual machine created for controller with ubuntu server os intalled on it.

6)1 NIC for Controller 
It will link Virtual disk and VM and other components with each other.

7)1 MySQL database resource
Managed MySQL database used by the PHP applications.

8)2 Virtual disks for Cluster(Gluster FS with 4 disk per Gluster)
 It will use for load balance and hence there will be high availability.

9)2 NIC(Network interface cards) for Gluster file server

10)2 VM (Virtual machine) will make for Gluster Fileserver

11)1 security group resource to manage all the file security and authorized access control

12)1 Virtual Network Resource which will link all resources with each other

13)1 Load Balancer for Cluster( Gluster File server for load balancing) for HA(High availability)

14)1 IP address resource for load balancer

15)1 resource for Redis Cache
Managed instance of the Redis key-value storage. Your PHP applications can connect to this to store sessions and other transient data. Redis store data in-memory, so it’s very fast. Azure Cache for Redis is a distributed, managed cache that helps you build highly scalable and responsive applications by providing super-fast access to your data.

16)1 VM resource for scale set

17)1 Storage Account for VM scale set
When you create a scale set in the portal, a load balancer is created. Network Address 	Translation (NAT) rules are used to distribute traffic to the scale set instances for remote 	connectivity such as RDP or SSH.

With scale sets, all VM instances are created from the same base OS image and configuration. This approach lets you easily manage hundreds of VMs without additional configuration tasks or network management. When you have many VMs that run your application, it's important to maintain a consistent configuration across your environment. For reliable performance of your application, the VM size, disk configuration, and application installs should match across all VMs. 

NOTE: - There is no additional cost to scale sets. You only pay for the underlying compute resources such as the VM instances, load balancer, or Managed Disk storage.

Why use of Mulitple NIC’s
Virtual machines (VMs) in Azure can have multiple virtual network interface cards (NICs) attached to them. A common scenario is to have different subnets for front-end and back-end connectivity. You can associate multiple NICs on a VM to multiple subnets, but those subnets 	must all reside in the same virtual network (vNet).

What is a cluster

A cluster is simply a group of servers. A load balancer distributes the workload between the servers in a cluster. At any point, a new web server can be added to the existing cluster to handle more requests from users accessing your application. The load balancer has a single responsibility: deciding which server from the cluster will receive a request that was intercepted.

A very simple cluster can be deployed with two basic servers (2 CPU’s, 4GB of RAM each, 1 Gigabit network). This is sufficient to have a nice file share or a place to put some nightly backups. Gluster is deployed successfully on all kinds of disks, from the lowliest 5200 RPM SATA to mightiest 1.21 Gigawatt SSD’s.



Installation: PHP app in Linux OS will be installed by using SSH. The Common PHP apps like PHP language itself, MySQL database and apache server will be installed automatically with the help of template files(JSON file) which will further call the Linux script .SH file where all the settings, Permissions, directory creation all lined up and run one by one. 

Below are the commands to manually install various apps.

Install MySQL server manually
	sudo apt install mysql-server
To check if MySQL is installed properly, open mysql on terminal with command 
	Sudo mysql -uroot
	If you set the password during installation open with -p parameter -
	mysql -uroot -p
Install apache manually
	sudo apt install apache2
	sudo service apache2 restart
Install PHP manually
	sudo apt install php
Command to install specific packages for PHP
sudo apt install php-pear php-fpm php-dev php-zip php-curl php-xmlrpc php-gd   php-mysql php-mbstring php-xml libapache2-mod-php


Open your web-browser and open link using IP address of your server. 

PHP app will be installed on Linux OS. But in our scenario everything is virtual, so the cluster is type of server which will store all the files and folders on virtual hard disk. Cluster File server will handle the entire load balancing and see which hard disk is idle or having lesser load and fetch data from that hard disk. This will ensure high availability.
The other way to install php app on Linux is login into virtual machine and run the particular commands to install any php app. The Linux users know how to install extra apps if required with the help of terminal or SSH.


Deploying and Accessing VM on macOS/Linux
Below are the steps to access VM through LINUX/MAC
1.Run below command on command prompt:
ssh-keygen -t rsa
2.Running above command will ask for file name. Provide the file name.
3.After 2nd step, it will ask for passphrase to generate private key. Provide same.
4.This will generate 2 files with name provided by you. One file will have .pub extension and other file with no extension.
5.Rename the extension less file and provide extension “.pem”. This is the private key file.
6.Now open the .pub file and copy paste it on “SSH public key” parameter which is asked for at the time of deployment.
7.To connect with VM, Open the terminal and navigate to the location where you have .pem file.
8.Write following command in terminal:
chmod 600 {PrivateKeyFileName}.pem	
9.Then write the below command on terminal:
ssh -i {privatekeyname}.pem {username}@{HostnameOfVM}

This will open the VM and you can access same.

OS Patching

Anyone can access the information for OS Patching from the below link:  
	https://github.com/Azure/azure-linux-extensions/tree/master/OSPatching
Automate Linux VM OS Updates Using OS Patching Extension:
Complete information about LINUX VM OS updates can be found at the link:  https://azure.microsoft.com/en-in/blog/automate-linux-vm-os-updates-using-ospatching-extension/
Manual Linux VM OS Patching:
The command to update LINUX OS is as below which needs to be put in terminal:
sudo apt install unattended-upgrades
To configure unattended-upgrades, edit /etc/apt/apt.conf.d/50unattended-upgrades and adjust the following to fit your needs:
Unattended-Upgrade::Allowed-Origins {
        "${distro_id}:${distro_codename}";
        "${distro_id}:${distro_codename}-security";
      "${distro_id}:${distro_codename}-updates";
      "${distro_id}:${distro_codename}-proposed";
//      "${distro_id}:${distro_codename}-backports";
};
Certain packages can also be blacklisted and therefore will not be automatically updated. To blacklist a package, add it to the list:
Unattended-Upgrade::Package-Blacklist {
      "vim";
      "libc6";
      "libc6-dev";
//      "libc6-i686";
};
The double “//” serve as comments, so whatever follows "//" will not be evaluated.
To enable automatic updates, edit /etc/apt/apt.conf.d/20auto-upgrades and set the appropriate apt configuration options:
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::AutocleanInterval "7";
APT::Periodic::Unattended-Upgrade "1";
The above configuration updates the package list, downloads, and installs available upgrades every day. The local download archive is cleaned every week. On servers upgraded to newer versions of Ubuntu, depending on your responses, the file listed above may not be there. In this case, creating a new file of this name should also work.

Starting and Stopping Gluster Manually

For complete information about GlusterFS, please follow the below link:
https://gluster.readthedocs.io/en/latest/Administrator%20Guide/Start%20Stop%20Daemon/


Connect linux vm through RDP

Please enter below commands when connected through ssh in below sequence

1)sudo apt-get install xfce4
2)sudo apt-get install xrdp
3)sudo systemctl enable xrdp
4)echo xfce4-session >~/.xsession
5)sudo service xrdp restart
6)sudo passwd youradminuser (it will ask for password and set the password 								and save for future usage)

To open Azure CLI, click on the red rectangle area as shown in image then select Bash
Type "az" to use Azure CLI 2.0




Then go to Azure CLI and enter this command with your resource group name and controller vm name as see in below example

az vm open-port --resource-group lamp --name controller-vm-66tjbz --port 3389





Then click the “Download the RDP File” button as shown in image and connect.

The following example shows whether VM is listening on TCP port 3389 as expected. Please use the below command to check same:

sudo netstat -plnt | grep rdp



If not listening on port then use
sudo service xrdp restart

Below are the screenshots while connecting to VM GUI.


## Code of Conduct

This project has adopted the [Microsoft Open Source Code of
Conduct](https://opensource.microsoft.com/codeofconduct/). For more
information see the [Code of Conduct
FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or contact
[opencode@microsoft.com](mailto:opencode@microsoft.com) with any
additional questions or comments.

## Legal Notices

Microsoft and any contributors grant you a license to the Microsoft
documentation and other content in this repository under the [Creative
Commons Attribution 4.0 International Public
License](https://creativecommons.org/licenses/by/4.0/legalcode), see
the [LICENSE](LICENSE) file, and grant you a license to any code in
the repository under the [MIT
License](https://opensource.org/licenses/MIT), see the
[LICENSE-CODE](LICENSE-CODE) file.

Microsoft, Windows, Microsoft Azure and/or other Microsoft products
and services referenced in the documentation may be either trademarks
or registered trademarks of Microsoft in the United States and/or
other countries. The licenses for this project do not grant you rights
to use any Microsoft names, logos, or trademarks. Microsoft's general
trademark guidelines can be found at
http://go.microsoft.com/fwlink/?LinkID=254653.

Privacy information can be found at https://privacy.microsoft.com/en-us/

Microsoft and any contributors reserve all others rights, whether
under their respective copyrights, patents, or trademarks, whether by
implication, estoppel or otherwise.
