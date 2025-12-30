# Task Breakdown: Race Cards List Page

## Overview
Total Tasks: 6 Task Groups

This feature builds the main homepage for mxcorre.com displaying upcoming race cards ordered by date, grouped by month, with a branded navbar and hero section, optimized for mobile-first viewing.

**Note:** Before starting implementation, user must provide:
- `app/assets/images/hero-runner.jpg` (1920x600px, JPEG, <200KB)

## Task List

### Configuration & Setup

#### Task Group 1: I18n Configuration and Typography Setup
**Dependencies:** None

- [ ] 1.0 Complete configuration and setup layer
  - [ ] 1.1 Write 2-4 focused tests for Spanish locale date formatting
    - Test file: `test/helpers/application_helper_test.rb`
    - Test date formatting outputs "Sábado, 15 de Enero 2025" format (with accents)
    - Test month formatting outputs "Enero 2025" format
    - Test "Gratis" display for zero cost races
    - Test currency formatting for paid races ("$250 MXN")
  - [ ] 1.2 Create Spanish locale file for date formatting
    - Create `config/locales/es.yml` (UTF-8 encoding)
    - Add Spanish day names with accents: Lunes, Martes, Miércoles, Jueves, Viernes, Sábado, Domingo
    - Add Spanish month names: Enero, Febrero, Marzo, Abril, Mayo, Junio, Julio, Agosto, Septiembre, Octubre, Noviembre, Diciembre
    - Configure date format: "%A, %d de %B %Y"
    - Configure month-year format: "%B %Y"
  - [ ] 1.3 Set default locale to Spanish in application config
    - Update `config/application.rb` with `config.i18n.default_locale = :es`
    - Add available locales configuration
  - [ ] 1.4 Add Inter font to application layout
    - Add Google Fonts link for Inter in `<head>` section
    - Configure font-family in Tailwind config or CSS
  - [ ] 1.5 Add favicon for browser tab
    - Create or obtain mxcorre favicon
    - Save to `app/assets/images/favicon.ico`
    - Add favicon link tag to application layout
  - [ ] 1.6 Add helper method for cost display formatting
    - Create helper method in `ApplicationHelper` or `RacesHelper`
    - Return "Gratis" for cost == 0
    - Return formatted price "$X MXN" for cost > 0
  - [ ] 1.7 Add display_distance method to RaceDistance model
    - Method returns formatted string like "5K", "10K", "21K"
    - Handle km and miles units appropriately
  - [ ] 1.8 Ensure configuration tests pass
    - Run ONLY the 2-4 tests written in 1.1
    - Verify locale files load correctly
    - Verify helper methods work as expected

**Acceptance Criteria:**
- The 2-4 tests written in 1.1 pass
- Spanish dates format correctly with accents ("Sábado, 15 de Enero 2025")
- Month groupings format correctly ("Enero 2025")
- Inter font loads and applies site-wide
- Favicon displays in browser tab
- Cost helper displays "Gratis" or formatted price
- RaceDistance displays "5K", "10K", etc.

### Backend Layer

#### Task Group 2: Controller and Data Query Logic
**Dependencies:** Task Group 1

- [ ] 2.0 Complete backend controller layer
  - [ ] 2.1 Write 3-5 focused tests for PagesController#home
    - Test file: `test/controllers/pages_controller_test.rb`
    - Test that page loads successfully (status 200)
    - Test that only upcoming published races are displayed
    - Test that races are ordered by start_time ascending
    - Test that races are grouped by month correctly
    - Test empty state displays when no upcoming races exist
  - [ ] 2.2 Update PagesController#home action
    - Query: `Race.upcoming.includes(:race_distances, featured_image_attachment: :blob).order(:start_time)`
    - Group races by month using `group_by { |race| race.start_time.beginning_of_month }`
    - Assign to `@races_by_month` instance variable
    - Handle empty state when no races exist
  - [ ] 2.3 Ensure controller tests pass
    - Run ONLY the 3-5 tests written in 2.1
    - Verify eager loading prevents N+1 queries
    - Verify month grouping works correctly

**Acceptance Criteria:**
- The 3-5 tests written in 2.1 pass
- Only published, upcoming races are queried
- Races are eager loaded with associations (no N+1)
- Races are grouped by month for view rendering
- Empty state is handled gracefully

### Frontend Components

#### Task Group 3: Layout, Navbar, Hero, and Footer Components
**Dependencies:** Task Group 2

- [ ] 3.0 Complete page layout and structural components
  - [ ] 3.1 Write 3-5 focused system tests for layout components
    - Test file: `test/system/home_page_test.rb`
    - Test navbar displays mxcorre logo/text
    - Test hamburger menu is visible and toggles on click
    - Test hero section displays with text overlay
    - Test footer displays copyright and tagline
    - Test background gradient is applied
  - [ ] 3.2 Update application layout for race cards page
    - Apply site background gradient: `linear-gradient(90deg, #1E3A5F 0%, #722F37 100%)`
    - Update page title to "mxcorre - Carreras en Baja California"
    - Modify main container styling for full-width layout
    - Add smooth scrolling CSS (`scroll-behavior: smooth`)
  - [ ] 3.3 Create navbar partial (`app/views/shared/_navbar.html.erb`)
    - Position fixed at top of page
    - "mxcorre" logo/text on left with #9CCC65 green and white styling
    - Custom hamburger menu on right (top/bottom lines longer than middle)
    - Semi-transparent background matching site gradient
    - Hamburger menu contains "contact us" link (hidden by default)
  - [ ] 3.4 Create Stimulus controller for hamburger menu toggle
    - Create `app/javascript/controllers/menu_controller.js`
    - Toggle menu visibility on hamburger click
    - Add smooth open/close animation
  - [ ] 3.5 Create hero section partial (`app/views/shared/_hero.html.erb`)
    - Display runner image from `app/assets/images/hero-runner.jpg`
    - Image specs: 1920x600px, JPEG, <200KB (user provides)
    - Text overlay: "Próximas carreras en Tijuana" (with accent)
    - Mobile-first responsive sizing
    - Position below navbar
  - [ ] 3.6 Create footer partial (`app/views/shared/_footer.html.erb`)
    - Copyright text with dynamic current year
    - Tagline: "Hecho con ❤️ en Baja California"
    - Placeholder for social links (Instagram, Facebook icons)
    - Simple styling matching site theme
  - [ ] 3.7 Create placeholder pages to prevent 404 errors
    - Create `RacesController#show` with `@race = Race.find(params[:id])`
    - Create `app/views/races/show.html.erb` with race name + "Detalles próximamente..."
    - Create `ContactController#index` action
    - Create `app/views/contact/index.html.erb` with "Contáctanos" + placeholder email
    - Add routes: `resources :races, only: [:show]` and `get 'contact', to: 'contact#index'`
  - [ ] 3.8 Render partials in application layout or home view
    - Include navbar at top of body
    - Include footer after main content
  - [ ] 3.9 Ensure layout component tests pass
    - Run ONLY the 3-5 tests written in 3.1
    - Verify navbar renders correctly
    - Verify hamburger menu toggles
    - Verify hero section renders correctly
    - Verify footer renders correctly
    - Verify placeholder pages load without errors

**Acceptance Criteria:**
- The 3-5 tests written in 3.1 pass
- Navbar displays with logo and hamburger menu
- Hamburger menu opens/closes on click (Stimulus controller works)
- Hero section shows runner image with text overlay
- Footer displays copyright and tagline
- Background gradient applies correctly
- Layout is responsive and mobile-first
- Smooth scrolling enabled
- Placeholder pages work: `/races/:id` and `/contact` don't 404

#### Task Group 4: Race Cards and List Display
**Dependencies:** Task Group 3

- [ ] 4.0 Complete race cards and list display
  - [ ] 4.1 Write 4-6 focused system tests for race cards
    - Test file: `test/system/race_cards_test.rb`
    - Test race card displays race name and featured image
    - Test race card displays formatted date with calendar icon
    - Test race card displays location with place icon
    - Test race card displays cost ("Gratis" or formatted price)
    - Test race card displays distance badges (e.g., "5K", "10K")
    - Test month subheadings display correctly ("Enero 2025")
    - Test card links to `/races/:id`
  - [ ] 4.2 Create placeholder image for races without featured_image
    - Create `app/assets/images/placeholder-race.jpg`
    - Simple placeholder with mxcorre branding or generic race image
  - [ ] 4.3 Create race card partial (`app/views/races/_race_card.html.erb`)
    - White background, no borders, rounded corners (`rounded-lg`)
    - Entire card clickable (link to `/races/:id`)
    - Defensive coding: check `race.featured_image.attached?` with fallback
    - Structure top-to-bottom:
      - Featured image (16:9 aspect ratio)
      - Race name
      - Line separator (1px, #E5E7EB gray-200)
      - Calendar icon + formatted date
      - Place icon + location_description
      - Cost display row
      - Distance badges (button-style, single row, no icon)
      - City badge (button-style, separate row)
    - Subtle hover effect (shadow/lift) for desktop
  - [ ] 4.4 Install and configure Heroicons
    - Add heroicons gem or use inline SVGs
    - Configure calendar and map-pin icons
    - Ensure icons scale appropriately
  - [ ] 4.5 Create distance badge component styling
    - Button-style badges (bordered text, not clickable)
    - Small sizing to avoid overwhelming card
    - Display all distances in single row
  - [ ] 4.6 Create city badge component styling
    - Same button-style as distance badges
    - Separate row from distances
    - Capitalize city name for display
  - [ ] 4.7 Create month subheading component
    - Format: "Enero 2025" in Spanish
    - Color: #9CCC65 (green matching logo)
    - Position between month groups
  - [ ] 4.8 Update home view (`app/views/pages/home.html.erb`)
    - Replace placeholder content
    - Render hero section
    - Iterate over `@races_by_month` grouped races
    - Display month subheadings between groups
    - Render race cards in responsive grid
    - Display empty state when no races
  - [ ] 4.9 Implement responsive grid layout
    - Single-column on mobile (full-width cards)
    - 2-column grid on tablet (md breakpoint)
    - 3-column grid on desktop (lg breakpoint)
    - Consistent spacing with Tailwind gap utilities
  - [ ] 4.10 Create skeleton loading component
    - Skeleton placeholder matching race card layout
    - Display while images are loading
    - Use CSS animation for loading effect
  - [ ] 4.11 Create empty state component
    - Message: "No hay carreras próximas. ¡Vuelve pronto!"
    - Center on page with friendly styling
    - Display when `@races_by_month` is empty
  - [ ] 4.12 Ensure race cards tests pass
    - Run ONLY the 4-6 tests written in 4.1
    - Verify cards render with all required elements
    - Verify responsive layout works
    - Verify empty state displays correctly
    - Verify skeleton loading appears

**Acceptance Criteria:**
- The 4-6 tests written in 4.1 pass
- Race cards display all required information
- Cards link to `/races/:id` and have hover effects
- Line separator is 1px gray (#E5E7EB)
- Distance and city badges render correctly (no runner icon)
- Month subheadings display in correct format and color (#9CCC65)
- Responsive grid layout works across breakpoints
- Skeleton loading displays while images load
- Placeholder image shows for races without featured_image
- Empty state displays when no races exist

### Testing

#### Task Group 5: Test Review and Gap Analysis
**Dependencies:** Task Groups 1-4

- [ ] 5.0 Review existing tests and fill critical gaps only
  - [ ] 5.1 Review tests from Task Groups 1-4
    - Review 2-4 tests from configuration layer (Task 1.1)
    - Review 3-5 tests from controller layer (Task 2.1)
    - Review 3-5 tests from layout components (Task 3.1)
    - Review 4-6 tests from race cards (Task 4.1)
    - Total existing tests: approximately 12-20 tests
  - [ ] 5.2 Analyze test coverage gaps for THIS feature only
    - Identify critical user workflows lacking coverage
    - Focus ONLY on gaps related to race cards list page
    - Prioritize end-to-end user journey testing
    - Do NOT assess entire application test coverage
  - [ ] 5.3 Write up to 10 additional strategic tests maximum
    - Add maximum of 10 new tests for critical gaps
    - Focus on:
      - Full page load with multiple races across months
      - Image loading and display
      - Mobile vs desktop layout verification
      - Edge cases: single race, races all in same month
      - Link functionality (card clicks)
    - Skip exhaustive edge case testing
  - [ ] 5.4 Run feature-specific tests only
    - Run ONLY tests related to race cards list page
    - Expected total: approximately 22-30 tests maximum
    - Do NOT run entire application test suite
    - Verify all critical user workflows pass

**Acceptance Criteria:**
- All feature-specific tests pass (approximately 22-30 tests total)
- Critical user workflows for race cards list page are covered
- No more than 10 additional tests added
- Testing focused exclusively on this spec's requirements

---

### Deployment

#### Task Group 6: Deploy to Production
**Dependencies:** Task Groups 1-5

- [ ] 6.0 Deploy to production
  - [ ] 6.1 Run full test suite locally
    - Run `bin/rails test`
    - Verify all tests pass before deploying
  - [ ] 6.2 Commit all changes to git
    - Review changed files with `git status`
    - Stage and commit with descriptive message
  - [ ] 6.3 Deploy to production with Kamal
    - Run `kamal deploy`
    - Monitor output for any errors
  - [ ] 6.4 Verify deployment in production
    - Visit mxcorre.com homepage
    - Verify navbar displays correctly
    - Verify hero section displays
    - Verify race cards display with correct data
    - Verify responsive layout on mobile
    - Verify hamburger menu opens/closes
  - [ ] 6.5 Test production functionality
    - Click on race cards to verify links work (will 404 until Race Detail Page is built)
    - Verify images load correctly
    - Verify Spanish date formatting displays correctly

**Acceptance Criteria:**
- All tests pass locally before deployment
- `kamal deploy` completes without errors
- Homepage displays correctly in production
- All visual elements render as designed
- Mobile experience works correctly

**Rollback Plan:**
- If deployment fails: `kamal rollback` to previous version

---

## Execution Order

Recommended implementation sequence:

1. **Configuration & Setup (Task Group 1)** - I18n, typography, favicon, helper methods
2. **Backend Layer (Task Group 2)** - Controller logic and data queries
3. **Layout Components (Task Group 3)** - Navbar, Stimulus controller, hero, footer, background
4. **Race Cards Display (Task Group 4)** - Cards, badges, skeleton loading, grid, empty state
5. **Test Review (Task Group 5)** - Gap analysis and additional coverage
6. **Deploy to Production (Task Group 6)** - Deploy to Kamal and verify

## Technical Notes

### Color Palette Reference
- Primary green: `#9CCC65`
- Background gradient: `linear-gradient(90deg, #1E3A5F 0%, #722F37 100%)`
  - Dark blue: `#1E3A5F`
  - Burgundy: `#722F37`
- Card background: white
- Line separator: `#E5E7EB` (gray-200)
- Navbar: semi-transparent version of site gradient

### Existing Code to Leverage
- `Race.upcoming` scope - filters published races with future start_time
- `Race.includes(:race_distances, featured_image_attachment: :blob)` - eager loading
- `race.race_distances` association - for distance badges
- `race.featured_image` attachment - for card images
- `race.city`, `race.cost`, `race.location_description` - card data

### Files to Create
- `config/locales/es.yml` - Spanish locale file (UTF-8)
- `app/views/shared/_navbar.html.erb` - Navbar partial
- `app/views/shared/_hero.html.erb` - Hero section partial
- `app/views/shared/_footer.html.erb` - Footer partial
- `app/views/races/_race_card.html.erb` - Race card partial
- `app/views/races/show.html.erb` - Placeholder race detail page
- `app/views/contact/index.html.erb` - Placeholder contact page
- `app/controllers/races_controller.rb` - Races controller with show action
- `app/controllers/contact_controller.rb` - Contact controller
- `app/javascript/controllers/menu_controller.js` - Stimulus controller for hamburger menu
- `app/assets/images/favicon.ico` - Browser tab icon
- `app/assets/images/placeholder-race.jpg` - Fallback image for races without featured_image

### Files User Must Provide
- `app/assets/images/hero-runner.jpg` - Hero section image (1920x600px, JPEG, <200KB)

### Files to Modify
- `config/application.rb` - Default locale setting
- `config/routes.rb` - Add races and contact routes
- `app/views/layouts/application.html.erb` - Layout updates, Inter font, favicon
- `app/views/pages/home.html.erb` - Home page content
- `app/controllers/pages_controller.rb` - Controller logic
- `app/models/race_distance.rb` - display_distance method
- `app/helpers/application_helper.rb` - Cost formatting helper

### Test Files to Create
- `test/helpers/application_helper_test.rb` - Helper method tests
- `test/controllers/pages_controller_test.rb` - Controller tests
- `test/system/home_page_test.rb` - Layout/component system tests
- `test/system/race_cards_test.rb` - Race card system tests
