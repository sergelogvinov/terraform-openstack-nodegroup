# Terraform module for OpenStack Node Group

## Usage Example

```hcl
module "webs" {
  for_each = local.webs

  source = "github.com/sergelogvinov/terraform-openstack-nodegroup"

  region = each.value.region
  name   = "${local.web_prefix}${lower(each.value.region)}"
  vms    = each.value.vms
  type   = each.value.type
  tags   = concat(var.tags, ["web"])

  template_id = each.value.image

  network = {
    "public" = {
      network = local.network_external[each.key].id
    }
  }
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5 |
| <a name="requirement_openstack"></a> [openstack](#requirement\_openstack) | ~> 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_openstack"></a> [openstack](#provider\_openstack) | ~> 3.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [openstack_compute_instance_v2.instances](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/resources/compute_instance_v2) | resource |
| [openstack_networking_port_v2.private](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/resources/networking_port_v2) | resource |
| [openstack_networking_port_v2.public](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/resources/networking_port_v2) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudinit_userdata"></a> [cloudinit\_userdata](#input\_cloudinit\_userdata) | Userdata for cloud-init image | `string` | `""` | no |
| <a name="input_description"></a> [description](#input\_description) | Description | `string` | `""` | no |
| <a name="input_firewall_ids"></a> [firewall\_ids](#input\_firewall\_ids) | IDs of the firewalls | `list(string)` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the VM | `string` | `"group-1"` | no |
| <a name="input_network"></a> [network](#input\_network) | n/a | `map(any)` | `{}` | no |
| <a name="input_placement_group_id"></a> [placement\_group\_id](#input\_placement\_group\_id) | ID of the placement group | `string` | `""` | no |
| <a name="input_region"></a> [region](#input\_region) | OpenStack region name | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to the VM | `list(string)` | `[]` | no |
| <a name="input_template_id"></a> [template\_id](#input\_template\_id) | ID of the template VM | `string` | n/a | yes |
| <a name="input_type"></a> [type](#input\_type) | Type for the VM | `string` | n/a | yes |
| <a name="input_vms"></a> [vms](#input\_vms) | Amount of VMs to create | `number` | `0` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instances"></a> [instances](#output\_instances) | n/a |
<!-- END_TF_DOCS -->