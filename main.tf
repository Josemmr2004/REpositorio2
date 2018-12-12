provider "vsphere" {
  user           = "${var.vsphere_user}"
  password       = "${var.vsphere_password}"
  vsphere_server = "${var.vsphere_server}"
  
  # if you have a self-signed cert
  allow_unverified_ssl = true   
}

data "vsphere_datacenter" "dc" {
  name = "vCPD-Telecinco"
}

 data "vsphere_datastore" "datastore" {
  name          = "EMC_DATASTORE_WINDOWS_06"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

 data "vsphere_compute_cluster" "cluster" {
  name          = "vProdWindows"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
  name          = "82"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template" {
    name          = "WS2016-64X 26_10_18"
    datacenter_id = "${data.vsphere_datacenter.dc.id}"
  }

resource "vsphere_virtual_machine" "vm" {
  name             = "msscapp03vmpro"
  resource_pool_id = "${data.vsphere_compute_cluster.cluster.resource_pool_id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"

  num_cpus = 4
  memory   = 16384
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
        computer_name = "msscapp03vmpro"
        admin_password = "S1st3m@s.1nf0R"
        auto_logon = true
        auto_logon_count = 1
        full_name = "Administrator"
        join_domain = "cinconet.local"
        domain_admin_user = "backup@cinconet.local"
        domain_admin_password = "Entraya123"
        run_once_command_list = [
         "winrm quickconfig -force",
         "winrm set winrm/config/client/auth '@{Basic=\"true\"}",
         "winrm set winrm/config/service/auth '@{Basic=\"true\"}",
         "winrm set winrm/config/Service @{AllowUnencrypted=\"true\"}"]
    
}

      network_interface {
        ipv4_address = "10.100.82.70"
        ipv4_netmask = 24
	dns_server_list = "${var.virtual_machine_dns_servers}"
      }

      ipv4_gateway = "10.100.82.254"

     }

          
    }
    

}
##################################################################################################################
resource "vsphere_virtual_machine" "vm2" {
  name             = "msscapp04vmpro"
  resource_pool_id = "${data.vsphere_compute_cluster.cluster.resource_pool_id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"

  num_cpus = 4
  memory   = 16384
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
        computer_name = "msscapp04vmpro"
        admin_password = "S1st3m@s.1nf0R"
        auto_logon = true
        auto_logon_count = 1
        full_name = "Administrator"
        join_domain = "cinconet.local"
        domain_admin_user = "backup@cinconet.local"
        domain_admin_password = "Entraya123"
        run_once_command_list = [
         "winrm quickconfig -force",
         "winrm set winrm/config/client/auth '@{Basic=\"true\"}",
         "winrm set winrm/config/service/auth '@{Basic=\"true\"}",
         "winrm set winrm/config/Service @{AllowUnencrypted=\"true\"}"]
}

      network_interface {
        ipv4_address = "10.100.82.71"
        ipv4_netmask = 24
        dns_server_list = "${var.virtual_machine_dns_servers}"
      }

      ipv4_gateway = "10.100.82.254"

     }


    }


}










