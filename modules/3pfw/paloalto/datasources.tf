data "oci_identity_region_subscriptions" "regions" {
  tenancy_id = var.tenancy_ocid
}

# ------ Get the Tenancy ID and AD Number
data "oci_identity_availability_domain" "ad" {
  compartment_id = var.tenancy_ocid
  ad_number      = var.availability_domain_number
}

# ------ Get the Tenancy ID and ADs
data "oci_identity_availability_domains" "ads" {
  #Required
  compartment_id = var.tenancy_ocid
}

# ------ Get the Oracle Tenancy ID
data "oci_identity_tenancy" "tenancy" {
  tenancy_id = var.tenancy_ocid
}

# ------ Get Your Home Region
data "oci_identity_regions" "home-region" {
  filter {
    name   = "key"
    values = [data.oci_identity_tenancy.tenancy.home_region_key]
  }
}

# ------ Get the Faulte Domain within AD 
data "oci_identity_fault_domains" "fds" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = var.prod_hub_vcn_cmpt_id # TODO: update to use ?: and if set, use var, else use data lookup

  depends_on = [
    data.oci_identity_availability_domain.ad,
  ]
}

data "oci_core_security_lists" "allow_all_security" {
  compartment_id = var.prod_hub_vcn_cmpt_id
  vcn_id         = var.prod_hub_vcn_id
  filter {
    name   = "display_name"
    values = ["AllowAll"]
  }
  depends_on = [
    oci_core_security_list.allow_all_security,
  ]
}

## ------ Get the attachement based on Public Subnet
data "oci_core_vnic_attachments" "untrust_attachments" {
  compartment_id = var.prod_hub_vcn_cmpt_id
  instance_id    = oci_core_instance.firewall-vms.0.id

  filter {
    name   = "subnet_id"
    values = [var.prod_hub_pub_sub_id] # TODO: update to use ?: and if set, use var, else use data lookup
  }

  depends_on = [
    oci_core_vnic_attachment.untrust_vnic_attachment,
  ]
}

# ------ Get the attachement based on Private Subnet
data "oci_core_vnic_attachments" "trust_attachments" {
  compartment_id = var.prod_hub_vcn_cmpt_id
  instance_id    = oci_core_instance.firewall-vms.0.id

  filter {
    name   = "subnet_id"
    values = [var.prod_hub_priv_sub_id] # TODO: update to use ?: and if set, use var, else use data lookup
  }

  depends_on = [
    oci_core_vnic_attachment.trust_vnic_attachment,
  ]
}

# ------ Get Network Compartment Name for Policies
data "oci_identity_compartment" "network_compartment" {
  id = var.prod_hub_vcn_cmpt_id
}

# Get the drg_attachments
data "oci_core_drg_attachments" "attachs" {
  compartment_id = var.prod_hub_vcn_cmpt_id
}
