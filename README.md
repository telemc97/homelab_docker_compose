# Homelab
This repository contains the docker-compose configuration for various services hosted in my personal homelab.

## Homelab General Information
The docker server-VM, used for hosting certain services, is only a part of the homelab server machine. The latter is using Proxmox as its OS. <br>
There are 3 main VM that are hosted:

- **OPNsense** As the home router. OPNsense is an open-source, user-friendly firewall and routing platform
- **TrueNas** As a NAS solution. Certain cervices store data in TrueNas shares. eg. Immich, Gitea.
- **Docker Server** A Simple Ubuntu Sever VM running Docker.
- **Ubuntu Server** This is a server mainly for experimentation.

A simple Diagram can be seen in the picture below:

![](img/homelab_simplified.svg)

## Hosted Services:

### [Portainer](https://www.portainer.io)
Portainer is used to manane quickly the different containers.

### [HomeAssistant](https://www.home-assistant.io)
HomeAssistant is used to control smart devices in my home allong with various automations.

### [Gitea](https://about.gitea.com)
Gitea is used as self-hosted version control and code hosting platform.

### [Bookstack](https://www.bookstackapp.com)
Bookmark is used primarly for documentation keeping (for the various homelab-specific projects).

### [Caddy](https://caddyserver.com)
Caddy is a self hosted server solution that is used for exposing certain services like HomeAsssistant to the Internet via reverse proxy.

### [Immich](https://immich.app)
Immich is a self-hosted Google Photos alternative. I am currently using mainly for backing up media.

### [Qbittorent](https://www.qbittorrent.org)
This is a simple torrent client. Hosting it in the homelab gives the ability to access it from any device in the home network and donwload torrents directly to the home NAS.

### [Jenkins]()

## Future Plans
- Addition of another Proxmox node mainly for data backup but also for high availability.
- Implementation of a VPN solution to ease remote development (outside of home network).
- With the a addition of a second node migrating from docker to K8S sould be high priority.

## FAQ

### Question
Why Docker and no Kubernetes.<br>
<br>
**Answer:** <br> 
- Simplicity since there is currenly only one node and no high availability can be achieved.
- Setup time is minimal.
- Simple Networking.
- Lightweight compared to a single node Kubernetes setup.



