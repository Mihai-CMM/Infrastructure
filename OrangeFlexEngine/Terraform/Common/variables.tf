### Variables #######
## check this link for sizing https://docs.uipath.com/orchestrator/docs/hardware-requirements-orchestrator#section-support-between-250-and-500-unattended-robots

#### Openstack router aka VPC in FE terminalogy
variable "vpc_name" {
  default = "uipath"
}

variable "vpc_cidr" {
  default = "172.19.0.0/16"
}

variable "subnet_name" {
     default = "uipath_subnet"
}

variable "subnet_cidr" {
     default = "172.19.1.0/24"
}


variable "subnet_gateway_ip" {
     default = "172.19.1.1"
}


variable "nat_floating_ip_id" {
     default = "27df535a-33c4-45de-9a56-3c8e0b3506c0"
## IP needs to be created from webUI and ID collected - used for internet access 
}

variable "default_sec_group" {
    default = "084c7fde-8297-434d-a6f4-a7572f9de251"
## Manually created from webui -- ATM - needs to be dynamically collected

}

