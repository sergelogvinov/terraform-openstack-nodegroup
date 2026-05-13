
variable "region" {
  description = "OpenStack region name"
  type        = string
}

variable "vms" {
  description = "Amount of VMs to create"
  type        = number
  default     = 0
}

variable "name" {
  description = "Name of the VM"
  type        = string
  default     = "group-1"
}

variable "description" {
  description = "Description"
  type        = string
  default     = ""
}

variable "type" {
  description = "Type for the VM"
  type        = string
}

variable "template_id" {
  description = "ID of the template VM"
  type        = string
}

variable "firewall_ids" {
  description = "IDs of the firewalls"
  type        = list(string)
  default     = []
}

variable "placement_group_policies" {
  description = "Policies for the placement group"
  type        = list(string)
  default     = []
}

variable "network" {
  type = map(any)
  default = {
    # "public" = {
    #   network   = var.network_id
    #   ip6subnet = var.subnet_id
    #   ip6       = true
    #   ip4subnet = var.subnet_id
    #   ip4       = true
    # }
    # "private" = {
    #   network    = var.network_id
    #   ip4        = ""
    #   ip4network = var.subnet_id
    #   ip4subnet  = "192.168.0.0/28"
    #   ip4mask    = 24
    #   ip4index   = 30
    # }
  }
}

variable "cloudinit_userdata" {
  description = "Userdata for cloud-init image"
  type        = string
  sensitive   = true
  default     = ""
}

variable "tags" {
  description = "Tags to be applied to the VM"
  type        = list(string)
  default     = []
}
