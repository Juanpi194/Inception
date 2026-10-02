*This project has been created as part of the 42 curriculum by jvizcain.*

# Inception - 42 Project

## Description

### Project Goal & Overview
The goal of this project is to broaden web administration knowledge by orchestrating a small infrastructure composed of multiple Docker containers. The entire infrastructure is deployment-ready on a local virtual machine using `docker compose`. Every service (NGINX, WordPress, and MariaDB) runs in its own dedicated, isolated container built from scratch utilizing the official installation guidelines for `debian:bookworm`.

### Use of Docker & Project Sources
Docker is utilized to achieve absolute isolation, environment reproducibility, and microservice segregation. The project structure avoids pre-built images from Docker Hub (except for the bare operating system), ensuring that every component is explicitly configured via customized `Dockerfiles`.

The source components included are:
- **NGINX**: The single-entry point to the infrastructure, configured exclusively to accept secure TLSv1.3 connections on port 443, acting as a reverse proxy via FastCGI.
- **WordPress**: Armed with PHP-FPM and automated deployment capabilities using WP-CLI.
- **MariaDB**: The relational database management system storing the persistence layer of the CMS.

### Main Design Choices
1. **Zero Pre-configured Images**: Built strictly on top of custom `Dockerfiles` using `apt-get` for stable script automation.
2. **Automated Initialization Scripts**: Entrypoints configured inside `/usr/local/bin/` to maintain standard Unix file hierarchy, preventing package collisions and guaranteeing hands-free installation.
3. **Optimized Directories (`WORKDIR`)**: Explicit use of `WORKDIR /var/www/html` within the WordPress container to streamline automated commands natively via WP-CLI without relying on long, redundant path flags.

---

### Architectural & Technical Comparisons

#### 1. Virtual Machines vs Docker
* **Virtual Machines (VMs)**: Include a full Guest Operating System, a hypervisor, and virtualized hardware. They are heavily isolated but slow to boot, demanding significant RAM and CPU overhead since every instance duplicates the kernel.
* **Docker**: Containers share the Host OS kernel and isolate applications at the process level using Linux namespaces and cgroups. They are extremely lightweight, boot instantly, and consume minimal resources.

#### 2. Secrets vs Environment Variables
* **Environment Variables**: Injected in plain text into the container environment. Anyone with access to the host or runtime can run `docker inspect` or peek at the process table to view sensitive credentials.
* **Docker Secrets**: Mounted directly into a secure memory-based temporary file system (`/run/secrets/`) inside the container. This prevents passwords from leaking into system logs, image layers, or environment prints, fulfilling strict security baselines.

#### 3. Docker Network vs Host Network
* **Host Network**: Removes network isolation between the container and the Docker host, making the container share the host’s IP and ports directly.
* **Docker Network (Bridge)**: Creates an isolated internal software bridge where containers communicate using an internal DNS server via service names (e.g., NGINX routes PHP requests to `wordpress:9000`). Only explicitly exposed ports (such as NGINX's port 443) are accessible from the host, keeping internal traffic completely private.

#### 4. Docker Volumes vs Bind Mounts
* **Bind Mounts**: Depend directly on the directory structure and permissions of the host machine. A specific path on the host is mapped to the container, which couples the deployment to the host's file system layout.
* **Docker Volumes**: Fully managed by Docker daemon storage policies. They abstract host file paths entirely, handle permissions automatically, and ensure safe, persistent storage for MariaDB databases and WordPress source files regardless of host layout changes.

---

## Instructions

### Compilation & Installation
To compile, build, and deploy the entire infrastructure from scratch, make sure you have `docker` and `docker-compose` installed.

Clone the repository and run the setup rule from the Makefile:
```bash
make up

```

*(This command automatically sets up host local domains, configurations, and triggers `docker compose up --build -d`)*

### Execution & Verification

Once the cluster is running, you can test system isolation and TLS compliance.

1. **Verify secure connection (HTTPS)**:
```bash
curl -Ik https://jvizcain.42.fr
# Expected output: HTTP/1.1 200 OK

```


2. **Verify non-secure connection is dropped (HTTP)**:
```bash
curl -Ik http://jvizcain.42.fr
# Expected output: Could not connect to server / Connection refused

```


3. **Verify Database population**:
To inspect tables and confirm WP-CLI fully installed the site autonomously:
```bash
docker exec -it mariadb mariadb -u [user] -p

```


### Stopping the Infrastructure

To safely dismantle the containers and clean up the environment without destroying persistent volumes:

```bash
make down

```

To perform a full system wipe:

```bash
make clean

```

Note: data volumes need to be deleated manually.

---

## Resources

### Classic Documentation & References

* [Official Docker Documentation](https://docs.docker.com/)
* [Debian Bookworm Package Repositories](https://www.debian.org/distrib/packages)
* [WordPress CLI (WP-CLI) Handbook](https://make.wordpress.org/cli/handbook/)
* [NGINX Reverse Proxy & FastCGI Configuration Guide](https://nginx.org/en/docs/)
* [Official Mariadb Documentation](https://mariadb.com/docs)

### AI Usage Description

Artificial Intelligence was used as an interactive support throughout the architectural phase of this project, which provided me with technical documentation for the proyect as well as explained doubts regardint this documentation.