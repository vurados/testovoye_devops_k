# Defining VM Volume
resource "libvirt_volume" "alma9_qcow2" {
  name   = var.alma9_volume_name
  pool   = var.alma9_volume_pool
  source = var.alma9_volume_source
  format = var.alma9_volume_format
}

data "template_file" "user_data" {
  template = file("${path.module}/user-data.tpl")
  vars = {
    ansible_ssh_keys = jsonencode(var.ansible_ssh_keys)
    root_ssh_keys = jsonencode(var.root_ssh_keys)
    ansible_passwd = var.ansible_passwd
    root_passwd = var.root_passwd
  }
}

data "template_file" "meta_data" {
  template = file("${path.module}/meta-data.tpl")
  vars = {
    instance-id    = "${var.alma9_name}"
    local-hostname = "${var.alma9_name}"
  }
}

resource "libvirt_cloudinit_disk" "alma9_cloudinit_disk" {
  name      = var.alma9_cloudinit_disk
  pool      = var.alma9_cloudinit_pool
  user_data = data.template_file.user_data.rendered
  meta_data = data.template_file.meta_data.rendered
}

resource "libvirt_domain" "alma9" {
  name       = var.alma9_domain_name
  memory     = var.alma9_domain_memory
  vcpu       = var.alma9_domain_vcpu
  # qemu_agent = true

  network_interface {
    network_name = var.alma9_network_name
    wait_for_lease = true
  }

  disk {
    volume_id = libvirt_volume.alma9_qcow2.id
  }

  cloudinit = libvirt_cloudinit_disk.alma9_cloudinit_disk.id

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "0"
  }

  cpu {
    mode = "host-passthrough"
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}

output "vm_ip" {
  value = libvirt_domain.alma9.network_interface.0.addresses.0
}

output "ansible_inventory" {
  value = <<EOT
[vm]
${libvirt_domain.alma9.network_interface.0.addresses.0} ansible_user=ansible ansible_ssh_private_key_file=~/.ssh/id_ed25519 ansible_python_interpreter=/usr/bin/python3
EOT
}