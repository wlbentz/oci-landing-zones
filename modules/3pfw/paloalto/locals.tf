
locals {
  prod_environment = {
    environment_prefix = "P"
  }
  region_key           = [for region in local.region_subscriptions : region.region_key if region.region_name == var.region]
  region_subscriptions = data.oci_identity_region_subscriptions.regions.region_subscriptions

  #use_existing_network = var.network_strategy == var.network_strategy_enum["USE_EXISTING_VCN_SUBNET"] ? true : false
  use_existing_network = false

  # marketplace
  mp_subscription_enabled  = var.mp_subscription_enabled ? 1 : 0
  listing_id               = var.mp_listing_id
  listing_resource_id      = var.mp_listing_resource_id
  listing_resource_version = var.mp_listing_resource_version


  #is_flex_shape       = var.vm_compute_shape == "VM.Standard.E3.Flex" ? [var.vm_flex_shape_ocpus] : []
  is_flex_shape = var.vm_compute_shape == "VM.Optimized3.Flex" || var.vm_compute_shape == "VM.Standard3.Flex" ? [var.vm_flex_shape_ocpus] : []
  #is_spoke_flex_shape = var.spoke_vm_compute_shape == "VM.Standard.E4.Flex" ? [var.spoke_vm_flex_shape_ocpus] : []

}
