# DEV_DOC.md — Developer & Architecture Documentation

This document serves as a technical reference guide for developers wishing to set up, build, extend, or debug the Inception containerized infrastructure.

---

## 1. Environment Setup & Prerequisites

### Prerequisites
Before setting up the environment, ensure the host machine matches the following baselines:
* **Operating System**: Linux (preferably Debian Bookworm/Buster inside a Virtual Machine as required by 42, or any modern Unix-like distribution).
* **Core Utilities**: `make`, `docker` and `docker-compose`.
* **Privileges**: The local user must belong to the `docker` group, or commands must be run via `sudo`.

### Domain Name Configuration
The services route traffic based on server names. You must map the evaluation loopback domain to the local localhost IP inside the host's network hosts file (`/etc/hosts`):
```text
127.0.0.1   mapadron.42.fr

```

### Configuration Files & Secrets Management

The project secures architecture patterns through an environment descriptor (`.env`) and externalized sensitive variables (Docker Secrets).

#### A. Docker Secrets

To fully decouple and isolate critical credentials from standard environment variables, developers must declare the following secret files, located at the root of the repo:
 * ./secrets/db_password
 * ./secrets/db_root_password
 * ./secrets/wp_user_password
 * ./secrets/wp_admin_password


At runtime, Docker safely mounts these records into memory-backed temporary files inside the corresponding application container filesystems at `/run/secrets/<secret_name>`. Custom initialization scripts natively read these text fragments to execute database provisioning and WP-CLI administration hooks.

#### B. The `.env` Environment Descriptor

Standard, non-sensitive metadata and structural variables must be declared in a `.env` file at the root level of your project container definition. The mandatory layout schema includes:

```ini
# Database Configuration
MYSQL_DATABASE=
MYSQL_USER=

# Infrastructure Context Variables
DOMAIN_NAME=mapadron.42.fr

# WordPress Application Parameters
WORDPRESS_TITLE=
WORDPRESS_ADMIN=
WORDPRESS_ADMIN_EMAIL=
WORDPRESS_USER=
WORDPRESS_EMAIL=

```

---

## 2. Building and Launching the Project

The project lifecycle is fully orchestrated through a root-level `Makefile`, abstraction layer wrappers, and explicit configuration files.

### Compilation Workflow

To compile and instantiate the system configurations from scratch:

```bash
make up

```

Which creates the data directories and starts the containers by calling `@docker compose -f <filename> up -d --build`

### Teardown & Lifecycle Tasks

* **Halting Background Workers**:
```bash
make down

```


*Suspends all containers securely by executing `docker compose down`.*
* **Complete Cluster Purge**:
```bash
make clean

```


*Triggers standard system teardown, completely destroys all custom networks and caches.*

---

## 3. Container and Volume Management Commands

Developers can interact with the running microservices using the following standard operations:

### Shell Interactivity (Live Debugging)

To attach an active interactive TTY instance directly to specific processes inside running structures:

* **Access NGINX proxy engine**: `docker exec -it nginx bash`
* **Access WordPress runtime core**: `docker exec -it wordpress bash`
* **Access MariaDB backend engine**: `docker exec -it mariadb bash`

### Active Log Streams

To tail diagnostic traces and execution stderr/stdout pipes generated during system interaction:

```bash
docker logs <service_name>

```

### Inspecting Internal Software Bridges

To view container IP addresses, verify internal DNS lookup schemas, or troubleshoot container-to-container routing:

```bash
docker network inspect [network_name]

```

---

## 4. Data Storage and Persistence Layer

Understanding data placement is essential to prevent data loss across standard stack resets or source refactoring cycles.

### Volume Strategy

To achieve absolute data decoupling, storage layout rules abstract the physical host filesystem paths by implementing named **Docker Volumes** rather than hardcoded bind mounts.

There are two primary persistent targets declared globally inside `docker-compose.yml`:

1. **WordPress Source Storage (`wordpress`)**: Holds the complete CMS web-root core distribution, custom assets, media payloads, themes, and configuration parameters. Mounted inside the application space at `/var/www/html`.
2. **MariaDB Persistent Layer (`mariadb`)**: Stores the actual relational binary structures, indices, execution records, system tables, and configurations. Mounted inside the database space at `/var/lib/mysql`.

### Data Lifecycle & Physical Location

* **Host Decoupling**: Docker handles paths automatically on the system host partition (typically deep within system directories like `/var/lib/docker/volumes/`). Developers do not need to manage permissions manually.
* **Persistence Assurance**: Running a simple stop command (`make down` or `docker compose down`) halts runtime compute operations but leaves named volumes completely intact. When you scale or compile the cluster again, containers reattach to these volumes and resume operations seamlessly.
* **Hard Wiping**: Data layers can **only** be erased manually, ensuring absolute protection against accidental data loss during standard development tasks.
