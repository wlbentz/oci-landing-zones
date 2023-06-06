# # -----------------------------------------------------------------------------
# # Provider Requirements if using stack as a module
# # -----------------------------------------------------------------------------
# terraform {
#   required_version = ">= 1.0.0"

#   required_providers {
#     oci = {
#       source                = "oracle/oci"
#       version               = "4.96.0" # October 05, 2022 Release
#       configuration_aliases = [oci, oci.home_region]
#     }
#   }
# }

# -----------------------------------------------------------------------------
# WARNING!
# UNCOMMENT EVERYTHING BELOW AND COMMENT EVERYTHING ABOVE IF YOU WISH TO USE THIS 
# STACK AS A STANDALONE - DO NOT TOUCH IF USING THIS STACK IN A MODULE CALL
# Provider Requirements if using stack as standalone
# -----------------------------------------------------------------------------
terraform {
  required_version = ">= 1.0.0"

  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "4.96.0" # October 05, 2022 Release
    }
  }
}

