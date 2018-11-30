provider "vsphere" {
  user           = "${var.vsphere_user}"
  password       = "${var.vsphere_password}"
  vsphere_server = "${var.vsphere_server}"

  # if you have a self-signed cert
  allow_unverified_ssl = true data "vsphere_datacenter" "dc" {
  name = "vCPD-Telecinco"
}

data "vsphere_datastore" "datastore" {
  name          = "DESARROLLO-LINUX-1-EQL"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_compute_cluster" "cluster" {
  name          = "Nutanix-DES"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
  name          = "86"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template" {
  name          = "WS2012StdR2 KP 434D"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

resource "vsphere_virtual_machine" "vm" {
  name             = "win16test1"
  resource_pool_id = "${data.vsphere_compute_cluster.cluster.resource_pool_id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"

  num_cpus = 2
  memory   = 1024
  guest_id = "${data.vsphere_virtual_machine.template.guest_id}"

  scsi_type = "${data.vsphere_virtual_machine.template.scsi_type}"

  network_interface {
    network_id   = "${data.vsphere_network.network.id}"
    adapter_type = "${data.vsphere_virtual_machine.template.network_interface_types[0]}"
  }

 disk {
   label            = "Disco C"
    size             = "${data.vsphere_virtual_machine.template.disks.0.size}"
    eagerly_scrub    = "${data.vsphere_virtual_machine.template.disks.0.eagerly_scrub}"
    thin_provisioned = "${data.vsphere_virtual_machine.template.disks.0.thin_provisioned}"
    unit_number  = 0
  }
disk {
   label            = "Disco D"
   size             = "${data.vsphere_virtual_machine.template.disks.1.size}"
    eagerly_scrub    = "${data.vsphere_virtual_machine.template.disks.1.eagerly_scrub}"
   thin_provisioned = "${data.vsphere_virtual_machine.template.disks.1.thin_provisioned}"
    unit_number  = 1
 }
disk {
    label            = "Disco E"
   size             = "${data.vsphere_virtual_machine.template.disks.2.size}"
    eagerly_scrub    = "${data.vsphere_virtual_machine.template.disks.2.eagerly_scrub}"
    thin_provisioned = "${data.vsphere_virtual_machine.template.disks.2.thin_provisioned}"
    unit_number  = 2
  }

  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"

    customize {
      windows_options {
        computer_name = "win16test1"
        join_domain = "cinconet.local"
        domain_admin_user = "frodriguez@cinconet.local"
        domain_admin_password = "Bai0na17"
      }

      network_interface {
        ipv4_address = "10.100.86.253"
        ipv4_netmask = 24
      }

      ipv4_gateway = "10.100.86.254"
    }
}
}
}
