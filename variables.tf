# This is required for most resource modules
variable "naming_suffix" {
  type        = string
  description = "A suffix to append to the names of resources."
  nullable    = false
}

variable "location" {
  type        = string
  description = "The location/region where the resource group will be created."
}
