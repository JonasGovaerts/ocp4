# -[Disk]-------------------------------------------------------------

resource "libvirt_volume" "haproxy-disk" {
  name             = "haproxy.qcow2"
  source	   = "https://cloud-images.ubuntu.com/releases/xenial/release/ubuntu-16.04-server-cloudimg-amd64-disk1.img"
  pool             = "default"
  format           = "qcow2"
}

# -[Domain]-------------------------------------------------------------

resource "libvirt_domain" "haproxy" {
  name   = "haproxy"
  vcpu   = "2"
  memory = "4096"


  disk {
    volume_id = libvirt_volume.haproxy-disk.id
  }

  graphics {
    listen_type = "address"
  }

  console {
    type = "pty"
    target_port = "0"
  }

  network_interface {
    network_name   = "ocp4"
    hostname       = "haproxy"
    addresses      = ["192.168.0.200"]
  }
}
