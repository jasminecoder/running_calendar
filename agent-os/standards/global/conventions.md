## Rails Project Conventions

- **File Structure**: Follow Rails conventions (`app/models/`, `app/controllers/`, `app/views/`)
- **Environment Variables**: Use `Rails.application.credentials` or `ENV.fetch("KEY")`
- **Secrets**: Never commit secrets; use Rails credentials or environment variables
- **Dependencies**: Keep Gemfile minimal; document why non-obvious gems are included

**Directory Structure**:
```
app/
  controllers/    # RESTful controllers
  models/         # ActiveRecord models
  views/          # ERB templates and partials
  javascript/     # Stimulus controllers
  assets/         # Stylesheets, images
config/
  routes.rb       # Define routes
  database.yml    # Database config (uses ENV)
db/
  migrate/        # Migrations
  seeds.rb        # Seed data
```

**Credentials**:
```ruby
# Good: Rails credentials
Rails.application.credentials.sendgrid_api_key

# Good: Environment variable with required check
ENV.fetch("DATABASE_URL")
```

**Gemfile**:
```ruby
# Specify why if non-obvious
gem "image_processing" # For Active Storage variants
gem "rack-attack"      # Rate limiting for race submission endpoint
```
