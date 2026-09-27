#!/bin/bash
# Aggiornamento del sistema: funziona sia su Rocky/RHEL (dnf) sia su Debian/Ubuntu (apt)

if [ "$EUID" -ne 0 ]; then
    echo "Errore: esegui lo script come root (sudo ./update-system.sh)"
    exit 1
fi

if command -v dnf >/dev/null 2>&1; then
    echo "=== Aggiornamento sistema (dnf) ==="
    echo "[1/2] Aggiornamento pacchetti..."
    dnf upgrade -y
    echo ""
    echo "[2/2] Rimozione pacchetti non più necessari..."
    dnf autoremove -y
elif command -v apt >/dev/null 2>&1; then
    echo "=== Aggiornamento sistema (apt) ==="
    echo "[1/3] Aggiornamento lista pacchetti..."
    apt update
    echo ""
    echo "[2/3] Aggiornamento pacchetti installati..."
    apt upgrade -y
    echo ""
    echo "[3/3] Rimozione pacchetti non più necessari..."
    apt autoremove -y
else
    echo "Errore: gestore pacchetti non supportato (servono dnf o apt)"
    exit 1
fi

echo ""
echo "✅ Sistema aggiornato con successo!"
