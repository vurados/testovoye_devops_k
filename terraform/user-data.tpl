#cloud-config
growpart:
  mode: auto
  devices: ["/"]
  ignore_growroot_disabled: false

resize_rootfs: noblock

chpasswd:
  expire: false
ssh_pwauth: true
disable_root: false

groups:
  - microservice

users:
  - default
  - name: ansible
    shell: /bin/bash
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    groups: adm,wheel,microservice
    passwd: ${ansible_passwd}
    lock_passwd: false
    ssh_authorized_keys: ${ansible_ssh_keys}
  - name: microservice
    shell: /bin/bash
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    groups: adm,wheel,microservice
    lock_passwd: true
  - name: root
    passwd: ${root_passwd}
    ssh_authorized_keys: ${root_ssh_keys}

timezone: Europe/Moscow

# package_update: true
# Below upgrades packages
# package_upgrade: true

runcmd:
  - [ /etc/rc.d/rc.local.rebootonce ]
