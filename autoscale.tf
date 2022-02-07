resource "alicloud_ess_scaling_group" "default" {
  min_size           = 0
  max_size           = 2
  scaling_group_name = var.scaling_group_name
  removal_policies   = ["OldestInstance", "NewestInstance"]
  vswitch_ids        = [alicloud_vswitch.vsw.id]
}

resource "alicloud_ess_scaling_configuration" "default" {
  scaling_group_id  = alicloud_ess_scaling_group.default.id
  image_id          = data.alicloud_images.default.images[0].id
  instance_type     = data.alicloud_instance_types.c2g4.instance_types[0].id
  security_group_id = alicloud_security_group.experimental.id
  force_delete      = true
  active            = true
  enable            = true
}

resource "alicloud_ess_attachment" "default" {
  scaling_group_id = alicloud_ess_scaling_group.default.id
  instance_ids     = [alicloud_instance.default[0].id, alicloud_instance.default[1].id]
  force            = true
}
