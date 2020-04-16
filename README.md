### Summary ###

### Source reference ###
https://docs.openshift.com/container-platform/4.3/installing/installing_bare_metal/installing-bare-metal-network-customizations.html

### Requirements ###
* [DHCP](#dhcp)
* [DNS](#dns)
* [Loadbalancer](#loadbalancer)
* [Internet Connection](#internet-connection)
* [ssh keypair](#ssh-keypair)
* [pull secret](#pull-secret)

### DHCP ###

### DNS ###
- api.\<cluster-name\>.\<base-domain\>
- api-int.\<cluster-name\>.\<base-domain\>
- \*.apps.\<cluster-name\>.\<base-domain\>
- etcd-index.cluster-name.base-domain"
- \_etcd-server-ssl._tcp.cluster-name.base-domain port: 2380 target: etcd-index.cluster-name.base-domain"

### Loadbalancer ###

[haproxy](https://github.com/JonasGovaerts/ocp4/tree/development/haproxy)



### latest version of openshift can be found here ###
https://cloud.redhat.com/openshift/install/metal/user-provisioned

### Download the latest oc client tools ###
````bash
wget https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-install-linux.tar.gz
tar -xvzf <filename>
````

### Download the latest rhcos image ###
wget 

### get the latest installation files
````bash
oc adm release extract --tools registry.svc.ci.openshift.org/origin/....... 
tar -xvzf <filenames>
````

### create direcotry and create install-config.yml file ###
````bash
mkdir install_dir
ssh_public_key='<value>'
pullSecret='<value>'

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
````

### create manifests and config files
````bash
./openshift-install create manifests --dir=./install_dir
````

### set schedulability for master to false ###
````bash
sed -i 's/true/false' ./install_dir/manifests/....
````

### create the ignition files ###
````bash
./openshift-install create ignition-configs --dir=installation_directory
````
