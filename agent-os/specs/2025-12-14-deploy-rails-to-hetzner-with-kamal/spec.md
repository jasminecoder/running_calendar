# Specification: Deploy Rails to Hetzner with Kamal

## Goal

Deploy the Running Calendar Rails application to a Hetzner Cloud VPS using Kamal, establishing production infrastructure with PostgreSQL, SSL via Let's Encrypt, and essential security hardening.

## User Stories

- As a developer, I want to deploy the Rails app to production so that users can access mxcorre.com
- As a developer, I want automated SSL certificates so that the site is secure without manual renewal

## Specific Requirements

**Hetzner Cloud Server Provisioning**
- Create new Hetzner Cloud VPS: CX23 (2 vCPU, 4GB RAM, 40GB NVMe SSD, ~$3.49/month). Guide the developer step by step to buy this product and set it up.
- Select datacenter location closest to Northern Baja California users (Hillsboro, Oregon recommended)
- Use Ubuntu 24.04 LTS as operating system for Docker compatibility. Guide developer on each step of this process.
- Add SSH key during server creation for secure access. Guide developer on each step of this process.
- Document the server's public IP address for DNS and Kamal configuration

**GitHub Container Registry Setup**
- Use ghcr.io as container registry instead of Docker Hub
- Create GitHub Personal Access Token with `write:packages` and `read:packages` scopes
- Image naming convention: `ghcr.io/<github-username>/running_calendar`
- Store PAT securely for use in `.kamal/secrets` as `KAMAL_REGISTRY_PASSWORD`

**Kamal Configuration Updates**
- Update `config/deploy.yml` with Hetzner server IP address in `servers.web` array
- Configure registry section for ghcr.io with username and password reference
- Enable proxy/SSL section with `ssl: true` and `host: mxcorre.com`
- Set `DB_HOST: running_calendar-db` environment variable for PostgreSQL accessory
- Keep existing `SOLID_QUEUE_IN_PUMA: true` configuration for background jobs

**PostgreSQL Database Accessory**
- Configure PostgreSQL 16 as Kamal accessory in `config/deploy.yml`. Guide developer on each step of the configuration.
- Use official `postgres:16` Docker image
- Expose port 5432 only to localhost (`127.0.0.1:5432:5432`)
- Mount persistent volume for data: `running_calendar_postgres:/var/lib/postgresql/data`
- Set `POSTGRES_PASSWORD` and `POSTGRES_DB` via secrets

**Cloudflare DNS and SSL Configuration**
- Create A record pointing `mxcorre.com` to Hetzner server IP
- Create A record pointing `www.mxcorre.com` to same IP (or CNAME to root)
- Set SSL/TLS encryption mode to "Full (strict)" in Cloudflare dashboard. Guide developer on each step of this process.
- Traefik handles Let's Encrypt certificate acquisition automatically
- Enable `config.assume_ssl` and `config.force_ssl` in `production.rb`

**Server Security Hardening**
- Install and configure UFW firewall: allow SSH (22), HTTP (80), HTTPS (443). Guide developer on each step of this process.
- Install fail2ban with default SSH jail configuration. Guide developer on each step of this process.
- Disable password authentication for SSH (key-only access)
- Docker runs Rails app as non-root user (already configured in Dockerfile)
- Server runs Docker as root but application containers are unprivileged

**Database Backup Strategy**
- Create daily PostgreSQL backup script using `pg_dump` inside Docker container
- Store backups in `/opt/backups/postgres/` with date-stamped filenames
- Configure cron job to run backup daily at 3:00 AM server time
- Retain last 7 daily backups with automatic rotation
- Document manual backup and restore procedures

**Secrets Management**
- Update `.kamal/secrets` to fetch `KAMAL_REGISTRY_PASSWORD` from environment
- Ensure `RAILS_MASTER_KEY` extraction from `config/master.key` remains in place
- Add `POSTGRES_PASSWORD` secret for database accessory
- Never commit secrets or master.key to version control

**Deployment Workflow**
- Initial deployment: `kamal setup` to bootstrap server with Docker and Kamal proxy
- Subsequent deployments: `kamal deploy` from local development machine
- Use `kamal console` alias for Rails console access
- Use `kamal logs` alias for tailing application logs
- Database migrations run automatically via `bin/docker-entrypoint` on deploy

## Existing Code to Leverage

**`config/deploy.yml`**
- Base Kamal configuration with service name `running_calendar` already defined
- Storage volume `running_calendar_storage:/rails/storage` for Active Storage
- Aliases for console, shell, logs, and dbconsole already configured
- Builder set to `amd64` architecture matching Hetzner servers
- Proxy/SSL section present but commented out, ready to enable

**`Dockerfile`**
- Production-ready multi-stage build requiring no modifications
- Non-root rails user (UID 1000) already configured for security
- PostgreSQL client already installed for database connectivity
- Jemalloc enabled for memory optimization
- Thruster handles HTTP serving via `bin/thrust`

**`.kamal/secrets`**
- Template for extracting `RAILS_MASTER_KEY` from config/master.key exists
- Pattern for `KAMAL_REGISTRY_PASSWORD` shown in comments
- Secrets file structure established and git-safe

**`bin/docker-entrypoint`**
- Automatically runs `db:prepare` before starting Rails server
- Handles database creation and migrations on each deploy
- No modifications needed for PostgreSQL deployment

**`agent-os/standards/global/deployment.md`**
- Documents Kamal deployment commands: setup, deploy, rollback
- Shows pattern for running migrations via `kamal app exec`
- Establishes convention for health checks at `/up` endpoint

## Out of Scope
- Staging environment setup (production only for MVP)
- Log aggregation services (use `kamal logs` for now)
- Redis/Valkey setup (Solid Queue runs in Puma process)
- CDN configuration beyond Cloudflare defaults
- Multiple environment configurations (staging, review apps)
- Automated security scanning or penetration testing
