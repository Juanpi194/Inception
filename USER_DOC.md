# USER_DOC.md — User & Administrator Documentation

This document explains, in simple terms, how to interact with, manage, and verify the Inception infrastructure.

---

## 1. Provided Services Overview

The infrastructure orchestrates a containerized web deployment stack composed of three core services working seamlessly together:

* **Web Server (NGINX)**: Acts as the secure single-entry gateway to the entire stack. It intercepts web traffic, enforces HTTPS security parameters (TLSv1.3), serves static file assets, and securely acts as a reverse proxy passing script tasks down to WordPress.
* **Application Server (WordPress)**: Runs the PHP-FPM processor that executes the core logic of the WordPress CMS. It renders the webpage content dynamically and interacts directly with the database layer.
* **Database Engine (MariaDB)**: A relational database management system that securely holds all structural data, relational tables, posts, configuration entries, and user accounts for the CMS.

---

## 2. Starting and Stopping the Project

The lifetime of the container cluster is managed via the project root `Makefile` wrappers over Docker commands:

* **To Launch the Cluster**:
    ```bash
    make up
    ```
    *This builds the necessary image recipes from scratch, configures local networking/storage structures, and spins up the environment in detached (background) mode.*

* **To Stop the Cluster**:
    ```bash
    make down
    ```
    *This gracefully halts and removes running service instances without modifying data persisted inside the storage volumes.*

* **To Fully Reset the Cluster**:
    ```bash
    make clean
    ```
    *Stops all services and performs a complete infrastructure wipe, cleaning out networks and custom image caches.*

---

## 3. Accessing the Website and Administration Panel

Before attempting access, ensure that the hostname domain configuration points to your local machine inside your host's loopback system file (`/etc/hosts`).

* **Main Website Endpoint**:
    Open your browser and navigate to:
    `https://mapadron.42.fr`
    *(You will find the active WordPress home layout populated by automated scripts).*

* **CMS Administration Dashboard**:
    To manage the site contents, customize templates, or monitor plugins via the GUI panel, go to:
    `https://mapadron.42.fr/wp-admin`
    *(Log in using the administrator credentials described below).*

---

## 4. Locating and Managing Credentials

To comply with high-security guidelines, credentials are not hardcoded into scripts or visible in plain text environment outputs.

* **Credential Storage Location**: Look inside the project configuration structure for the designated `.env` file or mapping rules targeted at `/run/secrets/` inside the running containers. These temporary, memory-safe locations prevent data leaks into the repository or runtime diagnostic checks.
* **Inspecting WordPress Credentials natively**: If you need to view or check administrative user records securely inside the application layer without entering a GUI, you can run:
    ```bash
    docker exec -it wordpress wp user list --path=/var/www/html
    ```

---

## 5. Checking Service Health and Status

As an administrator, you can run several verification checks to ensure everything is running exactly as intended:

### A. General Cluster Status
To verify that all containers are active, running (`Up`), and mapping the correct ports:
```bash
docker compose ps

```

### B. Network & Security Compliance Checks

Verify that the server accepts secure traffic and drops insecure requests using the following terminal commands:

* **HTTPS Compliance** *(Should connect successfully with HTTP 200)*:
```bash
curl -Ik https://mapadron.42.fr

```


* **HTTP Shielding** *(Should be refused or dropped instantly)*:
```bash
curl -Ik http://mapadron.42.fr

```



### C. Database Persistence Layer Check

To ensure the database layer is initialized, populated with relational tables, and actively linked to the CMS application:

```bash
docker exec -it mariadb mariadb -u[user] -p

```

// -----------------------------------------------
ADD THIS TO /etc/hosts: 127.0.0.1   jvizcain.42.fr
AND THIS:

# Crear la carpeta de secretos si no existe
mkdir -p srcs/secrets

# Crear cada archivo de contraseña (sin saltos de línea)
echo -n "db_password_123" > srcs/secrets/db_password
echo -n "admin_password_123" > srcs/secrets/wp_admin_password
echo -n "user_password_123" > srcs/secrets/wp_user_password


// ----------------------------------------------
Checking ports command:
curl -vk https://127.0.0.1:x (Replace x with the command number)
