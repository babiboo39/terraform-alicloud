output "ecs_ids" {
    value = join(",", alicloud_instance.default.*.id)
}

output "ecs_public_ip" {
    value = join(",", alicloud_instance.default.*.public_ip)
}

output "password" {
    value = random_password.password.result
    sensitive = true
}