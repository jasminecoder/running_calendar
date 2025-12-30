# Task Breakdown: Race Model and Database Schema

## Overview
Total Tasks: 5 Task Groups

This spec focuses on creating the foundational data layer for the running calendar application. Since this is a models-and-migrations-only spec with no API or UI components, the task groups are organized around database migrations, model implementation, and testing.

## Task List

### Database Layer

#### Task Group 1: Database Migrations
**Dependencies:** None

- [x] 1.0 Complete database migrations
  - [x] 1.1 Create races table migration
    - Columns:
      - `name` (string, limit: 255, null: false)
      - `start_time` (datetime, null: false)
      - `location_description` (text, null: false)
      - `location_address` (string)
      - `city` (integer, null: false) - enum backing
      - `registration_url` (string)
      - `registration_info` (text)
      - `day_of_race_registration` (boolean, default: false, null: false)
      - `cost` (decimal, precision: 6, scale: 2)
      - `notes` (text)
      - `status` (integer, default: 0, null: false) - enum backing, default draft
      - `organizer_name` (string)
      - `organizer_contact` (text)
      - `published_at` (datetime)
      - `timestamps`
    - Indexes: status, city
  - [x] 1.2 Create race_distances table migration
    - Columns:
      - `race_id` (references, null: false, foreign_key: true)
      - `distance_value` (decimal, precision: 4, scale: 1, null: false)
      - `distance_unit` (integer, null: false) - enum backing
      - `timestamps`
    - Foreign key constraint with on_delete: :cascade
    - Index on race_id
  - [x] 1.3 Run migrations and verify schema
    - Run `bin/rails db:migrate`
    - Verify schema.rb contains expected tables and columns
    - Verify indexes are created correctly

**Acceptance Criteria:**
- Both migrations run successfully without errors
- schema.rb reflects all columns with correct types and constraints
- Indexes exist on races.status, races.city, and race_distances.race_id
- Foreign key constraint exists between race_distances and races

---

### Model Layer

#### Task Group 2: Model Implementation
**Dependencies:** Task Group 1

- [x] 2.0 Complete model implementation
  - [x] 2.1 Write 6-8 focused tests for Race model functionality
    - Test presence validations for required fields (name, start_time, location_description, city, status)
    - Test city enum values (tijuana, rosarito, tecate, mexicali)
    - Test status enum values (draft, published, completed, cancelled)
    - Test default status is draft for new records
    - Test published_at callback (set when status changes to published, preserved when changed away)
    - Test scopes: published, upcoming, past, by_city
    - Test has_many :race_distances association with dependent: :destroy
    - Test validation that race has at least one race_distance
  - [x] 2.2 Write 4-6 focused tests for RaceDistance model functionality
    - Test presence validations for distance_value and distance_unit
    - Test distance_unit enum values (km, miles)
    - Test distance_value greater than 0 validation
    - Test uniqueness of distance_value scoped to race_id
    - Test belongs_to :race association
  - [x] 2.3 Create Race model with enums and associations
    - Inherit from ApplicationRecord
    - Define city enum: { tijuana: 0, rosarito: 1, tecate: 2, mexicali: 3 }
    - Define status enum: { draft: 0, published: 1, completed: 2, cancelled: 3 }
    - Add has_many :race_distances, dependent: :destroy
    - Add accepts_nested_attributes_for :race_distances
    - Add has_one_attached :featured_image
    - Add has_many_attached :additional_images
  - [x] 2.4 Add Race model validations
    - Validate presence of: name, start_time, location_description, city, status
    - Validate name length maximum 255 characters
    - Validate start_time is in future only when status is draft or published
    - Validate cost is greater than or equal to 0 when present
    - Validate registration_url format (http/https) when present
    - Validate presence of featured_image attachment
    - Validate content_type for featured_image and additional_images (jpeg, png, gif, webp)
    - Validate file size less than 5 megabytes per image
    - Validate additional_images has maximum 10 images
    - Validate race has at least one race_distance
  - [x] 2.5 Add Race model scopes
    - `published` - races with status: :published
    - `upcoming` - published races with start_time in the future
    - `past` - races with start_time in the past
    - `by_city(city)` - filter by city enum value
  - [x] 2.6 Implement published_at callback
    - Add before_save callback to track status changes
    - Set published_at to current time when status changes to published
    - Preserve published_at when status changes away from published
  - [x] 2.7 Create RaceDistance model with enum and association
    - Inherit from ApplicationRecord
    - Define distance_unit enum: { km: 0, miles: 1 }
    - Add belongs_to :race
  - [x] 2.8 Add RaceDistance model validations
    - Validate presence of: distance_value, distance_unit
    - Validate distance_value is greater than 0
    - Validate uniqueness of distance_value scoped to race_id
  - [x] 2.9 Ensure model tests pass
    - Run `bin/rails test test/models/race_test.rb test/models/race_distance_test.rb`
    - Verify all 10-14 tests pass
    - Do NOT run the entire test suite at this stage

**Acceptance Criteria:**
- All model tests pass (10-14 tests total)
- Race model has all enums, associations, validations, scopes, and callbacks
- RaceDistance model has enum, association, and validations
- Active Storage attachments work correctly with validations
- published_at timestamp behavior is correct

---

### Test Fixtures

#### Task Group 3: Fixtures and Seed Data
**Dependencies:** Task Group 2

- [x] 3.0 Complete fixtures and seed data
  - [x] 3.1 Create races.yml fixture file
    - Create sample races in different statuses (draft, published, completed, cancelled)
    - Cover all four cities (tijuana, rosarito, tecate, mexicali)
    - Include races with and without optional fields
    - Include at least 4-6 fixture races
  - [x] 3.2 Create race_distances.yml fixture file
    - Create distances for fixture races
    - Include both km and miles examples
    - Include races with single and multiple distances
  - [x] 3.3 Create seed images directory and placeholder images
    - Create `db/seeds/images/` directory
    - Add 3-4 placeholder race images for seeding
  - [x] 3.4 Create development seeds in db/seeds.rb
    - Create 2-3 sample races per city (8-12 total)
    - Mix of statuses: mostly published, some draft, one completed
    - Include varied distances (5K, 10K, 21K, 42K)
    - Attach images from `db/seeds/images/` folder
    - Include races with single and multiple distances
  - [x] 3.5 Verify fixtures and seeds work
    - Run `bin/rails db:fixtures:load` in test environment
    - Run `bin/rails db:seed` in development environment
    - Verify Race.count and RaceDistance.count match expected values

**Acceptance Criteria:**
- Fixtures load without errors in test environment
- Seeds create expected number of races and distances
- Seeded races have images attached correctly
- All four cities and varied statuses are represented

---

### Testing

#### Task Group 4: Test Review and Final Verification
**Dependencies:** Task Groups 1-3

- [x] 4.0 Review tests and verify complete feature functionality
  - [x] 4.1 Review tests from Task Group 2
    - Review the 6-8 tests written for Race model (Task 2.1)
    - Review the 4-6 tests written for RaceDistance model (Task 2.2)
    - Total existing tests: approximately 10-14 tests
  - [x] 4.2 Analyze test coverage gaps for this feature only
    - Identify any critical model behaviors lacking test coverage
    - Focus ONLY on gaps related to Race and RaceDistance models
    - Prioritize validation edge cases and callback behavior
  - [x] 4.3 Write up to 6 additional strategic tests if needed
    - Add maximum of 6 new tests to fill identified critical gaps
    - Consider testing:
      - Edge cases for start_time future validation (draft vs completed status)
      - Cascade delete behavior for race_distances
      - Active Storage attachment content type rejection
      - Scope chaining (e.g., upcoming.by_city)
    - Skip exhaustive edge case testing
  - [x] 4.4 Run all feature-specific tests
    - Run `bin/rails test test/models/race_test.rb test/models/race_distance_test.rb`
    - Expected total: approximately 14-20 tests maximum
    - Verify all tests pass
  - [x] 4.5 Manual verification in Rails console
    - Create a Race with RaceDistance via nested attributes
    - Test status changes and published_at behavior
    - Test scope queries
    - Verify Active Storage attachment works

**Acceptance Criteria:**
- All feature-specific tests pass (approximately 14-20 tests total)
- Critical model behaviors are covered
- No more than 6 additional tests added when filling gaps
- Manual verification confirms models work as expected

---

### Deployment

#### Task Group 5: Deploy to Production
**Dependencies:** Task Groups 1-4

- [x] 5.0 Deploy to production
  - [x] 5.1 Run full test suite locally
    - Run `bin/rails test`
    - Verify all tests pass before deploying
  - [x] 5.2 Commit all changes to git
    - Review changed files with `git status`
    - Stage and commit with descriptive message
  - [x] 5.3 Deploy to production with Kamal
    - Run `kamal deploy`
    - Monitor output for any errors
    - Kamal automatically runs `db:migrate` during deployment
  - [x] 5.4 Verify deployment in production
    - Run `kamal console`
    - Verify migrations ran: `Race.count` (should be 0 initially)
    - Verify schema: `Race.column_names`
    - Verify RaceDistance: `RaceDistance.column_names`
  - [ ] 5.5 (Optional) Run seeds in production if needed
    - Only if you want sample data in production
    - Run `kamal app exec 'bin/rails db:seed'`

**Acceptance Criteria:**
- All tests pass locally before deployment
- `kamal deploy` completes without errors
- Migrations run successfully on production database
- `kamal console` can query Race and RaceDistance models

**Rollback Plan:**
- If deployment fails: `kamal rollback` to previous version
- If migration needs reverting: `kamal app exec 'bin/rails db:rollback'`

---

## Execution Order

Recommended implementation sequence:

1. **Database Migrations (Task Group 1)** - Create the database schema first as foundation
2. **Model Implementation (Task Group 2)** - Build models with validations, associations, and callbacks
3. **Fixtures and Seed Data (Task Group 3)** - Create test fixtures and development seeds
4. **Test Review and Verification (Task Group 4)** - Final test review and manual verification
5. **Deploy to Production (Task Group 5)** - Deploy to Kamal and verify in production

## Notes

- This spec is database/model layer only - no API endpoints or UI components
- Active Storage is already configured in the project
- PostgreSQL is already configured as the database
- image_processing gem is already in the Gemfile
