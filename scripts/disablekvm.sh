#!/bin/bash
sudo systemctl stop libvirtd 2>/dev/null
sudo systemctl stop virtqemud 2>/dev/null

sudo modprobe -r kvm_intel 2>/dev/null || true
sudo modprobe -r kvm_amd 2>/dev/null || true
sudo modprobe -r kvm

