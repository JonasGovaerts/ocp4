# -[Disk]-------------------------------------------------------------

resource "libvirt_volume" "bootstrap-disk" {
  name             = "coreos-bootstrap.qcow2"
  source	   = "http://192.168.0.100:8888/redhat-coreos.qcow2"
  pool             = "default"
  format           = "qcow2"
}

# -[Igntion]-------------------------------------------------------------

resource "libvirt_ignition" "bootstrap_ignition" {
  name = "bootstrap.ign"
  content = "bootstrap.ign"
}

# -[Domain]-------------------------------------------------------------

resource "libvirt_domain" "bootstrap" {
  name   = "bootstrap"
  vcpu   = "4"
  memory = "8192"

  coreos_ignition = libvirt_ignition.bootstrap_ignition.id

  disk {
    volume_id = libvirt_volume.bootstrap-disk.id
  }

  graphics {
    listen_type = "address"
  }

  console {
    type = "pty"
    target_port = "0"
  }

  network_interface {
    network_name   = libvirt_network.ocp4.name
    hostname       = "bootstrap"
    addresses      = ["192.168.0.209"]
  }
}
