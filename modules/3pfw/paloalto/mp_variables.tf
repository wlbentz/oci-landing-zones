############################
#  Marketplace Image      #
############################

variable "mp_subscription_enabled" {
  description = "Subscribe to Marketplace listing?"
  type        = bool
  default     = true
}

variable "mp_listing_id" {
  default     = "ocid1.appcataloglisting.oc1..aaaaaaaai7wszf2tvojm2zw5epmx6ynaivbbe6zpye2kts344zg6u2jujbta"
  description = "Marketplace Listing OCID"
}

variable "mp_listing_resource_id" {
  #default     = "ocid1.image.oc1..aaaaaaaamsbsxf7do5gk6wghiggqsxhtvbca2b2p5jrxqfemqjjcym4m3nxa"
  default     = "ocid1.image.oc1..aaaaaaaavkfkwje2pu5ok2e5rwcvb4ppczzzu25kjrtr7eovvtxubtnhzxma"
  description = "Marketplace Listing Image OCID"
}

variable "mp_listing_resource_version" {
  #default     = "PA-VM-10.1.0"
  default     = "PA-VM-10.2.2"
  description = "Marketplace Listing Package/Resource Version"
}

variable "vm_compute_shape" {
  default = "VM.Standard2.4"
}

variable "vm_flex_shape_ocpus" {}
variable "availability_domain_number" {
  default     = 1
  description = "OCI Availability Domains: 1,2,3  (subject to region availability)"
}

variable "vm_display_name" {
  type = string
  description = "The Display of the firewall devices"
  default = "ELZ-PAN-FW"
}

variable "instance_launch_options_network_type" {
  description = "NIC Attachment Type"
  default     = "PARAVIRTUALIZED"
}