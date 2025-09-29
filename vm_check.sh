#!/usr/bin/env bash
set -euo pipefail

DEFAULT_NET="default"
DEFAULT_POOL="default"
DEFAULT_SUBNET="192.168.122.0/24"
DEFAULT_IP="192.168.122.1"
DEFAULT_MASK="255.255.255.0"

# Проверяем, установлен ли virsh
if ! command -v virsh &>/dev/null; then
    echo "[!] virsh not found. Please install libvirt-client (e.g., 'sudo dnf install libvirt-client' or 'sudo apt install libvirt-clients')."
    exit 1
fi

# Проверка, занята ли подсеть
if ip route | grep -q "$DEFAULT_SUBNET"; then
    echo "[!] Subnet $DEFAULT_SUBNET is already in use on this host!"
    echo "    Please adjust libvirt default network XML to another subnet (e.g. 192.168.123.0/24) or scrpt DEFAULT_SUBNET and DEFAULT_IP."
    exit 1
fi

echo "[*] Проверяю наличие сети '$DEFAULT_NET'..."
if ! virsh -c qemu:///system net-list --all | grep -qE "^ ${DEFAULT_NET} "; then
    echo "[+] Сеть '$DEFAULT_NET' не найдена. Создаю..."
    if [ -f ./${DEFAULT_NET}.xml ]; then
        virsh -c qemu:///system net-define ./${DEFAULT_NET}.xml
    else
        # fallback XML
        cat > /tmp/net-${DEFAULT_NET}.xml <<EOF
<network>
  <name>default</name>
  <forward mode="nat"/>
  <bridge name="virbr0" stp="on" delay="0"/>
  <ip address="192.168.122.1" netmask="255.255.255.0">
    <dhcp>
      <range start="192.168.122.2" end="192.168.122.254"/>
    </dhcp>
  </ip>
</network>
EOF
        virsh -c qemu:///system net-define /tmp/net-${DEFAULT_NET}.xml
    fi
else
    echo "[=] Сеть '$DEFAULT_NET' уже существует."
fi

virsh -c qemu:///system net-start "$DEFAULT_NET" || true

echo "[*] Проверяю наличие storage pool '$DEFAULT_POOL'..."
if ! virsh -c qemu:///system pool-list --all | grep -qE "^ ${DEFAULT_POOL} "; then
    echo "[+] Пул '$DEFAULT_POOL' не найден. Создаю..."
    virsh -c qemu:///system pool-define-as "$DEFAULT_POOL" dir --target /var/lib/libvirt/images
else
    echo "[=] Пул '$DEFAULT_POOL' уже существует."
fi

virsh -c qemu:///system pool-start "$DEFAULT_POOL" || true

echo "[✓] Проверки завершены: сеть и storage pool готовы."
