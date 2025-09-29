#!/usr/bin/env python3
# Простая реализация HTTP-сервера, который открывает /metrics (Prometheus client)
import os
import subprocess
import time
from prometheus_client import start_http_server, Info

def detect_host_type():
    """
    Возвращает одну из строк: 'container', 'vm', 'physical'.
    Использует несколько эвристик: systemd-detect-virt, /proc/1/cgroup, DMI.
    """
    # 1) systemd-detect-virt
    try:
        p = subprocess.run(['systemd-detect-virt'], capture_output=True, text=True, timeout=1)
        out = p.stdout.strip().lower()
        if p.returncode == 0 and out and out != 'none':
            # systemd-detect-virt сообщает например "kvm", "vmware", "docker", "lxc" и т.д.
            if any(x in out for x in ('docker', 'lxc', 'container', 'podman', 'rkt', 'crun', 'containerd')):
                return 'container'
            else:
                return 'vm'
    except Exception:
        pass

    # 2) /proc/1/cgroup — часто содержит docker, kubepods и т.п.
    try:
        with open('/proc/1/cgroup', 'rt') as f:
            c = f.read().lower()
            if 'docker' in c or 'kubepods' in c or 'containerd' in c or 'lxc' in c:
                return 'container'
    except Exception:
        pass

    # 3) DMI/sys_vendor / product_name обычно содержит 'kvm', 'vmware', 'virtualbox' и т.д.
    try:
        for fn in ('/sys/class/dmi/id/product_name', '/sys/class/dmi/id/sys_vendor', '/sys/class/dmi/id/product_version'):
            if os.path.exists(fn):
                txt = open(fn, 'rt', errors='ignore').read().lower()
                if any(k in txt for k in ('kvm','qemu','vmware','virtualbox','bochs','xen','microsoft', 'amazon')):
                    return 'vm'
    except Exception:
        pass

    # 4) последнее приближение — считаем физическим
    return 'physical'

def main():
    # prometheus metric: один лейбл type с единственным значением 1
    host_type = detect_host_type()
    # host_type_gauge = Gauge('microservice_host_info', 'Host type info for microservice (labels: type)', ['type'])
    # host_type_gauge.labels(type=host_type).set(1)

    host_type_info = Info('Host type', 'Host type info for microservice aaaaaaaa')
    host_type_info.info({'type': host_type})

    # Можно добавить и другие метрики здесь при желании
    server, t = start_http_server(8080)  # слушать на 0.0.0.0:8080
    print(f"Prometheus metrics exposed on http://0.0.0.0:8080 (host type: {host_type})")
    # Поскольку все метрики уже зарегистрированы, просто ждем
    try:
        while True:
            time.sleep(30)
    except KeyboardInterrupt:
        print("Shutting down")
    server.shutdown()
    t.join()

if __name__ == '__main__':
    main()
