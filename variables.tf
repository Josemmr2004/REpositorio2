variable "vsphere_server" {
    description = "vsphere server - EXAMPLE: vcenter6.cinconet.local"
    default = "10.100.80.204"
}

variable "vsphere_user" {
    description = "vsphere server for the environment - EXAMPLE: user@cinconet.local"
    default = "frodriguez@cinconet.local"
}

variable "vsphere_password" {
    description = "vsphere server password for the environment"
    default = "xxxxxxxxxxxxxxx"
}

variable "virtual_machine_dns_servers" {
  type    = "list"
  default = ["10.100.0.111", "10.100.80.112"]
}
