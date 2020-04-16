# Summary #

# Source reference #
https://docs.openshift.com/container-platform/4.3/installing/installing_bare_metal/installing-bare-metal-network-customizations.html

# Requirements #
* [DHCP](#dhcp)
* [DNS](#dns)
* [Loadbalancer](#loadbalancer)
* [SSH keypair](#ssh-keypair)
* [Pull secret](#pull-secret)
* [OpenShift client tools](#obtaining-coreos-igntion-files-to-configure-vms)

### DHCP ###

### DNS ###

OpenShift uses several DNS records.
Below you can find a list of records that need to be created:

- A record	: 	api.\<cluster-name\>.\<base-domain\> \-\-\> points to loadbalancer in front of the 3 control plane nodes
- A record	: 	api-int.\<cluster-name\>.\<base-domain\> \-\-\> points to loadbalancer in front of the 3 control plane nodes
- A record	: 	\*.apps.\<cluster-name\>.\<base-domain\> \-\-\> points to loadbalancer in front of worker nodes
- A record	: 	etcd-\<index\>.\<cluster-name\>.\<base-domain\> \-\-\> points to controle plane nodes 
- SRV record	: 	\_etcd-server-ssl._tcp.\<cluster-name\>.\<base-domain\> port: 2380 \-\-\> points to etcd-\<index\>.\<cluster-name\>.\<base-domain\>

### Loadbalancer ###

OpenShift requires a loadbalancer in front of the 3 control plane nodes for the API, ... and a loadbalancer in front of the worker nodes for ingress application traffic (80 & 443)
For this deployment, HAProxy was used.

Here you can find an [example](https://github.com/JonasGovaerts/ocp4/tree/development/haproxy) configuration.

### SSH keypair ###

### Pull secret ###

### Obtaining a pull secret and the latest client tools, installation scripts and coreos image ###

All the required tokens and tools can be found on the site of [RedHat](https://cloud.redhat.com/openshift/install/metal/user-provisioned)
From here, you'll need to get the latest oc client, the installation script and a pull token.

To get these, you can use following commands:

````bash
wget -R -O https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-install-linux.tar.gz
tar -xvzf openshift-install-linux.tar.gz
rm openshift-install-linux.tar.gz
wget -R -O https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-client-linux.tar.gz
tar -xvzf openshift-client-linux.tar.gz 
rm openshift-client-linux.tar.gz
````

# Obtaining coreos igntion files to configure VMs #
OpenShift 4 uses coreos as it's operating system. To configure this, ignition is used.
RedHat created a script to generate these ignition files.

Steps to operate this script:

````bash
mkdir install_dir 		# create folder where install-config.yml will be placed

ssh_public_key='<value>' 	# set ssh_public_key value to the value of the newly generated ssh keypair
pullSecret='<value>' 		# set the pullSecret value to the value of the obtained pullsecret from RedHat
cluster_id'<value> 		# set the cluster_id value to the value chosen for the cluster name

echo \
"apiVersion: v1
baseDomain: openshift.local
compute:
- hyperthreading: Enabled
  name: worker
  replicas: 0
controlPlane:
  hyperthreading: Enabled
  name: master
  replicas: 3
metadata:
  name: $cluster_id
networking:
  clusterNetwork:
  - cidr: 10.128.0.0/14
    hostPrefix: 23
  networkType: OpenShiftSDN
  serviceNetwork:
  - 172.30.0.0/16
platform:
  none: {}
pullSecret: '$pullSecret'
sshKey: '$ssh_pub_key'" > ./install_dir/install-config.yml

./openshift-install create manifests --dir=./install_dir 			# create the manifest files to be used by the script to generate the ignition files
sed -i 's/true/false' ./install_dir/manifests/....				# set the scheduleability of the controle plane nodes to false
./openshift-install create ignition-configs --dir=installation_directory	# create the ignition files required for the VMs
````
