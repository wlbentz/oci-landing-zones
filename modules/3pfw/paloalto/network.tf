
# ------ DRG From Firewall Route Table
resource "oci_core_drg_route_table" "from_firewall_route_table" {
  drg_id                           = var.prod_drg_id
  display_name                     = "From-Firewall"
  import_drg_route_distribution_id = oci_core_drg_route_distribution.firewall_drg_route_distribution.id
}

# ------ DRG to Firewall Route Table
resource "oci_core_drg_route_table" "to_firewall_route_table" {
  drg_id       = var.prod_drg_id
  display_name = "To-Firewall"
}

# ---- DRG Route Import Distribution 
resource "oci_core_drg_route_distribution" "firewall_drg_route_distribution" {
  distribution_type = "IMPORT"
  drg_id            = var.prod_drg_id
  display_name      = "Transit-Spokes"
}

# ------ Add DRG To Firewall Route Table Entry
resource "oci_core_drg_route_table_route_rule" "to_firewall_drg_route_table_route_rule" {
  drg_route_table_id         = oci_core_drg_route_table.to_firewall_route_table.id
  destination                = "0.0.0.0/0"
  destination_type           = "CIDR_BLOCK"
  next_hop_drg_attachment_id = data.oci_core_drg_attachments.attachs.drg_attachments.*.id[0]
}

# ------ Default Routing Table for Firewall VCN 
#  this will send all traffic to the firweall VCN
resource "oci_core_default_route_table" "default_route_table" {
  manage_default_resource_id = var.prod_drg_dft_rt_id
  display_name               = "DefaultRouteTable"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = var.prod_igw_id
  }
}

# ------ Outside Routing Table for Hub VCN 
resource "oci_core_route_table" "untrust_route_table" {
  compartment_id = var.prod_hub_vcn_cmpt_id
  vcn_id         = var.prod_hub_vcn_id
  display_name   = var.public_routetable_display_name

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = var.prod_igw_id
  }
}

# ------ HA Routing Table for Firewall VCN 
resource "oci_core_route_table" "ha_route_table" {
  compartment_id = var.prod_hub_vcn_cmpt_id
  vcn_id         = var.prod_hub_vcn_id
  display_name   = var.ha_routetable_display_name
}

# # ------ Create LPG Hub Route Table
resource "oci_core_route_table" "vcn_ingress_route_table" {
  compartment_id = var.prod_hub_vcn_cmpt_id
  vcn_id         = var.prod_hub_vcn_id
  display_name   = "VCN-INGRESS"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_private_ip.cluster_trust_ip.id
  }
}

# ------ Get All Services Data Value 
data "oci_core_services" "all_services" {
  filter {
    name   = "name"
    values = ["All .* Services In Oracle Services Network"]
    regex  = true
  }
}

# ------ Get Hub Service Gateway from Gateways (Hub VCN)
data "oci_core_service_gateways" "hub_service_gateways" {
  compartment_id = var.prod_hub_vcn_cmpt_id
  state          = "AVAILABLE"
  vcn_id         = var.prod_hub_vcn_id
}

# ------ Associate Emptry Route Tables to Service Gateway on Hub VCN Floating IP
resource "oci_core_route_table" "service_gw_route_table_transit_routing" {
  compartment_id = var.prod_hub_vcn_cmpt_id
  vcn_id         = var.prod_hub_vcn_id
  display_name   = var.sgw_routetable_display_name

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_private_ip.cluster_trust_ip.id
  }

}

# ------ Update Route Table for Trust Subnet
resource "oci_core_route_table_attachment" "update_inside_route_table" {
  subnet_id      = var.prod_hub_priv_sub_id
  route_table_id = oci_core_route_table.trust_route_table.id
}

# ------ Create route table for backend to point to backend cluster ip (Hub VCN)
resource "oci_core_route_table" "trust_route_table" {
  compartment_id = var.prod_hub_vcn_cmpt_id
  vcn_id         = var.prod_hub_vcn_id
  display_name   = "trust_route_table" #var.private_routetable_display_name

  # lookup cidr for current
  # TODO: need to dynamic to allow for input
  route_rules {
    destination       = "10.0.0.0/24"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = var.prod_drg_id
  }

  route_rules {
    destination       = "10.0.1.0/24"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = var.prod_drg_id
  }
}

# ------ Add Trust route table to Trust subnet (Hub VCN)
resource "oci_core_route_table_attachment" "trust_route_table_attachment" {
  subnet_id      = var.prod_hub_priv_sub_id
  route_table_id = oci_core_route_table.trust_route_table.id
}

# ------ Update Default Security List to Allow All  Rules
# ### review sec list
resource "oci_core_security_list" "allow_all_security" {
  compartment_id = var.prod_hub_vcn_cmpt_id
  vcn_id         = var.prod_hub_vcn_id
  display_name   = "AllowAll"
  ingress_security_rules {
    protocol = "all"
    source   = "0.0.0.0/0"
  }

  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }
}

# ------ Create Cluster Trust Floating IP (Hub VCN)
resource "oci_core_private_ip" "cluster_trust_ip" {
  vnic_id      = data.oci_core_vnic_attachments.trust_attachments.vnic_attachments.0.vnic_id
  display_name = "firewall_trust_secondary_private"
}

# ------ Create Cluster Untrust Floating IP (Hub VCN)
resource "oci_core_private_ip" "cluster_untrust_ip" {
  vnic_id      = data.oci_core_vnic_attachments.untrust_attachments.vnic_attachments.0.vnic_id
  display_name = "firewall_untrust_secondary_private"
}

# frontend cluster ip 
resource "oci_core_public_ip" "cluster_untrust_public_ip" {
  compartment_id = var.prod_hub_vcn_cmpt_id

  lifetime      = "RESERVED"
  private_ip_id = oci_core_private_ip.cluster_untrust_ip.id
}
