provider "vsphere" {
  user           = "${var.vsphere_user}"
  password       = "${var.vsphere_password}"
  vsphere_server = "${var.vsphere_server}"

  # if you have a self-signed cert
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = "vCPD_Telecinco"
}



data "vsphere_datastore" "datastore" {
  name          = "VxRail-Virtual-SAN-Datastore-65106882-e2fd-43ad-8ef0-057d63b51499"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

 data "vsphere_compute_cluster" "cluster" {
  name          = "VXRAIL"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

#data "vsphere_host" "host" {
#  name          = "esx-cdhdes02.cinconet.local"
#  datacenter_id = "${data.vsphere_datacenter.dc.id}"
#}

data "vsphere_network" "network" {
  name          = "90"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template" {
    name          = "Centos7_Silver"
    datacenter_id = "${data.vsphere_datacenter.dc.id}"
}


resource "vsphere_virtual_machine" "vm" {
  name             = "Centos_Silver"
  resource_pool_id = "${data.vsphere_compute_cluster.cluster.resource_pool_id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"
  cpu_hot_add_enabled =  "true"
  memory_hot_add_enabled = "true"
  num_cpus = "8"
  memory   = "1024"
  guest_id = "${data.vsphere_virtual_machine.template.guest_id}"

  scsi_type = "${data.vsphere_virtual_machine.template.scsi_type}"

  network_interface {
    network_id   = "${data.vsphere_network.network.id}"
    adapter_type = "${data.vsphere_virtual_machine.template.network_interface_types[0]}"
  }


  disk {
    label            = "1"
    size	     = "65"	
   # size             = "${data.vsphere_virtual_machine.template.disks.0.size}"
   # eagerly_scrub    = "${data.vsphere_virtual_machine.template.disks.0.eagerly_scrub}"
    thin_provisioned = "${data.vsphere_virtual_machine.template.disks.0.thin_provisioned}"
    unit_number  = 0
  }
 disk {
   label            = "2"
   size             = "${data.vsphere_virtual_machine.template.disks.1.size}"
   # eagerly_scrub    = "${data.vsphere_virtual_machine.template.disks.1.eagerly_scrub}"
    thin_provisioned = "${data.vsphere_virtual_machine.template.disks.1.thin_provisioned}"
    unit_number  = 1
  }


  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"


}

#network_interface {
#        ipv4_address = "10.100.90.101"
#        ipv4_netmask = 24
#        dns_server_list = "${var.virtual_machine_dns_servers}"
#      }
#
#      ipv4_gateway = "10.100.90.254"
#

     }


   







