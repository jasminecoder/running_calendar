# Spec Requirements: Race Model and Database Schema

## Initial Description
Create the Race model with all necessary fields (name, date, start time, location description, location address (optional), city, distance (although not the rule, some races could have a few different distances like 5k and 10k), image, registration URL (optional), registration info (text field), day of race registration(yes/no), cost, notes (optional), status) and database migrations

## Requirements Discussion

### First Round Questions

**Q1:** For the city field, should this be a free-form text field, or an enum/dropdown with specific cities? If dropdown, what cities should be included?
**Answer:** Enum with 4 Spanish cities: Tijuana, Rosarito, Tecate, Mexicali

**Q2:** For the status field, what statuses should be available? (e.g., draft, published, cancelled, completed)
**Answer:** All four statuses: `draft`, `published`, `completed`, `cancelled`

**Q3:** For the distance field, since races can have multiple distances, should this be a separate model (RaceDistance) with a has_many relationship, or stored as a JSON/array field on the Race model?
**Answer:** Separate RaceDistance model with has_many relationship

**Q4:** For the cost field, should this support multiple currencies, or will all races be in a single currency (e.g., Mexican Pesos)?
**Answer:** Decimal field, Mexican Pesos only (no currency field needed)

**Q5:** For the image field, should this use Active Storage for file uploads? Any specific validations needed (file size limits, accepted formats)?
**Answer:** Active Storage with validations for file size and content types

**Q6:** For the start time, should this be a separate time field, or combined with the date as a full DateTime?
**Answer:** Full DateTime combining date and time

**Q7:** Should there be any additional timestamps beyond created_at/updated_at? (e.g., published_at for when status changes to published)
**Answer:** Yes, include published_at timestamp

**Q8:** Is this race going to be associated with a User model (as organizer) or an Organizer model, or should organizer info be simple text fields on the Race for now?
**Answer:** Simple approach - organizer_name and organizer_contact  text fields on Race (no User/Organizer models yet)

### Follow-up Questions

**Follow-up 1:** For the organizer_contact field, should this be a simple URL field for the source website, or a general text field that could contain notes about where the race info came from?
**Answer:** General text field with enough space for notes about where race info came from (not just URLs)

### Existing Code to Reference

No similar existing features identified for reference. This is a new model being created for the application.

## Visual Assets

### Files Provided:
No visual assets provided.

## Requirements Summary

### Functional Requirements
- Create Race model as the core entity for storing race information
- Support multiple distances per race via RaceDistance association (with accepts_nested_attributes_for)
- Validate race has at least one race_distance
- Track race status through its lifecycle (draft -> published -> completed/cancelled)
- Status changes are manual (admin sets status)
- Store race timing as full DateTime for precise scheduling
- Handle image uploads via Active Storage with appropriate validations
- Store organizer information as simple text fields for initial implementation
- Track when races are published via published_at timestamp (preserved when status changes away)
- Define scopes: published, upcoming, past, by_city

### Race Model Fields
| Field | Type | Required | Notes |
|-------|------|----------|-------|
| name | string | Yes | Race name |
| start_time | datetime | Yes | Combined date and time of race start |
| location_description | text | Yes | Description of the race location |
| location_address | string | No | Optional street address |
| city | enum | Yes | Tijuana, Rosarito, Tecate, Mexicali |
| registration_url | string | No | Optional link to registration |
| registration_info | text | No | Text description of registration details |
| day_of_race_registration | boolean | Yes | Whether race-day registration is available |
| cost | decimal | No | Cost in Mexican Pesos |
| notes | text | No | Optional additional notes |
| status | enum | Yes | draft, published, completed, cancelled |
| organizer_name | string | No | Name of race organizer |
| organizer_contact | text | No | Notes about source of race info |
| published_at | datetime | No | When status changed to published |
| featured_image | attachment | Yes | Main race image via Active Storage |
| additional_images | attachments | No | Optional extra images via Active Storage (max 10) |

### RaceDistance Model Fields
| Field | Type | Required | Notes |
|-------|------|----------|-------|
| race_id | references | Yes | Foreign key to Race |
| distance_value | decimal | Yes | Numeric distance value |
| distance_unit | enum | Yes | km, miles |

### Scope Boundaries
**In Scope:**
- Race model with all specified fields
- RaceDistance model with has_many relationship
- Database migrations for both models
- Active Storage setup for image attachment
- Enum definitions for city, status, and distance_unit
- Model validations
- published_at timestamp tracking

**Out of Scope:**
- User/Organizer models (future enhancement - not currently in roadmap)
- Admin authentication (roadmap item 7)
- Admin interface for managing races (roadmap items 6, 8, 9)
- Public-facing race listing views (roadmap items 3-4)
- Search/filtering functionality (roadmap item 5)
- Multi-currency support

**Future Migration Note:**
If/when Organizer model is built (future enhancement), a migration could add `organizer_id` foreign key to Race. For now, `organizer_name`/`organizer_contact` text fields capture organizer info manually entered by admin.

### Technical Considerations
- Use Rails enums for city, status, and distance_unit fields (stored as integers)
- Active Storage for image uploads with validations:
  - File size limit: 5 megabytes per image
  - Accepted content types: image/jpeg, image/png, image/gif, image/webp
- Decimal precision 6, scale 2 for cost field (max 9999.99 MXN)
- Decimal precision 4, scale 1 for distance_value (max 999.9 km/miles)
- Name field max length: 255 characters
- Index on status and city for common query patterns
- Foreign key constraint on race_distances.race_id with cascade delete
