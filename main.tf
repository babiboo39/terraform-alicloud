resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "alicloud_key_pair" "alicloud_key_pair" {
key_pair_name   = "terraform_test"
public_key      = "${file(var.ssh_key_public)}"
}

resource "alicloud_vpc" "vpc" {
  vpc_name       = "experimentalVPC"
  cidr_block     = "172.16.0.0/12"
}

resource "alicloud_vswitch" "vsw" {
  vpc_id            = alicloud_vpc.vpc.id
  cidr_block        = "172.16.0.0/24"
  zone_id           = "ap-southeast-5a"
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

# resource "alicloud_instance" "experimental" {
#   image_id              = "${data.alicloud_images.default.images.0.id}"
#   internet_charge_type  = "PayByBandwidth"
#   instance_type        = "${data.alicloud_instance_types.c2g4.instance_types.0.id}"
#   system_disk_category = "cloud_efficiency"
#   security_groups      = ["${alicloud_security_group.experimental.id}"]
#   instance_name        = "experimental-instance"
#   vswitch_id           = alicloud_vswitch.vsw.id
# }

resource "alicloud_instance" "default" {
    image_id                   = data.alicloud_images.default.images[0].id
    instance_type              = data.alicloud_instance_types.c2g4.instance_types[0].id
    count                      = 2
    security_groups            = [alicloud_security_group.experimental.id]
    internet_charge_type       = "PayByTraffic"
    internet_max_bandwidth_out = "10"
    instance_charge_type       = "PostPaid"
    system_disk_category       = "cloud_efficiency"
    vswitch_id                 = alicloud_vswitch.vsw.id
    instance_name              = var.instance_name

    password = random_password.password.result

    security_enhancement_strategy = "Deactive"
    key_name = alicloud_key_pair.alicloud_key_pair.key_name
    data_disks {
        name        = "disk1"
        size        = "20"
        category    = "cloud_efficiency"
        description = "disk1"
    }
    tags = {
        role = "works"
        dc   = "ap-southest-5a"
    }
}