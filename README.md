### source reference ###
https://docs.openshift.com/container-platform/4.3/installing/installing_bare_metal/installing-bare-metal-network-customizations.html

### loadbalancer ###

[haproxy](https://github.com/JonasGovaerts/ocp4/tree/development/haproxy)


### DNS config needed ###
- "api.cluster-name.base-domain"
- "api-int.cluster-name.base-domain"
- "*.apps.cluster-name.base-domain"
- "etcd-index.cluster-name.base-domain"
- "_etcd-server-ssl._tcp.cluster-name.base-domain port: 2380 target: etcd-index.cluster-name.base-domain"

### latest version of openshift can be found here ###
https://cloud.redhat.com/openshift/install/metal/user-provisioned

### Download the latest oc client tools ###
````
wget https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-install-linux.tar.gz
tar -xvzf <filename>
````

### Download the latest rhcos image ###
wget https://mirror.openshift.com/pub/openshift-v4/dependencies/rhcos/4.3/4.3.8/rhcos-4.3.8-x86_64-installer.x86_64.iso

### get the latest installation files
````
oc adm release extract --tools registry.svc.ci.openshift.org/origin/....... 
tar -xvzf <filenames>
````

### create direcotry and create install-config.yml file ###
````
mkdir installation_directory
vi installation_directory/install-config.yml
````
````
apiVersion: v1
baseDomain: openshift.local
compute:
- hyperthreading: Enabled
  name: worker
  replicas: 0
controlPlane:
  hyperthreading: Enabled
  name: master
  replicas: 1
metadata:
  name: test
networking:
  clusterNetwork:
  - cidr: 10.128.0.0/14
    hostPrefix: 23
  networkType: OpenShiftSDN
  serviceNetwork:
  - 172.30.0.0/16
platform:
  none: {}
pullSecret: 
sshKey: 
````

### create manifests and config files
````
./openshift-install create manifests --dir=./installation_directory
````

### set schedulability for master to false ###
````
Modify the <installation_directory>/manifests/cluster-scheduler-02-config.yml Kubernetes manifest file to prevent Pods from being scheduled on the control plane machines:
````

### create the ignition files ###
````
./openshift-install create ignition-configs --dir=installation_directory
````

### copy the ignition files to webserver ###
````
scp *.ign root@192.168.0.100:/mnt/user/Dockerconfig/letsencrypt/www/openshift-files
````

### restart web server ###
````
docker restart nginx
````

### start coreos bootstrap and master VM with the added config to the kernel ###
````
coreos.inst.install_dev=vda coreos.inst.ignition_url=http://192.168.0.100:8888/bootstrap-static.ign coreos.inst.image_url=http://192.168.0.100:8888/rhcos-4.3.8-x86_64-metal.x86_64.raw.gz
coreos.inst.install_dev=vda coreos.inst.ignition_url=http://192.168.0.100:8888/master-001-static.ign coreos.inst.image_url=http://192.168.0.100:8888/rhcos-4.3.8-x86_64-metal.x86_64.raw.gz
coreos.inst.install_dev=vda coreos.inst.ignition_url=http://192.168.0.100:8888/master-002-static.ign coreos.inst.image_url=http://192.168.0.100:8888/rhcos-4.3.8-x86_64-metal.x86_64.raw.gz
coreos.inst.install_dev=vda coreos.inst.ignition_url=http://192.168.0.100:8888/master-003-static.ign coreos.inst.image_url=http://192.168.0.100:8888/rhcos-4.3.8-x86_64-metal.x86_64.raw.gz
````
