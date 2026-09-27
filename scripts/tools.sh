#!/bin/bash
# Menu rapido: ping e gestione della VPN WireGuard (wg0)

echo "*****************************"
echo "1) PING"
echo "2) ESCI"
echo "3) ATTIVA VPN"
echo "4) DISATTIVA VPN"
echo "*****************************"
read -p "Scegli un'opzione: " s

case $s in
    1)
        read -p "IP: " ip
        ping -c 6 "$ip"
        ;;
    2)
        exit 0
        ;;
    3)
        sudo wg-quick up wg0
        ;;
    4)
        sudo wg-quick down wg0
        ;;
    *)
        echo "Opzione non valida"
        exit 1
        ;;
esac
