# 🏠 Homelab

Raccolta delle configurazioni Docker e degli script Bash del mio homelab personale,
che uso per sperimentare e approfondire tecnologie DevOps, di sicurezza e di monitoraggio.

## 🧱 Infrastruttura
- **OS:** Rocky Linux
- **Container:** Docker & Docker Compose
- **Accesso remoto:** VPN WireGuard / Tailscale

## 📦 Servizi

| Servizio | Cartella | Descrizione | Porta |
|----------|----------|-------------|-------|
| CrowdSec | `crowdsec/` | Sicurezza e protezione dalle intrusioni (analisi log SSH/Nginx) | 8081 (solo localhost) |
| Uptime Kuma + ntfy | `kuma/` | Monitoraggio dei servizi con notifiche push | 3001 / 8080 |
| Portainer | `portainer/` | Gestione dei container via web | 9443 |

## 🛠️ Script

| Script | Descrizione |
|--------|-------------|
| `scripts/update-system.sh` | Aggiornamento del sistema (supporta dnf e apt) |
| `scripts/tools.sh` | Menu rapido: ping e attivazione/disattivazione VPN WireGuard |
| `scripts/veeam_telegram_notify.sh` | Notifica Telegram al termine dei job di Veeam Agent for Linux |
| `scripts/install_navidrome_docker.sh` | Preparazione del server musicale Navidrome in Docker |

## 🚀 Avvio di un servizio

```bash
cd kuma
docker compose up -d
```

## 🔐 Sicurezza
- Password e token non sono salvati nel repository: si trovano in file di configurazione
  locali (es. `telegram.conf` per lo script Veeam), esclusi tramite `.gitignore`.
- Le API interne (es. CrowdSec LAPI) sono esposte solo su `127.0.0.1`.

## 📝 Note
Configurazioni per uso personale e apprendimento.
