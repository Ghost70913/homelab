#!/bin/bash


echo "*****************************"
echo "1) PING"
echo "2) ESCI"
echo "3) ATTIVA VPN"
echo "4) DISATTIVA VPN"
echo "*****************************"
read -p "Scegli un'opzione: " s

case $s in

1)

	read -p "IP: "  ip

	ping $ip -c 6

	;;


2)

	exit

	;;

3)	sudo wg-quick up wg0

        ;;

4)     sudo wg-quick down wg0

	;;


esac




