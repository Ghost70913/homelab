#!/bin/bash

# Aggiornamento sistema Debian
echo "=== Aggiornamento sistema Debian ==="

# Controlla se l'utente è root
if [ "$EUID" -ne 0 ]; then
    echo "Errore: esegui lo script come root (sudo ./update.sh)"
    exit 1
fi

echo "[1/3] Aggiornamento lista pacchetti (apt update)..."
apt update

echo ""
echo "[2/3] Aggiornamento pacchetti installati (apt upgrade)..."
apt upgrade -y

echo ""
echo "[3/3] Rimozione pacchetti non più necessari (apt autoremove)..."
apt autoremove -y

echo ""
echo "✅ Sistema aggiornato con successo!"
