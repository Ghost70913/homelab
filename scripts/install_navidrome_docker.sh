mkdir -p ~/navidrome
cat > ~/navidrome/docker-compose.yml << 'EOF'
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
      - ~/navidrome/data:/data
      - ~/navidrome/music:/music:ro

EOF
