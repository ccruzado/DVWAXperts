##########################################################
### AWS
##########################################################
region          = "us-east-1"
az1             = "us-east-1a"  
az2             = "us-east-1b"
size            = "t3.large"
keyname         = "fortinet"

##########################################################
### VPC DVWA
##########################################################
dvwa-vpc-cidr      = "10.50.0.0/16"
dvwa-sn-cidr-pub1  = "10.50.10.0/24"
dvwa-sn-cidr-pub2  = "10.50.20.0/24"
dvwa-sn-cidr-pri1  = "10.50.30.0/24"
dvwa-sn-cidr-pri2  = "10.50.40.0/24"