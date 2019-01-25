
# Deploy and Manage a Scalable LAMP Cluster on Azure

This repo contains guides and [Azure Resource Manager](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-overview) templates designed to help you deploy and manage a highly available and scalable
[LAMP](https://en.wikipedia.org/wiki/LAMP_(software_bundle)) cluster on Azure. Please note that this work is a derivative of the [Lamp on Azure project](https://github.com/Azure/Lamp/tree/master) and as such may contain references to Lamp (a specific LAMP application) in either the documentation or the scripts provided here. This project is currently a work in progress and will be continuously updated. Finally, the template(s) provided here deploy an *empty* infrastructure/stack to deploy any general LAMP application.   

If you have Azure account you can deploy LAMP via the [Azure portal](https://portal.azure.com) using the button below. Please note that while you can use an [Azure free account](https://azure.microsoft.com/en-us/free/) to get started depending on which template configuration you choose you will likely be required to upgrade to a paid account. 

## Fully configurable deployment

The following button will allow you to specify various configurations for your LAMP cluster
deployment. The number of configuration options might be overwhelming, so some pre-defined/restricted deployment options for
typical LAMP scenarios follow this.

[![Deploy to Azure Fully Configurable](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fqdevelopergithub%2FLAMP%2Fmaster%2Fazuredeploy-large-ha.json)  [![Visualize](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/visualizebutton.png)](http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2Fqdevelopergithub%2FLAMP%2Fmaster%2Fazuredeploy-large-ha.json)

## Predefined deployment options
Below is a HA (High Availibility) pre-defined/restricted deployment option based on typical deployment scenarios (i.e. dev/test, production etc.) All configurations are fixed and you just need to pass your ssh public key to the template for logging in to the deployed VMs. Please note that the actual cost will be bigger with potentially autoscaled VMs, backups and network cost.

| Deployment Type | Description | Estimated Cost | Launch |
| --- | --- | --- | ---
|Large size deployment (with high availability)| Supporting more than 2000 concurrent users. This deployment will use Gluster (for high availability, requiring 2 VMs), MySQL (16 vCores) and redis cache, without other options like elastic search. |[link](https://azure.com/e/078f7294ab6544e8911ddc2ee28850d7)|[![Deploy to Azure Minimally](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fqdevelopergithub%2FLAMP%2Fmaster%2Fazuredeploy-large-ha.json)

## Stack Architecture

[![Stack Architecture](https://github.com/qdevelopergithub/LAMP/blob/master/images/stack_diagram.png)]()

NOTE: Depending on the region you choose to deploy the stack in - the deployment might fail due to SKUs being hardcoded in the template where they are not available. For example, today our small-mid-size deployment option hard codes Gen-4 Azure MySQL SKUs into the template, and if a region where that is currently not available in (i.e. westus2) is used, your deployment will fail.  If your deployment fails, please revert to the fully configurable template where possible and change the SKU paramater to one that exists in your region (i.e. Gen-5) or alternatively change your deployment region to one in which the SKU is available (i.e. southcentralus).     

## Azure deployment Steps
Step 1: Go to the Azure Portal https://portal.azure.com. Login into the Portal with your credentials.\
Step 2: Scroll down the page and click on the “Deploy to Azure” button as highlighted below:
Step 3: Clicking the button will take you to the Azure Portal page as below:

[![Deploy to Azure Fully Configurable](https://github.com/qdevelopergithub/LAMP/blob/master/images/template.png)]()

Step 4: In above page, fill:

i. Subscription : The subscription you want to use(if you have more than one)\
ii. Resource group: Create a new Resource group. Resource groups are logical grouping units for all related Azure resources.\
iii. Location: Please select a location from drop down, where you want your VM deployed.\
iv. _artifacts Location: This field is automatically filled.\
v. _artifacts Location SAS Token: This token is automatically generated when the template is deployed.\
vi. SSH public key: This key is required to access the VM. Below are the steps to generate this key:

NOTE:  All of the deployment options require you to provide a valid SSH protocol 2 (SSH-2) RSA public-private key pairs with a minimum length of 2048 bits. Other key formats such as ED25519 and ECDSA are not supported. If you are unfamiliar with SSH then you should read this [article](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/mac-create-ssh-keys) which will explain how to generate a key using the Windows Subsystem for Linux (it's easy and takes only a few minutes).  If you are new to SSH, remember SSH is a key pair solution. What this means is you have a public key and a private key, and the one you will be using to deploy your template is the public key.

## Steps to generate SSH key on Windows

### Please follow below link to create a SSH-2 key with more advanced options
https://www.howtogeek.com/125364/how-to-ssh-hop-with-key-forwarding-from-windows/

- Download the PuTTY software. It can be downloaded from here: https://www.putty.org/
- Run the PuTTYGen program from your system.

## Steps to access VM on Windows

Step 1: Open the PuTTY software which was installed on your machine.\
Step 2: Enter the host name. You will get the hostname after deployment is completed on azure portal.

[![Putty Key Generate](https://github.com/qdevelopergithub/LAMP/blob/master/images/access_vm_ssh.png)]()

Step 3: Click Connection=> SSH=> Auth. Load the private key file which was saved earlier.

[![Putty Key Generate](https://github.com/qdevelopergithub/LAMP/blob/master/images/access_vm_ssh_key.png)]()

Step 4: Click on the “Open” button and this will open the SSH connection to VM.

Installation: PHP app in Linux OS will be installed by using SSH. The Common PHP apps like PHP language itself, MySQL database and apache server will be installed automatically with the help of template files(JSON file). All the settings, Permissions, directory creation all lined up and run one by one. 

### Important:- Please select the option ssh-2 rsa key as below 

[![Putty select ssh-2 option](https://github.com/qdevelopergithub/LAMP/blob/master/images/ssh2.png)]()

- Click the “Generate” button on the window as shown below. Move the mouse randomly as highlighted(to generate same entropy).

[![Putty Key Generate](https://github.com/qdevelopergithub/LAMP/blob/master/images/putty_key_gen.png)]()

- After key is generated. Click the button “Save public key” and save it on your system.
- Provide the passphrase to encrypt the private key on disk.

[![Putty Key Generate](https://github.com/qdevelopergithub/LAMP/blob/master/images/putty_key_gen2.png)]()

- Lastly, click “Save private key” button and save the file on your machine.
- Copy the SSH key from the public key file and paste it in the SSH field in Azure Portal.
- Click the “Purchase” button on the Azure Portal page. It will deploy the VM cluster.

NOTE:  All of the deployment options require you to provide a valid SSH protocol 2 (SSH-2) RSA public-private key pairs with a minimum length of 2048 bits. Other key formats such as ED25519 and ECDSA are not supported. If you are unfamiliar with SSH then you should read this [article](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/mac-create-ssh-keys) which will explain how to generate a key using the Windows Subsystem for Linux (it's easy and takes only a few minutes).  If you are new to SSH, remember SSH is a key pair solution. What this means is you have a public key and a private key, and the one you will be using to deploy your template is the public key.

This template set deploys the following infrastructure core to your LAMP instance:

[![Resources](https://github.com/qdevelopergithub/LAMP/blob/master/images/resources.png)]()

 ## Resources roles and explanation
 
|Resource | Role/Explanation |
|---|---
| Storage account | Details of user account, subscription etc. An Azure Storage Account contains all of your Azure Storage data objects: blobs, files, queues, tables, and disks. Data in your Azure storage account is durable and highly available, secure, 	massively scalable, and accessible from anywhere in the world over HTTP or HTTPS.
| Controller Network Security Group | You can filter network traffic to and from Azure resources in an Azure virtual network with a network security group. A network security group contains security rules that allow or deny inbound network traffic to, or outbound network traffic from, several types of Azure resources.
| Public IP Address | Controller for managing public IP addresses/all IP addresses You can assign IP addresses to Azure resources to communicate with other Azure resources, 	your on-premises network, and the Internet. Public IP addresses: Used for communication with the Internet, including Azure public-facing services. Private IP addresses: Used for communication within an Azure virtual network (VNet), and your on-premises network, when you use a VPN gateway or ExpressRoute circuit to extend your network to Azure.
| Virtual disk Controller. | This is a virtual disk which will be used for Controller VM to store all its data.
| VM Controller | This is a virtual machine created for controller with ubuntu server os intalled on it.
| NIC for Controller | It will link Virtual disk and VM and other components with each other.
| MySQL database resource. | Managed MySQL database used by the PHP applications.[Azure Database for MySQL](https://azure.microsoft.com/en-us/services/mysql/)
| Availibility Set | An Availability Set is a logical grouping capability that you can use in Azure to ensure that the VM resources you place within it are isolated from each other when they are deployed within an Azure datacenter.
| Virtual disks | For Cluster(Gluster FS with 4 disk per Gluster). It will use for load balance and hence there will be high availability.
| NIC(Network interface cards) | A network interface (NIC) is the interconnection between a VM and the underlying software network.
| VM (Virtual machine) | Will make for Gluster Fileserver - Dual [GlusterFS](https://www.gluster.org/) nodes or NFS for high availability access to LAMP files.
| Virtual Network | Azure Virtual Network enables many types of Azure resources, such as Azure Virtual Machines (VM), to securely communicate with each other, the internet, and on-premises networks. For more info follow the link [Virtual Network](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-overview)
| Load Balancer | An Azure load balancer is a Layer-4 (TCP, UDP) load balancer that provides high availability by distributing incoming traffic among healthy VMs. A load balancer health probe monitors a given port on each VM and only distributes traffic to an operational VM.For more info Please follow the [Azure Load balancer](https://azure.microsoft.com/en-us/services/load-balancer/)
| IP address resource for load balancer. | Virtual machines connect to a load balancer using their virtual network interface card (NIC). To distribute traffic to the VMs, a back-end address pool contains the IP addresses of the virtual (NICs) connected to the load balancer.To control the flow of traffic, you define load balancer rules for specific ports and protocols that map to your VMs.
| Resource for Redis Cache | Managed instance of the Redis key-value storage. Your PHP applications can connect to this to store sessions and other transient data. Redis store data in-memory, so it’s very fast. Azure Cache for Redis is a distributed, managed cache that helps you build highly scalable and responsive applications by providing super-fast access to your data.
| VM resource for scale set | A virtual machine scale set allows you to deploy and manage a set of identical, auto-scaling virtual machines. You can scale the number of VMs in the scale set manually, or define rules to autoscale based on resource usage like CPU, memory demand, or network traffic. An Azure load balancer then distributes traffic to the VM instances in the scale set. In this quickstart, you create a virtual machine scale set in the Azure portal.
| Storage Account for VM scale set | When you create a scale set in the portal, a load balancer is created. Network Address Translation (NAT) rules are used to distribute traffic to the scale set instances for remote connectivity such as RDP or SSH. With scale sets, all VM instances are created from the same base OS image and configuration. This approach lets you easily manage hundreds of VMs without additional configuration tasks or network management. When you have many VMs that run your application, it's important to maintain a consistent configuration across your environment. For reliable performance of your application, the VM size, disk configuration, and application installs should match across all VMs. |

#### NOTE: - 
There is no additional cost to scale sets. You only pay for the underlying compute resources such as the VM instances, load balancer, or Managed Disk storage.

## Next Steps

After successfull deployment We should be able to login to controller vm and gluster vm's as well.
1st we need to login to controller vm with ssh key using putty which we generated earlier.

## Deploying and Accessing VM on macOS/Linux

Below are the steps to access VM through LINUX/MAC
- Run below command on command prompt:
ssh-keygen -t rsa
- Running above command will ask for file name. Provide the file name.
- After 2nd step, it will ask for passphrase to generate private key. Provide same.
- This will generate 2 files with name provided by you. One file will have .pub extension and other file with no extension.
- Rename the extension less file and provide extension “.pem”. This is the private key file.
- Now open the .pub file and copy paste it on “SSH public key” parameter which is asked for at the time of deployment.
- To connect with VM, Open the terminal and navigate to the location where you have .pem file.
- Write following command in terminal:
chmod 600 {PrivateKeyFileName}.pem	
- Then write the below command on terminal:
ssh -i {privatekeyname}.pem {username}@{HostnameOfVM}

This will open the VM and you can access same.


## Note:- Before login to controller vm the key must be in Pageant (windows)

The “Pageant” program that was installed as part of the PuTTY package, can store your key's and give them to mRemote, WinSCP and PuTTY as required.

Open “Pageant” from the start menu. (Note: it may run off to the system tray)

If it has run off to the system tray, double click it, to bring up the main window.

[![Pageant](https://github.com/qdevelopergithub/LAMP/blob/master/images/pageant.png)]()

Click “Add Key” and give it your saved Key Pair.
If need be, provide the passphrase.

For login to controller vm. use putty client 

You can get the ip address or host name inside your azure portal. Click on Virtual machines on left side bar. You will see all the vm's.
Click on controller vm. Then click on Connect as in below screen. Use the IP address field as your hostname.

For eg:- controller-pubip-abcdesx.location.cloudapp.azure.com

[![Connect controller](https://github.com/qdevelopergithub/LAMP/blob/master/images/connect_to_controller.png)]()

controller-pubip-udujzx.centralus.cloudapp.azure.com

After login to Controller vm use below commands:-

cd /azlamp 		go inside azlamp directory (mountpoint is azlamp)
ls 			(will show you the directory list) bin certs data html
cd html			(go inside html directory)

Inside html directory where you will create your wordpress, drupal or any php site which will sync to cluster for HA(High Availability).
For testing purpose create any directory inside html directory.

```
sudo mkdir abc

```
After creating directory

Open a putty client on you PC and start new session.Login into controller vm. Then use below on your controller vm terminal to login into your private gluster vm.

```
ssh username@you.ip.add.ress

```
If you are not able to login into gluster vm please follow below steps to reset your ssh key. \
Go to portal.azure.com. Login into your account where deployment was done. On left bar click on Virtual machines.

You will see the controller vm with gluster vm's 

Click on Controller vm. Then scroll down to Reset password option. Below screen will display where you can enter the user name 
and ssh key we generated earlier.

Default username:-  azureadmin

[![reset ssh](https://github.com/qdevelopergithub/LAMP/blob/master/images/reset_ssh.png)]()

Repeat same process on all gluster vm's one by one. Now try to login again. You should able to login now.

After login into gluster vm \

Use below command to see the gluster status and volume info

```
sudo gluster peer status

sudo gluster volume info

cd /datadrive/brick/ 

```
You will now able to see all the folders which were available on controller vm inside /azlamp directory.

Now verify the abc directory we created earlier on controller vm inside /azlamp/html

```
cd /datadrive/brick/html
ls

```
You should now see the abc directory you created. \
If you want to mount and sync all data acroos vms with controller vm with some other directory for eg: /var/www/ \
Type the following command in gluster vm (not in controller) : if the directory not exist. \

```
sudo mkdir /var/www/
sudo mount -t glusterfs myglustervmname:/data /var/www/

```
Above command will mount the data volume on /var/www/ directory \
Update the /etc/fstab file on all gluster vm's using below commands \

```
sudo nano /etc/fstab

```
use below format to paste in fstab file \

myglustervmname:/data /var/www/ glusterfs defaults,_netdev 0 0

After adding above line \
press CTRL + O if using nano editor will save the file contents \
press Enter \
CTRL + X will back to terminal. \

Do above steps on every gluster vm and make sure use the correct gluster vm name \

### Note:-
We will logout now from gluster vm (Mandatory step without logout we are not able to login from gluster vm 1 to gluster vm 2 or vice versa).

```
logout

```
on terminal you will now be in controller vm

Repeat same process for 2nd gluster vm as we used for 1st gluster vm.

Open your web-browser and open link using IP address of your server. 

PHP app will be installed on Linux OS. But in our scenario everything is virtual, so the cluster is type of server which will store all the files and folders on virtual hard disk. Cluster File server will handle the entire load balancing and see which hard disk is idle or having lesser load and fetch data from that hard disk. This will ensure high availability.
The other way to install php app on Linux is login into virtual machine and run the particular commands to install any php app. The Linux users know how to install extra apps if required with the help of terminal or SSH.

## Manually install various apps

At this point, your LAMP application is setup to use in the LAMP cluster. If you'd like to install a separate LAMP application (WordPress or otherwise), Please follow below steps.
	
Install apache manually
```
sudo apt install apache2
sudo service apache2 restart

```
Install PHP manually

```
sudo apt install php
	
```
Command to install specific packages for PHP
```
sudo apt install php-pear php-fpm php-dev php-zip php-curl php-xmlrpc php-gd   php-mysql php-mbstring php-xml libapache2-mod-php

```

## Configuring the controller for a specific LAMP application (WordPress)

An example LAMP application (WordPress) is illustrated here for the sake of clarity. The approach is similar to any LAMP application out there. 

Download a latest version of Wordpress. Once that's done and you've downloaded the latest version of WordPress, please follow the instructions here to complete configuring a database and finishing a [WordPress install](https://codex.wordpress.org/Installing_WordPress#Famous_5-Minute_Installation). 

You can do it manually. Download a latest version of [Wordpress](https://wordpress.org/latest.tar.gz) Make a Directory structure var/www/html if not exist by using below command

```
sudo mkdir -p /var/www/html/

```

You can also change the owner by using following command

```
sudo chown -R www-data:www-data /var/www/html/

```

Set Directory permissions

```
sudo chmod -R 755 /var/www/html/

```
Then goto path where the latest.tar.gz file downloaded. Usually working directory.

```
cd /path/to/downloadfile

```

Run this command

```
tar -xzvf latest.tar.gz

```
Then use below command. which will copy the wordpress files to html directory.

```
sudo rsync -av wordpress/* /var/www/html/

```

You can to do this by using below commands as well.
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


You can do it manually. Download a latest version of [Drupal](https://ftp.drupal.org/files/projects/drupal-7.2.tar.gz) Make a Directory structure var/www/html if not exist by using below command

```
sudo mkdir -p /var/www/html/

```

You can also change the owner by using following command

```
sudo chown -R www-data:www-data /var/www/html/

```

Set Directory permissions

```
sudo chmod -R 755 /var/www/html/

```
Then goto path where the latest.tar.gz file downloaded. Usually working directory.

```
cd /path/to/downloadfile

```
Run this command

```
tar -xzvf drupal-7.2.tar.gz

```
Then use below command. which will copy the drupal files to html directory

```
sudo rsync -av drupal-7.2/* /var/www/html/

```


You can to do this by using below commands as well.
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

You can do it manually.Download a latest version of joomla. Make a Directory structure var/www/html if not exist by using below command

```
sudo mkdir -p /var/www/html/

```

Set Directory permissions

```
sudo chmod -R 755 /var/www/html/

```
Then goto path where the joomla zip file downloaded. Usually working directory.

```
cd /path/to/downloadfile

```

Run this command

```
sudo unzip Joomla*.zip -d /var/www/html/joomla

```

You can to do this by using below commands as well.
Below is a Full script which will run and install joomla on the cluster. 

```
Wget https://downloads.joomla.org/cms/joomla3/3-9-1/joomla_3-9-1-stable-full_package-zip?format=zip
sudo apt-get install unzip
sudo mkdir -p /var/www/html/
sudo unzip Joomla*.zip -d /var/www/html/joomla
sudo chown -R www-data:www-data /var/www/html/
sudo chmod -R 755 /var/www/html/

```

## Why use of Mulitple NIC’s

Virtual machines (VMs) in Azure can have multiple virtual network interface cards (NICs) attached to them. A common scenario is to have different subnets for front-end and back-end connectivity. You can associate multiple NICs on a VM to multiple subnets, but those subnets 	must all reside in the same virtual network (vNet).

## why GlusterFS

Gluster is a distributed scale out file system. GlusterFS combined of various storage servers into one large parallel network file system. GlusterFS consists of two components, client and a server component. Servers are setup as a storage bricks, which is the basic unit of storage.  

## Why cluster

A cluster is simply a group of servers. A load balancer distributes the workload between the servers in a cluster. At any point, a new web server can be added to the existing cluster to handle more requests from users accessing your application. The load balancer has a single responsibility: deciding which server from the cluster will receive a request that was intercepted.

A very simple cluster can be deployed with two basic servers (2 CPU’s, 4GB of RAM each, 1 Gigabit network). This is sufficient to have a nice file share or a place to put some nightly backups. Gluster is deployed successfully on all kinds of disks, from the lowliest 5200 RPM SATA to mightiest 1.21 Gigawatt SSD’s.

## OS Patching

Anyone can access the information for OS Patching from the below link:  
	https://github.com/Azure/azure-linux-extensions/tree/master/OSPatching
Automate Linux VM OS Updates Using OS Patching Extension:
Complete information about LINUX VM OS updates can be found at the link:  https://azure.microsoft.com/en-in/blog/automate-linux-vm-os-updates-using-ospatching-extension/

## Manual Linux VM OS Patching:

The command to update LINUX OS is as below which needs to be put in terminal:
sudo apt install unattended-upgrades
To configure unattended-upgrades, edit /etc/apt/apt.conf.d/50unattended-upgrades and adjust the following to fit your needs:

```
Unattended-Upgrade::Allowed-Origins {
      "${distro_id}:${distro_codename}";
      "${distro_id}:${distro_codename}-security";
      "${distro_id}:${distro_codename}-updates";
      "${distro_id}:${distro_codename}-proposed";
//    "${distro_id}:${distro_codename}-backports";
};

```

Certain packages can also be blacklisted and therefore will not be automatically updated. To blacklist a package, add it to the list:

``` 
Unattended-Upgrade::Package-Blacklist {
      "vim";
      "libc6";
      "libc6-dev";
//    "libc6-i686";
};

```
The double “//” serve as comments, so whatever follows "//" will not be evaluated.

To enable automatic updates, edit /etc/apt/apt.conf.d/20auto-upgrades and set the appropriate apt configuration options:

```
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::AutocleanInterval "7";
APT::Periodic::Unattended-Upgrade "1";

```
The above configuration updates the package list, downloads, and installs available upgrades every day. The local download archive is cleaned every week. On servers upgraded to newer versions of Ubuntu, depending on your responses, the file listed above may not be there. In this case, creating a new file of this name should also work.

### Starting and Stopping Gluster Manually

For complete information about GlusterFS, please follow the below link:
https://gluster.readthedocs.io/en/latest/Administrator%20Guide/Start%20Stop%20Daemon/

## Connect linux vm through RDP

Please enter below commands when connected through ssh in below sequence

```
sudo apt-get install xfce4
sudo apt-get install xrdp
sudo systemctl enable xrdp
echo xfce4-session >~/.xsession
sudo service xrdp restart
sudo passwd youradminuser

```
(it will ask for password and set the password and save for future usage)

To open Azure CLI, Click on 1st option next to Search panel \
Then select Bash\
Type "az" to use Azure CLI 2.0

[![Azure CLI](https://github.com/qdevelopergithub/LAMP/blob/master/images/azure_cli.png)]()

Then go to Azure CLI and enter this command with your resource group name and controller vm name as see in below example

```
az vm open-port --resource-group lamp --name controller-vm-66tjbz --port 3389

```

[![Azure CLI](https://github.com/qdevelopergithub/LAMP/blob/master/images/download_RDP.png)]()

Then click the “Download the RDP File” button as shown in image and connect.

The following example shows whether VM is listening on TCP port 3389 as expected. Please use the below command to check same:

```
sudo netstat -plnt | grep rdp

```
[![Netstat](https://github.com/qdevelopergithub/LAMP/blob/master/images/netstat.png)]()

If not listening on port then use

```
sudo service xrdp restart

```

Below are the screenshots while connecting to VM GUI.

[![XFCE Login](https://github.com/qdevelopergithub/LAMP/blob/master/images/xfce_login.png)]()


[![XFCE Login](https://github.com/qdevelopergithub/LAMP/blob/master/images/xfce_after_login.png)]()


[![XFCE Login](https://github.com/qdevelopergithub/LAMP/blob/master/images/xfce_terminal.png)]()

## Next Steps

# Prepare deployed cluster for LAMP applications

If you chose Apache as your `webServerType` and `true` for the `htmlLocalCopy` switch at your LAMP cluster deployment time, you can install additional LAMP sites on your  cluster, utilizing Apache's VirtualHost feature (we call this "LAMP generalization"). To manage your installed cluster, you'll first need to login to the LAMP cluster controller virtual machine. The directory you'll need to work out of is `/azlamp`. You will need privileged access which means that you'll either need to be root (superuser) or have *sudo* access. 

## Configuring the controller for a specific LAMP application (WordPress)

### Installation Destination
An example LAMP application (WordPress) is illustrated here for the sake of clarity. The approach is similar to any LAMP application out there. 

First, you'd need to navigate to `/azlamp/html` and create a directory based on a domain name you have in mind. An example domain name is used below:

```
cd /azlamp/html
mkdir wpsitename.mydomain.com
cd /azlamp/html/wpsitename.mydomain.com
```

Once that's done and you've downloaded the latest version of WordPress, please follow the instructions here to complete configuring a database and finishing a [WordPress install](https://codex.wordpress.org/Installing_WordPress#Famous_5-Minute_Installation). 

```
wget https://wordpress.org/latest.tar.gz
tar xvfz latest.tar.gz --strip 1
```


### SSL Certs

The certificates for your LAMP application reside in `/azlamp/certs/yourdomain` or in this instance, `/azlamp/certs/wpsitename.mydomain.com`

```
mkdir /azlamp/certs/wpsitename.mydomain.com
```

Copy over the .crt and .key files over to `/azlamp/certs/wpsitename.mydomain.com`.
The file names should be changed to `nginx.crt` and `nginx.key` in order to be recognized by the configured nginx servers. Depending on your local environment,
you may choose to use the utility *scp* or a tool like [WinSCP](https://winscp.net/eng/download.php) to copy these files over to the cluster controller virtual machine. 

It's recommended that the certificate files be read-only to owner and that these files are owned by *www-data*:

```
chown www-data:www-data /azlamp/certs/wpsitename.mydomain.com/*
chmod 400 /azlamp/certs/wpsitename.mydomain.com/*
```


### Linking to the content/cluster data location

Navigate to the WordPress content directory and run the following command:

```
mkdir -p /azlamp/data/wpsitename.mydomain.com/wp-content/uploads
cd /azlamp/html/wpsitename.mydomain.com
ln -s /azlamp/data/wpsitename.mydomain.com/wp-content/uploads .
```

This step is needed because the `<siteroot>/wp-content/uploads` directory need to be shared across all web frontend instances, and Wordpress configuration doesn't allow an external directory to be used as the uploads repository. In fact, Drupal also has a similar design, so a similar symbolic link will be needed for Drupal as well. This is in contrary to Moodle, which allows users to configure any external directory as its file storage location.

### Update Apache configurations on all web frontend instances

Once the correspnding html/data/certs directories are configured, we need to reconfigure all Apache services on web frontend instances, so that newly created sites are added to the Apache VirtualHost configurations and deleted sites are removed from them as well. This is done by the `/azlamp/bin/update-vmss-config` hook (executed every minute on each and every VMSS instance using a cron job), which requires us to provide the commands to run (to reconfigure Apache service) on each VMSS instance. There's already a utility script installed for that, so it's easy to achieve as follows.

On the controller machine, look up the file `/azlamp/bin/update-vmss-config`. If you haven't modified that file, you'll see the following lines in the file:

```
        #1)
        #    . /azlamp/bin/utils.sh
        #    reset_all_sites_on_vmss true VMSS apache
        #;;
```

Remove all the leading `#` characters from these lines (uncommenting) and save the file, then wait for a minute. After that, your newly added sites should be available through the domain names specified/used as the directory names (Of course this assumes you set up your DNS records for your new site FQDNs so that their CNAME records point to the deployed Moodle cluster's load balancer DNS name, whis is of the form `lb-xyz123.an_azure_region.cloudapp.azure.com`).

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
