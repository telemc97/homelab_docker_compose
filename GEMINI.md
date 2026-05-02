# Homelab Docker Compose Project

## Project Overview
This repository contains a collection of Docker Compose configurations used for managing a personal homelab. The homelab is structured as a series of virtual machines on a Proxmox host, with this repository specifically targeting the **Docker Server VM** (Ubuntu Server).

The project is organized into service-specific directories, each containing its own `docker-compose.yaml` file and associated configurations (like Dockerfiles for custom builds).

### Main Technologies
- **Docker & Docker Compose**: Primary orchestration tools.
- **Caddy**: Reverse proxy with a custom build (including DuckDNS plugin) for automated SSL via DNS challenges.
- **Jenkins**: CI/CD controller with specialized agents for:
    - Infrastructure (Terraform, Ansible)
    - Development (C++, CMake, GCC)
    - Documentation (LaTeX)
- **Home Automation**: Home Assistant (running in host network mode), Zigbee2MQTT, and Mosquitto.
- **Media Stack**: Integrated suite (Jellyfin, Sonarr, Radarr, etc.) routed through a Gluetun VPN.
- **Services**: Immich (Photos), Gitea (Git), Vaultwarden (Passwords), Bookstack (Documentation), AI Tools (Open WebUI), etc.

## Directory Structure
- `ai_tools/`: Open WebUI and other AI-related tools.
- `bookstack/`: Bookstack documentation platform.
- `caddy/`: Caddy reverse proxy with custom `xcaddy` build.
- `frigate/`: Frigate NVR for security cameras.
- `gitea/`: Gitea self-hosted Git service.
- `home_stack/`: Home Assistant, Zigbee2MQTT, and Mosquitto.
- `immich/`: Immich photo/video management solution.
- `jenkins/`: Jenkins controller and specialized agents (`agent_0`, `agent_1`, `agent_2`).
- `media_stack/`: Full media automation suite (Jellyfin, Arrs, qBit) with Gluetun VPN.
- `qbittorent/`: Independent qBittorrent client (legacy/secondary).
- `utils/`: Miscellaneous utility services.
- `vaultwarden/`: Vaultwarden (formerly Bitwarden) password manager.

## Building and Running

### General Usage
To start a service, navigate to its directory and use:
```bash
docker-compose up -d
```
*Note: Ensure you have a `.env` file in the service directory with the required variables (ports, paths, subnets, etc.) as they are ignored by Git.*

### Custom Builds
Some services require a build step before they can be started:
- **Caddy**: Custom build with DuckDNS plugin.
  ```bash
  cd caddy && docker-compose build
  ```
- **Jenkins**: Custom controller (with plugins/Docker CLI) and specialized agents.
  ```bash
  cd jenkins && docker-compose build
  ```

## Development & Configuration Conventions

### Environment Variables
- Extensive use of environment variables (`${VAR_NAME}`) in `docker-compose` files.
- Each service directory should have its own local `.env` file (globally ignored by `.gitignore`).
- Common variables include `SUBNET`, `IPV4_ADDRESS`, `WEBUI_PORT`, and paths for data persistence.

### Persistence
- Persistent data is typically mapped to a path defined by a `${BASE_PATH}` variable (formerly `/opt/<service_name>`).
- Databases (PostgreSQL, Redis) are usually defined alongside their main service in the same compose file.

### Networking
- Custom Docker networks are defined with specific subnets (e.g., `${SUBNET}`).
- Static IP addresses are often assigned to key services (e.g., Caddy, Zigbee2MQTT, Mosquitto) for consistent internal routing.
- Home Assistant uses `network_mode: host` for better device discovery.

### Custom Dockerfiles
- **Caddy**: Uses a multi-stage build with `caddy:builder` and `xcaddy`.
- **Jenkins Controller**: Installs Docker CLI and common plugins (`blueocean`, `docker-workflow`).
- **Jenkins Agents**: Custom builds for Terraform, Ansible, C++, and LaTeX tasks.

## Maintenance
- **Updating**: Most services use specific version tags (e.g., `image: docker.gitea.com/gitea:1.25.4`) or `stable` tags.
- **Backups**: As mentioned in `README.md`, data is often stored on TrueNAS shares, facilitating external backups.
