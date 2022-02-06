module "autoscale" {
  source = "terraform-alicloud-modules/autoscaling/alicloud"
  // Autoscaling Group
  scaling_group_name = "testAccEssScalingGroup"
  min_size           = 1
  max_size           = 2
  vswitch_ids = [
    alicloud_vswitch.vsw.id,
  ]
  // Autoscaling Configuration
  image_id                   = "${data.alicloud_images.default.images.0.id}"
  instance_types              = ["ecs.t6-c1m2.large"]
  security_group_ids         = ["${alicloud_security_group.experimental.id}"]
  scaling_configuration_name = "testAccEssScalingConfiguration"
  internet_max_bandwidth_out = 1
  instance_name              = "experimental-instance"
  tags = {
    tag1 = "experimental-intance"
    tag2 = "Terraformed"
  }
  force_delete = true
  data_disks = [{
    size     = 20
    category = "cloud_ssd"
    },
    {
      size                 = 20
      category             = "cloud_ssd"
      delete_with_instance = true
  }]
}
