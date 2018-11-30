provider "vsphere" {
  user           = "jmmarentes@cinconet.local"
  vsphere_server = "vcenter.cinconet.local"

  # if you have a self-signed cert
  allow_unverified_ssl = true 

  data "vsphere_datacenter" "dc" {
    name = "vCPD-Telecinco"
  }

 }