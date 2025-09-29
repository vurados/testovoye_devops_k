alma9_cloudinit_disk = "alma9_cloudinit_disk.iso"
alma9_cloudinit_pool = "default"
alma9_domain_memory  = "4096"
alma9_domain_name    = "Golden_Alma_9_5-TF"
alma9_domain_vcpu    = "2"
alma9_name           = "almalinux9"
alma9_network_name   = "default"
alma9_volume_format  = "qcow2"
alma9_volume_name    = "Golden_Alma_9_5-TF.qcow2"
alma9_volume_pool    = "default"
alma9_volume_size    = "32212254720"
alma9_volume_source = "https://repo.almalinux.org/almalinux/9/cloud/x86_64/images/AlmaLinux-9-GenericCloud-latest.x86_64.qcow2"
# alma9_volume_source = "/home/user/Downloads/AlmaLinux-9-GenericCloud-9.6-20250522.x86_64.qcow2"
# password can be generated with:
# echo "test" | mkpasswd -m sha-512 -s
ansible_passwd = "$6$T6g./2x.fLBA4KRO$uSQy6XVsvwccGb.JEaICrPlu7HKnjbDTyG9XtjiaETNaAZ5mnnUZb5qdoF9GGHRIoNQY0pS/OnkTinYfqeFye0"
root_passwd  = "$6$T6g./2x.fLBA4KRO$uSQy6XVsvwccGb.JEaICrPlu7HKnjbDTyG9XtjiaETNaAZ5mnnUZb5qdoF9GGHRIoNQY0pS/OnkTinYfqeFye0"
ansible_ssh_keys = [
]
root_ssh_keys = [
]