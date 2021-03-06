#!/bin/bash

# The MIT License (MIT)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

set -ex

#parameters 
{
    lamp_on_azure_configs_json_path=${1}

    . ./helper_functions.sh

    get_setup_params_from_configs_json $lamp_on_azure_configs_json_path || exit 99

    echo $glusterNode          >> /tmp/vars.txt
    echo $glusterVolume        >> /tmp/vars.txt
    echo $siteFQDN             >> /tmp/vars.txt
    echo $httpsTermination     >> /tmp/vars.txt
    echo $dbIP                 >> /tmp/vars.txt
    echo $Lampdbname         >> /tmp/vars.txt
    echo $Lampdbuser         >> /tmp/vars.txt
    echo $lampdbpass         >> /tmp/vars.txt
    echo $adminpass            >> /tmp/vars.txt
    echo $dbadminlogin         >> /tmp/vars.txt
    echo $dbadminloginazure    >> /tmp/vars.txt
    echo $dbadminpass          >> /tmp/vars.txt
    echo $storageAccountName   >> /tmp/vars.txt
    echo $storageAccountKey    >> /tmp/vars.txt
    echo $azureLampdbuser    >> /tmp/vars.txt
    echo $redisDns             >> /tmp/vars.txt
    echo $redisAuth            >> /tmp/vars.txt
    echo $installO365pluginsSwitch    >> /tmp/vars.txt
    echo $dbServerType                >> /tmp/vars.txt
    echo $fileServerType              >> /tmp/vars.txt
    echo $mssqlDbServiceObjectiveName >> /tmp/vars.txt
    echo $mssqlDbEdition	>> /tmp/vars.txt
    echo $mssqlDbSize	>> /tmp/vars.txt
    echo $installObjectFsSwitch >> /tmp/vars.txt
    echo $installGdprPluginsSwitch >> /tmp/vars.txt
    echo $thumbprintSslCert >> /tmp/vars.txt
    echo $thumbprintCaCert >> /tmp/vars.txt
    echo $siteURL >> /tmp/vars.txt

    # check_fileServerType_param $fileServerType

    # make sure system does automatic updates and fail2ban
    apt-get -y update
    apt-get -y install unattended-upgrades fail2ban

    config_fail2ban

    # create gluster, nfs or Azure Files mount point
    mkdir -p /azlamp

    export DEBIAN_FRONTEND=noninteractive

    # configure gluster repository & install gluster client
    add-apt-repository ppa:gluster/glusterfs-3.10 -y                >> /tmp/apt1.log
    apt-get -y update                                               >> /tmp/apt2.log
    apt-get -y --force-yes install rsyslog git                      >> /tmp/apt3.log
    apt-get -y --force-yes install glusterfs-client                 >> /tmp/apt4.log
  
    # install client for MySQL
    apt-get -y --force-yes install mysql-client                     >> /tmp/apt5.log
    
    # mount gluster files system
    echo -e '\n\rInstalling GlusterFS on '$glusterNode':/'$glusterVolume '/azlamp\n\r' 
    setup_and_mount_gluster_share $glusterNode $glusterVolume /azlamp
    
    # install pre-requisites
    apt-get install -y --fix-missing python-software-properties unzip

    # install the entire stack
    apt-get -y --force-yes install nginx php-fpm varnish >> /tmp/apt6a.log
    apt-get -y --force-yes install php php-cli php-curl php-zip >> /tmp/apt6b.log

    # LAMP requirements
    apt-get update > /dev/null
    apt-get install -y --force-yes graphviz aspell php-common php-soap php-json php-redis > /tmp/apt7.log
    apt-get install -y --force-yes php-bcmath php-gd php-xmlrpc php-intl php-xml php-bz2 php-pear php-mbstring php-dev php-mysql mcrypt >> /tmp/apt7.log
    PhpVer=$(get_php_version)
    
    # Set up initial LAMP dirs
    mkdir -p /azlamp/html
    mkdir -p /azlamp/certs
    mkdir -p /azlamp/data

    # Build nginx config
    create_main_nginx_conf_on_controller $httpsTermination

    update_php_config_on_controller

    # Remove the default site
    rm -f /etc/nginx/sites-enabled/default

    # restart Nginx
    systemctl restart nginx

    # Varnish
    configure_varnish_on_controller
    systemctl daemon-reload
    systemctl restart varnish

    # Master config for syslog
    config_syslog_on_controller
    service rsyslog restart

    # Turning off services we don't need the controller running
    systemctl stop nginx
    systemctl stop php${PhpVer}-fpm
    systemctl stop varnish
    systemctl stop varnishncsa
    systemctl stop varnishlog

    create_last_modified_time_update_script
    run_once_last_modified_time_update_script

    # Install scripts for LAMP gen.
    mkdir -p /azlamp/bin
    cp helper_functions.sh /azlamp/bin/utils.sh
    chmod +x /azlamp/bin/utils.sh
    cat <<EOF > /azlamp/bin/update-vmss-config
#!/bin/bash

# Lookup the version number corresponding to the next process to be run on the machine
VERSION=1
VERSION_FILE=/root/vmss_config_version
[ -f \${VERSION_FILE} ] && VERSION=\$(<\${VERSION_FILE})

# iterate over processes that haven't yet been run on this machine, executing them one by one
while true
do
    case \$VERSION in
        # Uncomment the following block when adding/removing sites. Change the parameters if needed (default should work for most cases).
        # true (or anything else): htmlLocalCopySwitch, VMSS (or anything else): https termination, apache (or nginx): web server type
        # Add another block with the next version number for any further site addition/removal.

        #1)
        #    . /azlamp/bin/utils.sh
        #    reset_all_sites_on_vmss true VMSS apache
        #;;

        *)
            # nothing more to do so exit
            exit 0
        ;;
    esac

    # increment the version number and store it away to mark the successful end of the process
    VERSION=\$(( \$VERSION + 1 ))
    echo \$VERSION > \${VERSION_FILE}

done
EOF
  
}  > /tmp/install.log
