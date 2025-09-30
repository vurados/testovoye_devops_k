# VM name
variable "alma9_name" {
}

# Qcow2 volume name
variable "alma9_volume_name" {
}

# Pool to locate VM
variable "alma9_volume_pool" {
}

variable "alma9_volume_size" {
}

# Volume format .. Qcow2
variable "alma9_volume_format" {
}

# Which Pool to located cloud-init.iso
variable "alma9_cloudinit_pool" {
}

# Qcow2 cloud-init location
variable "alma9_cloudinit_disk" {
}

# alma linux Qcow2 disk image
variable "alma9_volume_source" {
}
# VM name
variable "alma9_domain_name" {
}

# Vm Memory
variable "alma9_domain_memory" {
}

# VM Cpu count
variable "alma9_domain_vcpu" {
}

# VM Network name
variable "alma9_network_name" {
}

variable "ssh_public_key_path" {
  description = "Path to the SSH public key"
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}

variable "ssh_private_key_path" {
  description = "Path to the SSH private key"
  type        = string
  default     = "~/.ssh/id_ed25519"
}

variable "ansible_passwd" {
  description = "user password"
  type        = string

}
variable "root_passwd" {
  description = "root password"
  type        = string

}