variable "scaling_group_name" {
    default = "autoScalerGroup"
}

variable "instance_name" {
    default = "experimental-instance"
}

variable "ssh_key_public" {
    default     = "~/.ssh/id_rsa.pub"
    description = "Path to the SSH public key for accessing cloud instances. Used for creating keypair."
}

variable "ssh_key_private" {
    default     = "~/.ssh/id_rsa"
    description = "Path to the SSH private key for accessing cloud instances. Used for creating keypair."
}
