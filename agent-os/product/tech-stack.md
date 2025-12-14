# Tech Stack

## Backend

- **Framework:** Ruby on Rails (latest stable version)
- **Language:** Ruby (latest version compatible with latest Rails)
- **API Style:** Server-rendered HTML with Hotwire (Turbo + Stimulus) for interactivity

## Frontend

- **CSS Framework:** Tailwind CSS
- **JavaScript:** Hotwire (Turbo and Stimulus, included with Rails)
- **Responsive Design:** Mobile-first approach

## Database

- **Primary Database:** PostgreSQL
- **ORM:** Active Record (Rails default)

## File Storage

- **Image Storage:** Active Storage (Rails default)
- **Cloud Storage:** To be determined based on deployment needs (S3-compatible recommended)

## Deployment

- **Hosting Provider:** Hetzner
- **Deployment Tool:** Kamal
- **Reference:** https://community.hetzner.com/tutorials/deploy-rails-8-app-on-hetzner-with-kamal

## Development Tools

- **Version Control:** Git
- **Ruby Version Manager:** asdf
- **Package Manager:** Bundler (Ruby), npm or yarn (JavaScript/CSS)

## Testing

- **Test Framework:** Minitest
- **System Tests:** Capybara with Selenium

## Additional Services (Future Consideration)

- **Email Delivery:** SendGrid
- **Background Jobs:** Solid Queue (Rails 8 default)
- **Caching:** Solid Cache (Rails 8 default)
