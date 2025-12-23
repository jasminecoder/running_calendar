# Spec Requirements: Deploy Rails to Hetzner with Kamal

## Initial Description

Deploy the Running Calendar Rails application to Hetzner VPS using Kamal. This is the first item on the product roadmap and establishes the production infrastructure for the mobile-first Spanish-language platform that helps runners in Northern Baja California discover upcoming races.

Reference tutorial: https://community.hetzner.com/tutorials/deploy-rails-8-app-on-hetzner-with-kamal

## Requirements Discussion

### First Round Questions

**Q1:** I assume you need to provision a new Hetzner server since this appears to be the first deployment. Is that correct, or do you already have a Hetzner VPS set up?
**Answer:** Yes, need to provision a new server - wants instructions included.

**Q2:** I'm thinking we'll use a Hetzner CPX11 or CPX21 shared vCPU instance to start (affordable and sufficient for a new Rails app). Does that sound right, or do you have a specific server type in mind?
**Answer:** User shared screenshot of Hetzner Cloud pricing. Confirmed Hetzner Cloud is the correct product. Will use CX23 (2 vCPU, 4GB RAM, 40GB NVMe SSD, €3.49/month).

**Q3:** For the domain, I assume you already have or will purchase a domain name. Do you have a domain ready, and is it registered with a DNS provider you can configure?
**Answer:** Domain is mxcorre.com, registered with Cloudflare.

**Q4:** For SSL certificates, I assume we'll use Let's Encrypt via Traefik (this is the Kamal default and free). Is that acceptable, or do you have a different SSL preference?
**Answer:** Let's Encrypt via Traefik sounds good, as long as it works with Cloudflare + Hetzner. User confirmed understanding that both Let's Encrypt and Cloudflare SSL are free.

**Q5:** For the PostgreSQL database, I assume we'll run it on the same Hetzner VPS using Docker (simpler and cheaper to start). Would you prefer a managed PostgreSQL service instead for easier backups and maintenance?
**Answer:** PostgreSQL on same VPS - simple is best.

**Q6:** For the container registry, I assume we'll use Docker Hub (free tier for public images). Should we use a private registry, or is Docker Hub acceptable for now?
**Answer:** Prefers GitHub Container Registry (ghcr.io) if easy, otherwise Docker Hub is fine.

**Q7:** For CI/CD, I assume we'll start with manual deployments via `kamal deploy` from your local machine, and add GitHub Actions later if needed. Does that approach work, or do you want automated deployments from the start?
**Answer:** Manual deploy for now (`kamal deploy` from local machine).

**Q8:** Is there anything you explicitly want to exclude from this deployment setup? For example: automated backups, monitoring/alerting, staging environment, or specific security hardening?
**Answer:** Wants suggestions on what to exclude while keeping best practices, safety and privacy. Approved the following:
- **Include:** Daily database backups (essential for safety)
- **Include:** Firewall rules (SSH + HTTP/HTTPS only)
- **Include:** Fail2ban for SSH protection
- **Exclude:** Staging environment (can add later)
- **Exclude:** Automated CI/CD (manual deploy for now)
- **Exclude:** Advanced monitoring/alerting (use Kamal's basic health checks)

### Existing Code to Reference

**Similar Features Identified:**
- Existing Kamal configuration: `config/deploy.yml` - Rails 8 default Kamal config with placeholder values
- Existing Dockerfile: `Dockerfile` - Production-ready Rails 8 Dockerfile with multi-stage build
- Existing secrets template: `.kamal/secrets` - Template for extracting RAILS_MASTER_KEY
- Existing Kamal hooks: `.kamal/hooks/` directory present

**Key observations from existing config:**
- Service name: `running_calendar`
- Image name: `running_calendar`
- Placeholder server IP: `192.168.0.1`
- Registry currently set to localhost (needs update for ghcr.io)
- SSL/proxy section commented out (needs enabling)
- Cloudflare note already present in comments
- PostgreSQL client already included in Dockerfile
- Solid Queue configured to run in Puma process
- Storage volume configured for Active Storage
- Builder architecture set to amd64

### Follow-up Questions

**Follow-up 1:** You mentioned sharing a Hetzner screenshot, but I didn't find any files in the visuals folder. Could you place it in the visuals folder if you'd like me to analyze it? Otherwise, I can proceed with the recommendation for Hetzner Cloud CX23.
**Answer:** Confirmed Hetzner Cloud CX23 (2 vCPU, 4GB RAM, 40GB NVMe SSD, €3.49/month).

**Follow-up 2:** For Cloudflare + Let's Encrypt SSL: Do you want Cloudflare in "Full (strict)" mode (more secure) or "Full" mode? I recommend "Full (strict)" for best security.
**Answer:** User understands the SSL configuration. Proceeding with Let's Encrypt + Cloudflare "Full (strict)" mode.

**Follow-up 3:** For GitHub Container Registry (ghcr.io): This requires a GitHub Personal Access Token with `write:packages` scope. Are you comfortable generating this token?
**Answer:** Comfortable creating GitHub PAT for ghcr.io container registry.

## Visual Assets

### Files Provided:
No visual assets provided in the visuals folder.

### Visual Insights:
User mentioned sharing a Hetzner screenshot showing product options but file was not added to the visuals folder. The screenshot showed Hetzner's product lineup including Cloud, Dedicated Servers, Managed Servers, and Web Hosting options.

## Requirements Summary

### Functional Requirements

**Server Provisioning:**
- Provision new Hetzner Cloud VPS
- Server type: CX23 (2 vCPU, 4GB RAM, 40GB NVMe SSD, €3.49/month)
- Location: Choose datacenter closest to target users (Northern Baja California) - likely US locations or Germany
- Operating System: Ubuntu or Debian (Docker-compatible)

**Domain and SSL Configuration:**
- Domain: mxcorre.com (registered with Cloudflare)
- SSL: Let's Encrypt certificates via Traefik (Kamal proxy)
- Cloudflare SSL mode: "Full (strict)"
- Configure DNS A record pointing to Hetzner server IP

**Database Setup:**
- PostgreSQL running on same VPS via Docker
- Configure as Kamal accessory
- Daily automated backups

**Container Registry:**
- GitHub Container Registry (ghcr.io)
- Requires GitHub Personal Access Token with `write:packages` scope
- Image name format: `ghcr.io/<github-username>/running_calendar`

**Deployment Process:**
- Manual deployment via `kamal deploy` from local machine
- Update existing `config/deploy.yml` with production values
- Configure `.kamal/secrets` for registry password and Rails master key

**Security Hardening:**
- UFW firewall: allow only SSH (22), HTTP (80), HTTPS (443)
- Fail2ban for SSH brute-force protection
- Non-root Docker user (already configured in Dockerfile)

### Reusability Opportunities

- Existing `config/deploy.yml` provides the base configuration structure
- Existing `Dockerfile` is production-ready, no changes needed
- Existing `.kamal/secrets` template shows the secrets pattern
- Existing `.kamal/hooks/` directory for deployment hooks if needed
- Deployment standards in `agent-os/standards/global/deployment.md` provide configuration patterns

### Scope Boundaries

**In Scope:**
- Hetzner Cloud VPS provisioning instructions
- Kamal configuration for production deployment
- PostgreSQL setup as Docker accessory
- Let's Encrypt SSL via Traefik
- Cloudflare DNS configuration
- GitHub Container Registry setup
- Basic firewall configuration (UFW)
- Fail2ban SSH protection
- Daily PostgreSQL backup script
- Manual deployment workflow documentation

**Out of Scope:**
- Staging environment setup
- Automated CI/CD pipeline (GitHub Actions)
- Advanced monitoring and alerting (Datadog, New Relic, etc.)
- Log aggregation services
- CDN configuration beyond Cloudflare defaults
- Auto-scaling or load balancing
- Redis/Valkey setup (not needed for MVP)

### Technical Considerations

**Integration Points:**
- Cloudflare DNS must point to Hetzner server IP
- GitHub Container Registry requires PAT authentication
- Rails credentials (master.key) must be available for deployment
- Solid Queue runs inside Puma process (no separate job server needed)

**Existing System Constraints:**
- Rails 8.x with Hotwire (Turbo + Stimulus)
- PostgreSQL as primary database
- Active Storage for file uploads (storage volume already configured)
- Tailwind CSS for styling
- Minitest for testing

**Configuration Updates Required:**
- `config/deploy.yml`: Update server IP, registry, proxy/SSL settings
- `.kamal/secrets`: Add KAMAL_REGISTRY_PASSWORD for ghcr.io
- Cloudflare: Create A record, set SSL mode to "Full (strict)"
- Server: Install Docker, configure firewall, setup fail2ban

**Reference Documentation:**
- Hetzner tutorial: https://community.hetzner.com/tutorials/deploy-rails-8-app-on-hetzner-with-kamal
- Project deployment standards: `agent-os/standards/global/deployment.md`
