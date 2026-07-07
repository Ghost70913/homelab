#!/bin/bash
set -e

echo "[*] Fermando servizi libvirt..."
sudo systemctl stop libvirtd 2>/dev/null || true
sudo systemctl stop virtqemud 2>/dev/null || true

echo "[*] Forzando spegnimento VM attive..."
for vm in $(sudo virsh list --name 2>/dev/null); do
    echo "  -> Destroying: $vm"
    sudo virsh destroy "$vm" 2>/dev/null || true
done

echo "[*] Killando processi QEMU residui..."
sudo pkill -9 -f qemu-system 2>/dev/null || true
sudo pkill -9 -f qemu-kvm 2>/dev/null || true

echo "[*] Aspettando rilascio risorse..."
sleep 3

echo "[*] Rimuovendo moduli KVM..."
sudo modprobe -r kvm_intel 2>/dev/null || true
sudo modprobe -r kvm_amd 2>/dev/null || true

if sudo modprobe -r kvm 2>/dev/null; then
    echo "[OK] kvm rimosso con successo"
else
    echo "[ERR] kvm ancora in uso. Processi attivi:"
    sudo lsof /dev/kvm 2>/dev/null || fuser /dev/kvm 2>/dev/null
    exit 1
fi

