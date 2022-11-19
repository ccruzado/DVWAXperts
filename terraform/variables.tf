##########################################################
### AWS
##########################################################
variable "region" {
  default = "eu-west-1"
}

variable "az1" {
  default = "eu-west-1a"
}

variable "az2" {
  default = "eu-west-1c"
}

variable "size" {
  default = "c5n.xlarge"
}

variable "keyname" {
  default = "<AWS SSH KEY>"
}

##########################################################
### VPC DVWA
##########################################################
variable "dvwa-vpc-cidr" {
  default = "172.16.0.0/16"
}

variable "dvwa-sn-cidr-pub1" {
  default = "172.16.10.0/24"
}

variable "dvwa-sn-cidr-pub2" {
  default = "172.16.10.0/24"
}

variable "dvwa-sn-cidr-pri1" {
  default = "172.16.10.0/24"
}

variable "dvwa-sn-cidr-pri2" {
  default = "172.16.20.0/24"
}

