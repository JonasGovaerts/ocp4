# -[Provider]-------------------------------------------------------------

provider "libvirt" {
    uri = "qemu:///system" 
}

# -[Output]-------------------------------------------------------------

output "bootstrap_ipv4" {
  value = libvirt_domain.dns.*.network_interface.0.addresses
}
