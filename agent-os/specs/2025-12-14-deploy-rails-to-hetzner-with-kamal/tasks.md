# Task Breakdown: Deploy Rails to Hetzner with Kamal

## Overview
Total Tasks: 32 sub-tasks across 6 task groups

This deployment spec establishes production infrastructure for the Running Calendar Rails application. The task groups are organized by specialization and dependency order, progressing from infrastructure provisioning through configuration, security, and final deployment verification.

## Task List

### Infrastructure Layer

#### Task Group 1: Hetzner Cloud Server Provisioning
**Dependencies:** None

- [x] 1.0 Complete Hetzner server provisioning
  - [x] 1.1 Create Hetzner Cloud account and project
    - Navigate to https://console.hetzner.cloud/
    - Create new project named "running-calendar"
    - Add payment method for billing
  - [x] 1.2 Generate SSH key for server access
    - Check for existing key: `ls -la ~/.ssh/id_ed25519.pub`
    - If needed, generate new key: `ssh-keygen -t ed25519 -C "your-email@example.com"`
    - Copy public key content for Hetzner
  - [x] 1.3 Create CX23 VPS instance
    - Select "Add Server" in Hetzner Cloud Console
    - Location: Nuremberg, Germany
    - Image: Ubuntu 24.04 LTS
    - Type: CX23 (2 vCPU, 4GB RAM, 40GB NVMe SSD, ~$3.49/month)
    - SSH Key: Add the public key from step 1.2
    - Name: `running-calendar-prod`
  - [x] 1.4 Document server IP address
    - Record the public IPv4 address from Hetzner dashboard
    - Save IP for use in DNS and Kamal configuration
  - [x] 1.5 Verify SSH connectivity
    - Test connection: `ssh root@<server-ip>`
    - Confirm successful login without password prompt

**Acceptance Criteria:**
- CX23 server is running in Nuremberg datacenter
- SSH key authentication works
- Server public IP is documented

---

#### Task Group 2: GitHub Container Registry Setup
**Dependencies:** None (can run in parallel with Task Group 1)

- [x] 2.0 Complete GitHub Container Registry configuration
  - [x] 2.1 Create GitHub Personal Access Token
    - Navigate to GitHub Settings > Developer settings > Personal access tokens > Tokens (classic)
    - Generate new token with scopes: `write:packages`, `read:packages`
    - Set expiration (recommend 90 days or longer)
    - Copy token value immediately (shown only once)
  - [x] 2.2 Store PAT in local environment
    - Add to shell profile (`~/.zshrc` or `~/.bashrc`):
      ```bash
      export KAMAL_REGISTRY_PASSWORD="ghp_your_token_here"
      ```
    - Reload shell: `source ~/.zshrc`
  - [x] 2.3 Verify Docker login to ghcr.io
    - Test authentication: `echo $KAMAL_REGISTRY_PASSWORD | docker login ghcr.io -u <github-username> --password-stdin`
    - Confirm "Login Succeeded" message

**Acceptance Criteria:**
- GitHub PAT created with correct scopes
- PAT stored securely in environment variable
- Docker can authenticate to ghcr.io

---

### Server Configuration Layer

#### Task Group 3: Server Security Hardening
**Dependencies:** Task Group 1

- [x] 3.0 Complete server security configuration
  - [x] 3.1 Connect to server and update system
    - SSH into server: `ssh root@<server-ip>`
    - Update packages: `apt update && apt upgrade -y`
  - [x] 3.2 Configure UFW firewall
    - Install UFW: `apt install ufw -y`
    - Set default policies: `ufw default deny incoming && ufw default allow outgoing`
    - Allow SSH: `ufw allow 22/tcp`
    - Allow HTTP: `ufw allow 80/tcp`
    - Allow HTTPS: `ufw allow 443/tcp`
    - Enable firewall: `ufw enable`
    - Verify status: `ufw status verbose`
  - [x] 3.3 Install and configure fail2ban
    - Install: `apt install fail2ban -y`
    - Create local config: `cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local`
    - Verify SSH jail is enabled: `sudo cat /etc/fail2ban/jail.local | grep -A2 "\[sshd\]"`
    - Start service: `systemctl enable fail2ban && systemctl start fail2ban`
    - Check status: `fail2ban-client status sshd`
  - [x] 3.4 Disable SSH password authentication
    - Edit: `nano /etc/ssh/sshd_config`
    - Set: `PasswordAuthentication no`
    - Set: `PubkeyAuthentication yes`
    - Restart SSH: `systemctl restart ssh`
    - Test new SSH connection in separate terminal before closing current session

**Acceptance Criteria:**
- UFW firewall active with only ports 22, 80, 443 open
- fail2ban running with SSH jail enabled
- Password authentication disabled for SSH

---

### Application Configuration Layer

#### Task Group 4: Kamal and Rails Configuration
**Dependencies:** Task Groups 1, 2

- [x] 4.0 Complete Kamal configuration for production
  - [x] 4.1 Update `.kamal/secrets` with registry password
    - Edit file: `/Users/jasminereitano/dev/running_calendar/.kamal/secrets`
    - Add line: `KAMAL_REGISTRY_PASSWORD=$KAMAL_REGISTRY_PASSWORD`
    - Add line: `POSTGRES_PASSWORD=$(openssl rand -hex 32)`
    - Verify `RAILS_MASTER_KEY` extraction remains: `RAILS_MASTER_KEY=$(cat config/master.key)`
  - [x] 4.2 Update `config/deploy.yml` with server IP
    - Edit file: `/Users/jasminereitano/dev/running_calendar/config/deploy.yml`
    - Update `servers.web` array with Hetzner server IP
  - [x] 4.3 Configure ghcr.io registry in `config/deploy.yml`
    - Set registry server: `ghcr.io`
    - Set username: `<github-username>`
    - Set password reference: `- KAMAL_REGISTRY_PASSWORD`
  - [x] 4.4 Enable proxy/SSL configuration in `config/deploy.yml`
    - Uncomment proxy section
    - Set `ssl: true`
    - Set `host: mxcorre.com`
  - [x] 4.5 Configure PostgreSQL accessory in `config/deploy.yml`
    - Add `db` accessory with `postgres:16` image
    - Set host to Hetzner server IP
    - Set port mapping: `127.0.0.1:5432:5432`
    - Add environment secrets: `POSTGRES_PASSWORD`, `POSTGRES_DB`
    - Configure volume: `running_calendar_postgres:/var/lib/postgresql/data`
  - [x] 4.6 Add DB_HOST environment variable
    - In `env.clear` section, add: `DB_HOST: running_calendar-db`
  - [x] 4.7 Update Rails production configuration
    - Edit file: `/Users/jasminereitano/dev/running_calendar/config/environments/production.rb`
    - Uncomment: `config.assume_ssl = true`
    - Uncomment: `config.force_ssl = true`
    - Update `action_mailer.default_url_options`: `{ host: "mxcorre.com" }`

**Acceptance Criteria:**
- `.kamal/secrets` contains KAMAL_REGISTRY_PASSWORD and POSTGRES_PASSWORD
- `config/deploy.yml` has correct server IP, registry, proxy, and PostgreSQL accessory
- `production.rb` has SSL settings enabled

---

### DNS and SSL Layer

#### Task Group 5: Cloudflare DNS Configuration
**Dependencies:** Task Group 1 (need server IP)

- [x] 5.0 Complete Cloudflare DNS and SSL setup
  - [x] 5.1 Create A record for root domain
    - Log into Cloudflare dashboard
    - Select mxcorre.com domain
    - Go to DNS > Records
    - Add A record: Name=`@`, Content=`<server-ip>`, Proxy status=Proxied
  - [x] 5.2 Create A record for www subdomain
    - Add A record: Name=`www`, Content=`<server-ip>`, Proxy status=Proxied
    - Alternatively: Add CNAME record: Name=`www`, Target=`mxcorre.com`
  - [x] 5.3 Configure SSL/TLS encryption mode
    - Go to SSL/TLS > Overview
    - Set encryption mode to "Full (strict)"
    - This ensures end-to-end encryption with valid certificate
  - [x] 5.4 Verify DNS propagation
    - Check A record: `dig mxcorre.com +short`
    - Check www record: `dig www.mxcorre.com +short`
    - Both should return the Hetzner server IP (or Cloudflare proxy IPs)

**Acceptance Criteria:**
- A records created for mxcorre.com and www.mxcorre.com
- SSL/TLS mode set to "Full (strict)"
- DNS records propagated and resolvable

---

### Deployment and Operations Layer

#### Task Group 6: Initial Deployment and Backup Setup
**Dependencies:** Task Groups 3, 4, 5

- [ ] 6.0 Complete initial deployment and operations setup
  - [x] 6.1 Run Kamal setup
    - From project root: `kamal setup`
    - This bootstraps Docker on server, installs Kamal proxy, and deploys app
    - Monitor output for any errors
    - Verify Docker is installed: `ssh root@<server-ip> docker --version`
  - [x] 6.2 Verify application deployment
    - Check container status: `kamal app details`
    - View logs: `kamal logs`
    - Test health endpoint: `curl -I https://mxcorre.com/up`
    - Verify HTTP 200 response
  - [x] 6.3 Verify SSL certificate
    - Visit https://mxcorre.com in browser
    - Check certificate is valid (padlock icon)
    - Verify certificate issuer is Let's Encrypt
  - [x] 6.4 Create PostgreSQL backup script on server
    - SSH into server: `ssh root@<server-ip>`
    - Create backup directory: `mkdir -p /opt/backups/postgres`
    - Create script: `/opt/backups/postgres/backup.sh`
      ```bash
      #!/bin/bash
      BACKUP_DIR="/opt/backups/postgres"
      DATE=$(date +%Y%m%d_%H%M%S)
      docker exec running_calendar-db pg_dump -U postgres running_calendar_production > "$BACKUP_DIR/backup_$DATE.sql"
      # Keep only last 7 backups
      ls -t $BACKUP_DIR/backup_*.sql | tail -n +8 | xargs -r rm
      ```
    - Make executable: `chmod +x /opt/backups/postgres/backup.sh`
  - [x] 6.5 Configure daily backup cron job
    - Edit crontab: `crontab -e`
    - Add line: `0 3 * * * /opt/backups/postgres/backup.sh >> /var/log/postgres-backup.log 2>&1`
    - This runs backup daily at 3:00 AM server time
  - [x] 6.6 Test backup script manually
    - Run: `/opt/backups/postgres/backup.sh`
    - Verify backup file created: `ls -la /opt/backups/postgres/`
  - [ ] 6.7 Document deployment commands
    - Initial deploy: `kamal setup`
    - Subsequent deploys: `kamal deploy`
    - View logs: `kamal logs`
    - Rails console: `kamal console`
    - Rollback: `kamal rollback`
    - Database restore: `cat backup.sql | docker exec -i running_calendar-db psql -U postgres running_calendar_production`

**Acceptance Criteria:**
- Application deployed and accessible at https://mxcorre.com
- Health check returns HTTP 200
- SSL certificate valid (Let's Encrypt)
- Backup script created and cron job configured
- Manual backup test successful

---

## Execution Order

Recommended implementation sequence:

1. **Task Group 1: Hetzner Server Provisioning** - Create the VPS infrastructure
2. **Task Group 2: GitHub Container Registry Setup** - Can run in parallel with Task Group 1
3. **Task Group 3: Server Security Hardening** - Secure the server before deploying application
4. **Task Group 4: Kamal and Rails Configuration** - Configure deployment files with production values
5. **Task Group 5: Cloudflare DNS Configuration** - Point domain to server
6. **Task Group 6: Initial Deployment and Backup Setup** - Deploy application and set up operations

## Files Modified

| File | Changes |
|------|---------|
| `/Users/jasminereitano/dev/running_calendar/.kamal/secrets` | Add KAMAL_REGISTRY_PASSWORD and POSTGRES_PASSWORD |
| `/Users/jasminereitano/dev/running_calendar/config/deploy.yml` | Update server IP, registry, proxy/SSL, PostgreSQL accessory |
| `/Users/jasminereitano/dev/running_calendar/config/environments/production.rb` | Enable assume_ssl and force_ssl |

## Server Files Created

| File | Purpose |
|------|---------|
| `/opt/backups/postgres/backup.sh` | Daily PostgreSQL backup script |
| Cron job entry | Scheduled daily backup at 3:00 AM |

## Verification Checklist

After completing all tasks, verify:

- [ ] https://mxcorre.com loads successfully
- [ ] https://www.mxcorre.com redirects or loads successfully
- [ ] SSL certificate shows as valid in browser
- [ ] `kamal logs` shows Rails application running
- [ ] `kamal console` provides Rails console access
- [ ] UFW shows only ports 22, 80, 443 open
- [ ] fail2ban is running and protecting SSH
- [ ] PostgreSQL backup exists in `/opt/backups/postgres/`
- [ ] Cron job is scheduled for daily backups
