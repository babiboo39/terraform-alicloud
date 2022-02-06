resource "alicloud_vpc" "vpc" {
  vpc_name       = "experimentalVPC"
  cidr_block     = "172.16.0.0/12"
}

resource "alicloud_vswitch" "vsw" {
  vpc_id            = alicloud_vpc.vpc.id
  cidr_block        = "172.16.0.0/12"
  zone_id           = "ap-southeast-5a"
}

resource "alicloud_security_group" "experimental" {
  name = "experimental"
  vpc_id = alicloud_vpc.vpc.id
}

data "alicloud_instance_types" "c2g4" {
  cpu_core_count = 2
  memory_size    = 4
}

data "alicloud_images" "default" {
  name_regex  = "^ubuntu"
  most_recent = true
  owners      = "system"
}

resource "alicloud_instance" "experimental" {
  image_id              = "${data.alicloud_images.default.images.0.id}"
  internet_charge_type  = "PayByBandwidth"
  instance_type        = "${data.alicloud_instance_types.c2g4.instance_types.0.id}"
  system_disk_category = "cloud_efficiency"
  security_groups      = ["${alicloud_security_group.experimental.id}"]
  instance_name        = "experimental-instance"
  vswitch_id           = alicloud_vswitch.vsw.id
}