variable "environment_prefix" {
    type = string
    default = "P"
    description = "The deploment environment prefix"
}

variable "region" {
    type = string
    description = "The region you are deploying to (us-ashburn-1)"
}

variable "prod_drg_id" {
    type = string
    description = "The production DRG id"
}

variable "prod_drg_dft_rt_id" {
    type = string
    description = "The Production DRG default route id"
}

variable "prod_drg_rt_table_id" {
    type = string
    description = "The Production DRG route table id"
}

variable "prod_hub_mgmt_public_subnet_cidr_block" {
    type = string
    description = "Production Managment Public Subnet CIDR block, this will be the Public IP of the FW"
}

variable "prod_hub_ha_private_subnet_cidr_block" {
    type = string
    description = "Production HA Private Subnet CIDR Block, this will be the FW subnet failover"
}

variable "prod_hub_priv_sub_id" {
    type = string
    description = "Production HUB Public Subnet ID. This is the ID of the subnet you deployed as part of the ELZ 2.0"
}

variable "prod_hub_private_subnet_cidr_block" {
    type = string
    description = "Production Hub Private Subnet ID. This is the DMZ subnet id deployed as part of ELZ 2.0"
}

variable "prod_hub_private_subnet_route_table_id" {
    type = string
    description = "Production hub Private Subnet Route Table ID"
}

variable "prod_hub_pub_sub_id" {
    type = string
    description = "Production Hub Public Subnet ID"
}

variable "prod_hub_public_subnet_cidr_block" {
    type = string
    description = "Production Hub Public Sbunet CIDR Block"
    # default = "10.1.1.0/24" or better to specify in tfvars? 
}

variable "prod_hub_public_subnet_route_table_id" {
    type = string
    description = "Production Hub Public Subnet Route Table ID"
}

variable "prod_hub_vcn_cmpt_id" {
    type = string
    description = "Production Hub VCN compartment ID"
}

variable "prod_hub_vcn_id" {
    type = string
    description = "Production Hub VCN ID"
}

variable "prod_igw_id" {
    type = string
    description = "Production IGW ID"
}

variable "ssh_public_key" {
    type = string
    description = "The Users SSH Public key to be used for accessing the firewall device. This should be RSA 2048 bit encryption"
}

variable "tenancy_ocid" {
    type = string
    description = "The Tenancy OCID"
}

variable "vm_display_name" {
    type = string
    description = "The Firewall Display name."
    default = "elz-pan-fw"
}

variable "vm_flex_shape_ocpus" {
    type = number
    description = "The number of OCPUS for the flex Shape"
    default = 2
}
