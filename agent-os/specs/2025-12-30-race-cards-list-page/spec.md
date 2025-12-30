# Specification: Race Cards List Page

## Goal
Build the main homepage for mxcorre.com displaying upcoming race cards ordered by date, grouped by month, with a branded navbar and hero section, optimized for mobile-first viewing.

## User Stories
- As a runner, I want to browse upcoming races in Baja California so that I can find events to participate in
- As a mobile user, I want to scroll through race cards easily so that I can quickly find race information while on the go

## Specific Requirements

**Navbar Component**
- Position at top of page with "mxcorre" logo/text on left
- Logo uses #9CCC65 (green) combined with white for playful styling
- Custom hamburger menu on right (top/bottom lines longer than middle line)
- Hamburger menu opens/closes on click (use Stimulus controller)
- Menu contains "contact us" link (placeholder for future expansion)
- Background matches site gradient but with added transparency

**Site Background Gradient**
- CSS gradient: `linear-gradient(90deg, rgba(30, 58, 95, 1) 0%, rgba(114, 47, 55, 1) 100%)`
- Colors: #1E3A5F (dark blue) to #722F37 (burgundy)
- Apply to body or main wrapper element
- Ensure sufficient contrast with white race cards

**Hero Section**
- Display runner image saved to `app/assets/images/hero-runner.jpg`
- Image specifications: 1920 x 600 pixels, JPEG format, < 200KB file size
- Text overlay: "Próximas carreras en Tijuana" (static text for now)
- Mobile-first responsive sizing
- Position below navbar, above race cards

**Race Cards Container**
- Single-column layout on mobile (full-width cards)
- 2-column grid on tablet (md breakpoint)
- 3-column grid on desktop (lg breakpoint)
- Consistent spacing between cards using Tailwind gap utilities

**Individual Race Card Design**
- White background with no borders, rounded corners (`rounded-lg`)
- Entire card clickable, linking to `/races/:id` (ready for Race Detail Page implementation)
- Card structure top-to-bottom:
  1. Featured image (16:9 aspect ratio) - with fallback placeholder if missing
  2. Race name
  3. Line separator (1px, #E5E7EB gray-200)
  4. Calendar icon + formatted date
  5. Place icon + location_description
  6. Cost display row
  7. Distance badges (button-style, single row)
  8. City badge (button-style, separate row)
- Subtle hover effect (shadow/lift) for desktop interactions
- Skeleton loading state while images load

**Distance and City Badges**
- Button-style badges for distances (bordered text, not clickable links)
- Display all distances in single row (e.g., "5K", "10K", "21K")
- Separate row for city badge with same styling
- Badges use small sizing to avoid overwhelming the card

**Date Formatting**
- Spanish locale format: "Sábado, 15 de Enero 2025" (with proper accents)
- Configure Rails I18n with Spanish locale file (UTF-8 encoding)
- Day names: Lunes, Martes, Miércoles, Jueves, Viernes, Sábado, Domingo
- Use I18n.l helper for date formatting

**Month Subheadings**
- Group races by month with subheading separators
- Format: "Diciembre 2025" in Spanish
- Use #9CCC65 (green) color matching logo
- Controller groups races by month using Ruby's group_by

**Cost Display**
- Show "Gratis" for races with cost of 0
- Show formatted price for paid races (e.g., "$250 MXN")
- Position between location and distances on card

**Empty State**
- Display when no upcoming published races exist
- Message: "No hay carreras proximas. Vuelve pronto!"
- Center on page with friendly styling

**Footer Component**
- Simple footer below race cards
- Copyright text with current year
- "Hecho con corazon en Baja California" tagline
- Placeholder for social links (Instagram, Facebook)

**Typography**
- Import Inter font from Google Fonts
- Apply as primary font family site-wide
- Configure in application layout head section

**Icons**
- Use Heroicons library (already compatible with Tailwind)
- Calendar icon for date display
- Map pin icon for location
- No icon for distances row (badges are self-explanatory)

**Favicon**
- Create mxcorre favicon for browser tab
- Save to `app/assets/images/favicon.ico` or use Rails favicon helper

**Image Fallback**
- Create placeholder image for races without featured_image
- Save to `app/assets/images/placeholder-race.jpg`
- Use defensive coding: check `race.featured_image.attached?` before displaying

## Existing Code to Leverage

**Race Model (app/models/race.rb)**
- Has `published` scope filtering by status
- Has `upcoming` scope filtering published races with future start_time
- Has `by_city` scope for future filtering feature
- Has `has_one_attached :featured_image` for card images
- Has `has_many :race_distances` association

**RaceDistance Model (app/models/race_distance.rb)**
- Belongs to race with distance_value and distance_unit fields
- distance_unit enum: km (0), miles (1)
- Can format display as "5K", "10K", "21K", etc.

**PagesController (app/controllers/pages_controller.rb)**
- Existing `home` action to modify
- Add query: `Race.upcoming.includes(:race_distances, featured_image_attachment: :blob).order(:start_time)`
- Group races by month for view rendering

**Application Layout (app/views/layouts/application.html.erb)**
- Existing layout with meta tags and asset loading
- Modify to include navbar partial and site background
- Update title and add Inter font import

**Test Fixtures (test/fixtures/races.yml, race_distances.yml)**
- Published races with various cities and distances available
- Use fixtures for controller and system tests
- Includes races with different costs (free and paid)

**Skeleton Loading**
- Display skeleton placeholders while race card images load
- Skeleton matches card layout structure
- Improves perceived performance on mobile

## Out of Scope
- City filtering functionality (roadmap item 5)
- Search functionality
- Pagination or infinite scroll (display all races on single page)
- Race detail page content (roadmap item 4, separate spec) - links will work but page won't exist yet
- Breadcrumb navigation (depends on city filtering)
- Start time display on cards (saved for detail page)
- "Days until race" countdown indicator
- User authentication or personalization
- Admin interface for managing races
