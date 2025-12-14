## Deployment Standards (Kamal + Hetzner)

### Platform
- **Hosting**: Hetzner VPS with Docker
- **Deployment**: Kamal (Rails 8 default)
- **Database**: PostgreSQL on Hetzner
- **Environments**: `main` branch → production

### Kamal Configuration
```yaml
# config/deploy.yml
service: running-calendar
image: your-registry/running-calendar

servers:
  web:
    hosts:
      - your-server-ip
    labels:
      traefik.http.routers.running-calendar.rule: Host(`yourdomain.com`)

env:
  clear:
    RAILS_ENV: production
  secret:
    - RAILS_MASTER_KEY
    - DATABASE_URL

traefik:
  options:
    publish:
      - "443:443"
    volume:
      - "/letsencrypt/acme.json:/letsencrypt/acme.json"
```

### Deployment Commands
```bash
# Initial setup
kamal setup

# Deploy
kamal deploy

# Rollback
kamal rollback

# Run migrations
kamal app exec 'bin/rails db:migrate'

# Console access
kamal app exec -i 'bin/rails console'
```

### Database Migrations
- Run via `kamal app exec 'bin/rails db:migrate'` after deploy
- Zero-downtime: add nullable column → deploy → backfill → add constraint
- Backup before destructive migrations

### Health Checks
- Configure `/up` endpoint (Rails 7.1+ default)
- Kamal checks health before routing traffic
