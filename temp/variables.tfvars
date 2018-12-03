variable "vsphere_server" {
    description = "vsphere server for the environment - EXAMPLE: vcenter01.hosted.local"
    default = "vcenter.cinconet.local"
}
 
variable "vsphere_user" {
    description = "vsphere server for the environment - EXAMPLE: vsphereuser"
    default = "backup@cinconet.local"
}
 
variable "vsphere_password" {
    description = "vsphere server password for the environment"
    default = "Entraya123"
}
 
variable "virtual_machine_dns_servers" {
  type    = "list"
  default = ["10.100.80.111"]
  }