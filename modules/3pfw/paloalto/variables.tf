# -----------------------------------------------------------------------------
# Common Variables
# -----------------------------------------------------------------------------
variable "tenancy_ocid" {
  type        = string
  description = "The OCID of tenancy"
}

variable "region" {
  type        = string
  description = "The OCI region"
}

variable "environment_prefix" {
  type        = string
  description = "the 1 character string representing the environment eg. P (prod), N (non-prod), D, T, U"
}

variable "dynamic_group_name" {
  type        = string
  description = "the 3PFW dynamic group name"
  default     = "ELZ-3PFW-DYNAMIC-GROUP"
}

variable "dynamic_group_description" {
  type    = string
  default = "The list of 3PFW instances"
}

variable "dynamic_group_policy_name" {
  type        = string
  default     = "ELZ-PAN-FW-POLICY"
  description = "The dynamic group policy name"
}

variable "dynamic_group_policy_description" {
  type        = string
  description = "The 3PFW dynamic group policy, allows members of this group to manage the instances"
  default     = "dynamic_group_policy_description"
}

variable "prod_hub_vcn_cmpt_id" {
  type        = string
  description = "The Production Hub VCN Compartment Id"
}

variable "prod_hub_vcn_id" {
  type        = string
  description = "Production Hub VCN ID"
}

variable "prod_hub_mgmt_public_subnet_cidr_block" {
  type        = string
  description = "Production Hub Mgmt Public CIDR block"
}

variable "prod_hub_ha_private_subnet_cidr_block" {
  type        = string
  description = "Production Hub HA Private subnet CIDR block"
}

variable "prod_hub_pub_sub_id" {
  type        = string
  description = "Production Hub public subnet id"
}

variable "prod_hub_priv_sub_id" {
  type        = string
  description = "Production Hub Private Subnet id"
}

variable "prod_drg_id" {
  type        = string
  description = "Production DRG id"
}

variable "prod_igw_id" {
  type        = string
  description = "Production IGW id"
}

variable "prod_hub_public_subnet_cidr_block" {
  type        = string
  description = "Production Hub Public Subnet CIDR block"
}

variable "prod_hub_private_subnet_cidr_block" {
  type        = string
  description = "Production Hub Private Subnet CIDR block"
}

variable "prod_hub_public_subnet_route_table_id" {
  type        = string
  description = "Production Hub Public Subnet Route Table id"
}

variable "prod_hub_private_subnet_route_table_id" {
  type        = string
  description = "Production Hub Private Subnet Route Table id"
}

variable "prod_drg_dft_rt_id" {
  type        = string
  description = "Production DRG Default Route Table id"
}

variable "prod_drg_rt_table_id" {
  type        = string
  description = "Production DRG Route Table id"
}

variable "ssh_public_key" {
  type = string
  description = "The ssh public key used for connecting to the firewall instances. This should be RSA 2048+"
}

variable "public_routetable_display_name" {
  type = string
  default = "ELZ-FW-UNTRUST"
}

variable "ha_routetable_display_name" {
  type = string
  default = "ELZ-FW-HA"
}

variable "sgw_routetable_display_name" {
  type = string
  default = "ELZ-SGW-TRANSIT-ROUTE"
}

variable "nsg_display_name" {
  type = string
  default = "ELZ-FW-Security-Group"
}