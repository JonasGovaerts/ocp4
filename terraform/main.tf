# -[Provider]-------------------------------------------------------------

provider "libvirt" {
    uri = "qemu:///system" 
}

# -[Network]-------------------------------------------------------------

resource "libvirt_network" "ocp4" {
  name = "ocp4"
  mode = "bridge"
  bridge = "br0"
  addresses = ["192.168.0.0/24"]
}

# -[Output]-------------------------------------------------------------

output "bootstrap_ipv4" {

  value = libvirt_domain.bootstrap.*.network_interface.0.addresses

}


