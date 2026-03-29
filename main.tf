
locals {
  instances = { for k in flatten([
    for inx in range(var.vms) : {
      name : "${var.name}${format("%x", 10 + inx)}"
      region : var.region

      public_id : lookup(try(var.network["public"], {}), "network", "")
      public_subnet_id : lookup(try(var.network["public"], {}), "subnet", "")

      private_network_id : lookup(try(var.network["private"], {}), "network", "")
      ipv4_subnet_id : lookup(try(var.network["private"], {}), "ip4network", "")
      ipv4 : lookup(try(var.network["private"], {}), "ip4subnet", "") != "" ? "${cidrhost(var.network["private"].ip4subnet, var.network["private"].ip4index + inx)}" : ""
      ipv6 : lookup(try(var.network["private"], {}), "ip6subnet", "") != "" ? "${cidrhost(var.network["private"].ip6subnet, var.network["private"].ip6index + inx)}" : ""
    }
  ]) : k.name => k }
}

output "instances" {
  value = local.instances
}

resource "openstack_networking_port_v2" "public" {
  for_each       = local.instances
  region         = each.value.region
  name           = lower(each.value.name)
  network_id     = each.value.public_id
  admin_state_up = true

  security_group_ids = var.firewall_ids

  dynamic "fixed_ip" {
    for_each = each.value.public_subnet_id != "" ? [each.value.public_subnet_id] : []
    content {
      subnet_id = each.value.public_subnet_id
    }
  }
}

resource "openstack_networking_port_v2" "private" {
  for_each       = local.instances
  region         = each.value.region
  name           = lower(each.value.name)
  network_id     = each.value.private_network_id
  admin_state_up = true

  port_security_enabled = false
  fixed_ip {
    subnet_id  = each.value.ipv4_subnet_id
    ip_address = each.value.ipv4 == "" ? null : each.value.ipv4
  }

  extra_dhcp_option {
    name       = "host-name"
    value      = lower(each.value.name)
    ip_version = 4
  }

  lifecycle {
    ignore_changes = [port_security_enabled]
  }
}

resource "openstack_compute_instance_v2" "instances" {
  for_each    = local.instances
  region      = var.region
  name        = each.value.name
  flavor_name = var.type
  tags        = var.tags
  image_id    = var.template_id

  #   scheduler_hints {
  #     group = openstack_compute_servergroup_v2.web[each.value.region].id
  #   }

  network {
    port = openstack_networking_port_v2.public[each.key].id
  }
  network {
    port = openstack_networking_port_v2.private[each.key].id
  }

  user_data = var.cloudinit_userdata

  stop_before_destroy = true
  lifecycle {
    ignore_changes = [flavor_name, image_id, scheduler_hints, user_data]
  }
}
