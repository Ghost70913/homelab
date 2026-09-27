#!/bin/bash
# Crea la cartella e il docker-compose per Navidrome (server musicale)
set -e

mkdir -p ~/navidrome/data ~/navidrome/music

cat > ~/navidrome/docker-compose.yml << 'COMPOSE'
services:
  navidrome:
    image: deluan/navidrome:latest
    container_name: navidrome
    user: "1000:1000"
    restart: unless-stopped
    ports:
      - "4533:4533"
    environment:
      ND_SCANSCHEDULE: 1h
      ND_LOGLEVEL: info
      ND_SESSIONTIMEOUT: 24h
      ND_BASEURL: ""
    volumes:
      - ./data:/data
      - ./music:/music:ro
COMPOSE

echo "✅ Creato ~/navidrome/docker-compose.yml"
echo "Avvia con: cd ~/navidrome && docker compose up -d"
