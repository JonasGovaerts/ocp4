# -[Disks]-------------------------------------------------------------

resource "libvirt_volume" "control-plane-disk" {
  name             = "master-00${count.index +1}.qcow2"
  source	   = "http://192.168.0.100:8888/rhcos-4.3.8-x86_64-qemu.x86_64.qcow2"
  pool             = "default"
  format           = "qcow2"
  count		   = "3"
}

# -[Igntion]-------------------------------------------------------------

resource "libvirt_ignition" "control-plane-ignition" {
  name = "control-plane.ign"
  content = "master.ign"
}

# -[Domains]-------------------------------------------------------------

resource "libvirt_domain" "control_plane" {
  name   = "master-00${count.index + 1}"
  vcpu   = "4"
  memory = "8192"
  count  = "3"

  coreos_ignition = libvirt_ignition.control-plane-ignition.id

  disk {
    volume_id = element(libvirt_volume.control-plane-disk.*.id, count.index +1) 
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
    hostname       = "master-00${count.index + 1}.home.openshift.local"
  }
}
