variable "enable_telemetry" {
  type        = bool
  default     = false
  description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module.
For more information see <https://aka.ms/avm/telemetryinfo>.
If it is set to false, then no telemetry will be collected.
DESCRIPTION
}

variable "kv_prefix" {
  type        = string
  default     = "kv"
  description = "The prefix to use for the SQL storage account."
}

variable "sql_prefix" {
  type        = string
  default     = "sql"
  description = "The prefix to use for the SQL storage account."
}

variable "standard_prefix" {
  type        = string
  default     = "msft-ptsg-poc"
  description = "The prefix to use for the SQL storage account."
}
