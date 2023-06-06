### 3rd Party Firewall Module 
module "paloalto-fw" {
  source                                 = "../../modules/3pfw/paloalto"
  region                                 = var.region
  tenancy_ocid                           = var.tenancy_ocid
  vm_display_name                        = var.vm_display_name
  vm_flex_shape_ocpus                    = var.vm_flex_shape_ocpus
  environment_prefix                     = var.environment_prefix
  ssh_public_key                         = var.ssh_public_key
  prod_hub_vcn_cmpt_id                   = var.prod_hub_vcn_cmpt_id
  prod_hub_vcn_id                        = var.prod_hub_vcn_id
  prod_hub_public_subnet_cidr_block      = var.prod_hub_public_subnet_cidr_block
  prod_hub_public_subnet_route_table_id  = var.prod_hub_public_subnet_route_table_id
  prod_hub_pub_sub_id                    = var.prod_hub_pub_sub_id
  prod_hub_private_subnet_cidr_block     = var.prod_hub_private_subnet_cidr_block
  prod_hub_private_subnet_route_table_id = var.prod_hub_private_subnet_route_table_id
  prod_hub_priv_sub_id                   = var.prod_hub_priv_sub_id
  prod_hub_mgmt_public_subnet_cidr_block = var.prod_hub_mgmt_public_subnet_cidr_block
  prod_hub_ha_private_subnet_cidr_block  = var.prod_hub_ha_private_subnet_cidr_block
  prod_drg_dft_rt_id                     = var.prod_drg_dft_rt_id
  prod_drg_id                            = var.prod_drg_id
  prod_drg_rt_table_id                   = var.prod_drg_rt_table_id
  prod_igw_id                            = var.prod_igw_id
}
