# 🚀 INCEPTION PROJECT

Welcome to **INCEPTION** — a **Dockerized WordPress setup** running with **Nginx** and **MariaDB**, secured via SSL, and fully configurable via environment and secret files.

---

## 📌 Before You Start

After using `make` / `make all`:

- ✏️ **Configure** the `.env` file in the `srcs/` directory.
- 🔐 **Configure** the `.txt` files in the `secrets/` directory.
Replace `<value>` with your desired values.

After that, you can use `make help` to explore the available options!

---

## 🧠 Info

This project sets up:

- 🌐 A **WordPress** site (blue)
- 🛢️ A **MariaDB** database (pink)
- 🔐 A **secure Nginx** frontend (green)

Each service runs in its own **Docker container**, connected via Docker network. Containers receive:

- 📄 Environment variables from `srcs/.env` (cyan)
- 🔒 Secrets from `secrets/*.txt` (red)
- 🛠️ Necessary configuration files

### 🔹 Nginx
- Front-end entry point at **https://localhost:443**
- Secured via **SSL** with `.crt` and `.key` stored in `secrets/`
- Has access to the **volume** where the page is stored
- Serves HTML and forwards PHP requests to the WordPress container on port `9000`

### 🔷 WordPress
- Serves the PHP content
- Accepts requests from Nginx and responds via **FastCGI**
- Stores files in a **shared volume**
- On setup:
  - Creates a database in the MariaDB container
  - Adds a new user to the database
- Communicates with MariaDB on port `3306`

### 🟣 MariaDB
- Stores the WordPress database
- Has access to the shared **volume**

---

## ⚙️ Configuration Files

### 🛑 `secrets/`
Stores sensitive info, using Docker Compose secrets functionality for security.

### 🔧 `srcs/.env`
Contains non-sensitive environment variables shared across containers.

---

## 📄 Modifiable Values

### `secrets/*.txt`
| Key           | Description                               |
|---------------|-------------------------------------------|
| `DB_PWD`      | MariaDB user password                     |
| `WP_ADMIN_E`  | WordPress admin email                     |
| `WP_ADMIN_N`  | WordPress admin username                  |
| `WP_ADMIN_P`  | WordPress admin password                  |
| `WP_USER_P`   | WordPress regular user password           |

### `srcs/.env`
| Key           | Description                               |
|---------------|-------------------------------------------|
| `DB_USER`     | MariaDB user name                         |
| `DB_NAME`     | MariaDB database name                     |
| `DOMAIN_N`    | Website domain name                       |
| `WP_TITLE`    | WordPress site title                      |
| `WP_USER_N`   | WordPress regular user name               |
| `WP_USER_E`   | WordPress regular user email              |
| `WP_USER_R`   | WordPress regular user role               |

---

## 🛠️ Makefile Options

Run `make <target>` to execute:

| Target   | Description |
|----------|-------------|
| `all`    | Displays the intro message and creates the `secrets/*.txt` and `srcs/.env` files |
| `up`     | Builds and launches all containers in detached mode (`localhost:443`) |
| `debug`  | Like `up`, but with logs shown live in the terminal |
| `down`   | Stops all running containers |
| `info`   | Displays project information |
| `value`  | Describes all modifiable values |
| `help`   | Lists all available make options |
| `access` | Enters the container specified in the `$CONTAINER` environment variable |
| `clean`  | Removes containers and images (keeps volumes, `secrets/`, and `.env`) |
| `vlean`  | Removes the Docker volumes |
| `fclean` | Runs `clean` and also deletes volumes, `secrets/`, and `.env` |
| `re`     | Runs `clean` and `up` again |

---

## ✅ Final Notes

- All configurations are modular and **easily modifiable** via text files.
- Designed for **security**, **clarity**, and **educational use** as part of the **Inception project**.

---
🛠️ Built with ❤️ using Docker, Nginx, WordPress, and MariaDB.
