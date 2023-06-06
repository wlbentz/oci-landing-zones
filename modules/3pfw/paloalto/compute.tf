
# new mgmt subnet
resource "oci_core_subnet" "mgmt" {
  cidr_block     = var.prod_hub_mgmt_public_subnet_cidr_block
  display_name   = "OCI-ELZ-SUB-${var.environment_prefix}-HUB-${local.region_key[0]}003"
  dns_label      = "mgmt3pfw"
  compartment_id = var.prod_hub_vcn_cmpt_id ### TODO of the prod vcn
  vcn_id         = var.prod_hub_vcn_id      ### prod vcn OCI-ELZ-P-SRD-NET
  #route_table_id = var.route_table_id ## of the correct route table
  #security_list_ids = var.security_list_ids ### proper security list id
}

# new ha subnet
resource "oci_core_subnet" "ha" {
  cidr_block                 = var.prod_hub_ha_private_subnet_cidr_block
  display_name               = "OCI-ELZ-SUB-${var.environment_prefix}-HUB-${local.region_key[0]}004"
  dns_label                  = "ha3pfw"
  compartment_id             = var.prod_hub_vcn_cmpt_id ### TODO of the prod vcn
  vcn_id                     = var.prod_hub_vcn_id      ### prod vcn OCI-ELZ-P-SRD-NET
  prohibit_public_ip_on_vnic = true
  #route_table_id = var.route_table_id ## of the correct route table
  #security_list_ids = var.security_list_ids ### proper security list id
}

# # ------ Create Firewall VMs  
resource "oci_core_instance" "firewall-vms" {
  depends_on = [oci_core_app_catalog_subscription.mp_image_subscription]
  count      = 2

  availability_domain = length(data.oci_identity_availability_domains.ads.availability_domains) == 1 ? data.oci_identity_availability_domains.ads.availability_domains[0].name : data.oci_identity_availability_domains.ads.availability_domains[count.index].name
  compartment_id      = var.prod_hub_vcn_cmpt_id
  display_name        = "${var.vm_display_name}-${count.index + 1}"
  shape               = var.vm_compute_shape
  fault_domain        = data.oci_identity_fault_domains.fds.fault_domains[count.index].name

  dynamic "shape_config" {
    for_each = local.is_flex_shape
    content {
      ocpus = shape_config.value
    }
  }

  create_vnic_details {
    subnet_id              = oci_core_subnet.mgmt.id
    display_name           = var.vm_display_name
    assign_public_ip       = true
    nsg_ids                = [oci_core_network_security_group.nsg.id]
    skip_source_dest_check = "true"
  }

  source_details {
    source_type = "image"
    source_id   = local.listing_resource_id
  }

  launch_options {
    network_type = var.instance_launch_options_network_type
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
  }
}

resource "oci_core_vnic_attachment" "untrust_vnic_attachment" {
  count = 2
  create_vnic_details {
    subnet_id              = var.prod_hub_pub_sub_id
    assign_public_ip       = "false"
    skip_source_dest_check = "true"
    nsg_ids                = [oci_core_network_security_group.nsg.id]
    display_name           = "untrust"
  }
  instance_id = oci_core_instance.firewall-vms[count.index].id
  depends_on = [
    oci_core_instance.firewall-vms,
  ]
}

resource "oci_core_vnic_attachment" "trust_vnic_attachment" {
  count = 2
  create_vnic_details {
    subnet_id              = var.prod_hub_priv_sub_id
    assign_public_ip       = "false"
    skip_source_dest_check = "true"
    nsg_ids                = [oci_core_network_security_group.nsg.id]
    display_name           = "trust"
  }
  instance_id = oci_core_instance.firewall-vms[count.index].id
  depends_on = [
    oci_core_vnic_attachment.untrust_vnic_attachment
  ]
}

resource "oci_core_vnic_attachment" "ha_vnic_attachment" {
  count = 2
  create_vnic_details {
    subnet_id              = oci_core_subnet.ha.id
    assign_public_ip       = "false"
    skip_source_dest_check = "true"
    nsg_ids                = [oci_core_network_security_group.nsg.id]
    display_name           = "Diagnostic"
  }
  instance_id = oci_core_instance.firewall-vms[count.index].id
  depends_on = [
    oci_core_vnic_attachment.trust_vnic_attachment
  ]
}
