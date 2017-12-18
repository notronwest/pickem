This repo contains all you need to get Pickem, NFLUnderdog and other applications up and running locally.

The following software is required:
- Linux or MacOS. Windows users: go setup a Linux VM in Virtualbox.
- [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
- [Docker](https://www.docker.com/community-edition#/download)
- [Docker Compose](https://docs.docker.com/compose/install/)

Basic setup
- Lucee server with NGINX configured webserver
- MySQL databse server
- PHP server (handles all of the screen scraping to get games and scores)

Networked drives
- The main directory will be the web directory on the lucee/nginx servers
- The data directory will be where the databse is loaded

### Quick Start

Open a terminal and run the following commands:

```bash
git clone https://github.com/notronwest/pickem.git;
cd pickem;
edit line 4 of docker/nginx/default.conf to match the hostnames you want to use to access the sites (be sure to add hosts entries if needed)
dccomposer install;
docker-compose up -d;
```

After all the commands finish open this URL your browser:
[http://pickem.local:4280/](http://pickem.local:4280/)
