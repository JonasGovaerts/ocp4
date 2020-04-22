# -[Provider]-------------------------------------------------------------

provider "libvirt" {
    uri = "qemu:///system" 
}

provider "dns" {
  update {
    server        = "192.168.0.201"
    key_name      = "openshift.local"
    key_algorithm = "hmac-md5"
    key_secret    = ""
  }
}
