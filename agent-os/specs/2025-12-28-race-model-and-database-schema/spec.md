# Specification: Race Model and Database Schema

## Goal
Create the foundational Race and RaceDistance models with database migrations, validations, and Active Storage image attachment to store comprehensive race event information for the running calendar application.

## User Stories
- As an admin, I want to store race information with all relevant details so that runners can find races in their area
- As an admin, I want to track race status through its lifecycle (draft, published, completed, cancelled) so that only appropriate races are shown to users

## Specific Requirements

**Race Model Creation**
- Create Race model inheriting from ApplicationRecord
- Define enums for city (tijuana, rosarito, tecate, mexicali) and status (draft, published, completed, cancelled)
- Set default status to :draft for new records
- Include has_many :race_distances association with dependent: :destroy
- Include accepts_nested_attributes_for :race_distances to allow creating race with distances together
- Include has_one_attached :featured_image for main race image (required)
- Include has_many_attached :additional_images for extra images (optional, max 10)
- Implement callback to set published_at timestamp when status changes to published
- Validate race has at least one race_distance
- Define scopes for common queries:
  - `published` - races with status: :published
  - `upcoming` - published races with start_time in the future
  - `past` - races with start_time in the past (for archive)
  - `by_city(city)` - filter by city enum value

**RaceDistance Model Creation**
- Create RaceDistance model with belongs_to :race association
- Define enum for distance_unit (km, miles)
- Store distance_value as decimal for precision
- Ensure foreign key constraint to races table

**Race Database Migration**
- Create races table with all required columns and appropriate data types
- Use string for name (limit: 255), location_address, registration_url, organizer_name
- Use text for location_description, registration_info, notes, organizer_contact
- Use integer for city and status enums (Rails enum default)
- Use datetime for start_time and published_at
- Use decimal with precision 6, scale 2 for cost field (max 9999.99 MXN)
- Use boolean for day_of_race_registration with default false
- Set default value for status to 0 (draft) in migration
- Include timestamps (created_at, updated_at)
- Add indexes on status and city columns for query optimization

**RaceDistance Database Migration**
- Create race_distances table with race_id foreign key reference
- Use decimal with precision 4, scale 1 for distance_value (max 999.9 km/miles)
- Use integer for distance_unit enum (Rails enum default)
- Include timestamps (created_at, updated_at)
- Add foreign key constraint with on_delete: :cascade
- Add index on race_id for association lookups

**Race Model Validations**
- Validate presence of name, start_time, location_description, city, status
- Validate presence of featured_image attachment
- Validate name length maximum 255 characters
- Validate start_time is in the future only when status is draft or published (allows editing completed/cancelled races)
- Validate cost is greater than or equal to 0 when present
- Validate registration_url format when present (http/https URL)

**RaceDistance Model Validations**
- Validate presence of distance_value and distance_unit
- Validate distance_value is greater than 0
- Validate uniqueness of distance_value scoped to race_id to prevent duplicate distances

**Active Storage Image Attachments**
- Attach featured image using has_one_attached :featured_image (required, main race representation)
- Attach additional images using has_many_attached :additional_images (optional, for categories, prizes, etc.)
- Validate content_type is image/jpeg, image/png, image/gif, or image/webp for all images
- Validate file size is less than 5 megabytes per image
- Validate additional_images has maximum 10 images
- Use image_processing gem already in Gemfile for variants

**Published At Timestamp Tracking**
- Implement before_save callback to track status changes
- Set published_at to current time when status changes to published
- Keep published_at when status changes away from published (preserves history of when it was first published)

**Status Management**
- Status changes are manual (admin changes status)
- Completed status is set manually by admin after race has occurred
- Cancelled status is set manually by admin if race is cancelled

## Existing Code to Leverage

**ApplicationRecord (app/models/application_record.rb)**
- Standard Rails 8.1 ApplicationRecord base class
- Both Race and RaceDistance models should inherit from this class

**Active Storage Configuration (config/storage.yml)**
- Local disk storage already configured for development/production
- Test storage configured for tmp directory
- No additional storage configuration needed

**Image Processing Gem (Gemfile)**
- image_processing gem (~> 1.2) already included
- Enables Active Storage variants for resizing images
- Can define image variants on the Race model for thumbnails

**PostgreSQL Database (Gemfile)**
- pg gem already configured for database
- Supports native enum types if desired (though Rails enums with integer backing preferred)
- Decimal precision fully supported

## Testing

**Model Tests (test/models/race_test.rb)**
- Test validations: presence of required fields, format validations
- Test enums: city and status values work correctly
- Test associations: has_many :race_distances, dependent: :destroy
- Test callbacks: published_at is set when status changes to published (and preserved when changed away)
- Test Active Storage: featured_image and additional_images attachments
- Test scopes: published, upcoming, past, by_city

**Model Tests (test/models/race_distance_test.rb)**
- Test validations: presence of required fields, numericality
- Test enums: distance_unit values work correctly
- Test associations: belongs_to :race
- Test uniqueness: distance_value scoped to race_id

**Fixtures (test/fixtures/races.yml)**
- Create sample races in different statuses (draft, published, completed, cancelled)
- Cover all four cities
- Include races with and without optional fields

**Fixtures (test/fixtures/race_distances.yml)**
- Create distances for fixture races
- Include both km and miles examples

## Seed Data

**Development Seeds (db/seeds.rb)**
- Create 2-3 sample races per city (8-12 total)
- Mix of statuses: mostly published, some draft, one completed
- Include varied distances (5K, 10K, 21K, 42K)
- Store placeholder images in `db/seeds/images/` folder and attach from there
- Include races with single and multiple distances

## Deployment

**Deploy to Production**
- Run tests locally first: `bin/rails test`
- Commit all changes to git
- Run `kamal deploy` to push to production
- Kamal automatically runs `db:migrate` during deployment
- Verify migrations ran: `kamal console` then `Race.count`

**Rollback Plan**
- If issues occur: `kamal rollback` to previous version
- To rollback migration: `kamal app exec 'bin/rails db:rollback'`

## Out of Scope
- User or Organizer models and authentication (future enhancement)
- Admin interface for creating/editing races (roadmap item 6, 8, 9)
- Public-facing race listing views (roadmap items 3-4)
- Search and filtering functionality (roadmap item 5)
- Multi-currency support for cost field
- Image variants and thumbnails (can be added when views are built)
- Geocoding or map integration for locations
- Race categories or tagging system
- Registration tracking or ticketing integration
- Email notifications or reminders
