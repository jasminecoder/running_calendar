# Spec Requirements: Race Cards List Page

## Initial Description

**Race Cards List Page** — Build the main landing page displaying race cards ordered by upcoming date, with each card showing the race photo, name, date, distance and location

This is roadmap item 3 (Size: M).

Context from roadmap notes:
- Mobile-first: All public-facing pages should be optimized for mobile phone users (runners checking races on the go)
- This delivers core runner value as part of the MVP

## Requirements Discussion

### First Round Questions

**Q1:** I assume each race card should display: featured image (as background or hero), race name, date (formatted in Spanish, e.g., "15 de Enero, 2025"), city/location, and distance(s). For races with multiple distances (5K + 10K), should we show all distances on the card (e.g., "5K / 10K") or just the shortest/longest?
**Answer:** Show all distances with square button styling (not links, but text surrounded by space and border like buttons)

**Q2:** I'm thinking the race cards should be displayed in a single-column vertical stack on mobile (full-width cards) for easy thumb scrolling, and potentially 2-3 columns on larger screens. Is that the right approach, or would you prefer a different layout?
**Answer:** Yes, single-column on mobile, 2-3 columns on larger screens. Cards with no borders, white background. Card structure top to bottom:
- Image
- Name
- Line separator
- Calendar icon + date
- Place icon + place
- Runner icon + all distances in button style (single row)
- City in button style (separate row from distances)
Button styling for distances and city to grab user attention (don't need to be big, just visually different)

**Q3:** For the race date display, should we show the full date with day of week (e.g., "Sabado, 15 de Enero 2025") or a more compact format? Also, should we show the start time on the card or save that for the detail page?
**Answer:** Full format: "Sabado, 15 de Enero 2025". Save start time for detail page.

**Q4:** I assume this page will be the homepage (root route `/`) since it's the main landing page. Is that correct, or should it live at a different URL like `/carreras` or `/races`?
**Answer:** Homepage (root route `/`). Note: There's an existing homepage route that can be modified.

**Q5:** Should we display a page header or hero section above the race cards (e.g., "Carreras en Baja California" with a brief tagline), or should the page jump straight into the race cards?
**Answer:** YES to navbar and small hero section.

**Navbar details:**
- "mxcorre" logo/text on left, playful hamburger menu on right (top and bottom lines longer than middle line)
- Hidden hamburger menu will have "contact us" button for now (more links added later)
- Site background: darkish blue on left transitioning to burgundy on right
- Navbar background: same as site but slightly more transparent
- "mxcorre" text: playful styling using color #9CCC65 (green) along with white
- Continue using this green or variations where design-appropriate

**Hero section details:**
- Image of runner running a race
- Text overlay: "Proximas carreras en Tijuana" (city changes based on filter)

**Below hero:**
- Month subheading separating races: "Diciembre 2025" (same green color as site name)
- When city filtering is implemented later: breadcrumb path like "Todas las carreras > Tijuana"

**Q6:** For the MVP, I assume we'll show all upcoming published races on a single scrolling page without pagination. If there are many races, should we add "load more" functionality, or is simple pagination acceptable? Or is this out of scope for now?
**Answer:** Show all upcoming races on single scrolling page (no pagination for MVP)

**Q7:** What should the page show when there are no upcoming races? I'm thinking a friendly message like "No hay carreras proximas. Vuelve pronto!" with perhaps a suggestion to check back. Is that acceptable?
**Answer:** Yes: "No hay carreras proximas. Vuelve pronto!"

**Q8:** Is there anything specific you want to EXCLUDE from this first version? For example: filtering by city, search functionality, or any interactive features?
**Answer:** Skip filtering by city for now. Skip search functionality. Add both to roadmap for later.

### Existing Code to Reference

**Similar Features Identified:**
- Existing homepage: `app/views/pages/home.html.erb` - placeholder page that will be replaced
- Existing layout: `app/views/layouts/application.html.erb` - base layout to modify/extend
- Existing routes: `config/routes.rb` - root route already points to `pages#home`
- Race model: `app/models/race.rb` - has scopes for `published`, `upcoming`, `by_city`
- RaceDistance model: `app/models/race_distance.rb` - belongs_to race, has distance_value and distance_unit

### Follow-up Questions

No follow-up questions were needed. User provided comprehensive answers.

## Visual Assets

### Files Provided:
No visual assets provided.

### Visual Insights:
User provided detailed textual descriptions of the desired design instead of visual mockups.

## Requirements Summary

### Functional Requirements

**Page Structure:**
- Replace existing homepage at root route (`/`)
- Mobile-first responsive design (single column mobile, 2-3 columns desktop)
- Display all upcoming published races ordered by date
- Group races by month with month subheadings

**Navbar:**
- "mxcorre" logo/text on left with playful styling
- Colors: #9CCC65 (green) combined with white
- Hamburger menu on right with playful styling (top/bottom lines longer than middle)
- Hamburger menu opens/closes on click (Stimulus controller)
- Menu contains "contact us" link (placeholder for future links)
- Background: same gradient as site but slightly more transparent

**Site Background:**
- Gradient from darkish blue (left) to burgundy (right)

**Hero Section:**
- Image of runner running a race
- Image specs: 1920x600px, JPEG, <200KB
- Image path: `app/assets/images/hero-runner.jpg` (user provides)
- Text overlay: "Próximas carreras en Tijuana" (with accent)
- Text will change based on city filter (future feature)

**Month Subheadings:**
- Format: "Diciembre 2025"
- Color: #9CCC65 (green, same as logo)
- Separates races by month

**Race Card Design:**
- No borders, white background, rounded corners (`rounded-lg`)
- Entire card is clickable (links to `/races/:id`)
- Subtle hover effect (lift/shadow) for polish
- Image fallback: placeholder image if featured_image missing
- Structure (top to bottom):
  1. Featured image (16:9 aspect ratio)
  2. Race name
  3. Line separator (1px, #E5E7EB gray-200)
  4. Calendar icon + date ("Sábado, 15 de Enero 2025") - with accent
  5. Place icon + location_description
  6. Cost display ("Gratis" or "$250 MXN")
  7. Distance badges in button-style (single row, no icon)
  8. City badge in button-style (separate row)
- Button styling for distances and city (bordered, not actual links)

**Footer:**
- Simple footer with copyright
- "Hecho con ❤️ en Baja California" or similar
- Social links if available (Instagram, Facebook)

**Empty State:**
- Message: "No hay carreras próximas. ¡Vuelve pronto!"

### Reusability Opportunities

- Existing `pages#home` controller action and route can be repurposed
- Race model scopes (`published`, `upcoming`) ready to use
- Application layout can be extended with navbar
- Tailwind CSS already configured for styling

### Scope Boundaries

**In Scope:**
- Navbar with logo and hamburger menu (opens/closes via Stimulus)
- Hero section with runner image and text overlay
- Race cards list displaying all upcoming published races
- Clickable cards linking to `/races/:id`
- Cost display on cards
- Month subheadings grouping races
- Footer with copyright and social links
- Responsive layout (mobile-first)
- Empty state message
- Spanish language content (with proper accents)
- Inter font typography
- Heroicons for icons
- Smooth scrolling
- Skeleton loading for cards
- Favicon
- Card hover effects
- Image fallback for races without featured_image

**Out of Scope:**
- City filtering (roadmap item 5)
- Search functionality (future roadmap item)
- "Days until race" indicator (future enhancement)
- Pagination or infinite scroll
- Race detail page (roadmap item 4 - separate spec)
- Breadcrumb navigation (waiting for city filtering)
- Start time display (saved for detail page)

### Technical Considerations

**Data Requirements:**
- Query: `Race.upcoming.includes(:race_distances).order(:start_time)`
- Need to eager load race_distances to avoid N+1
- Need to eager load featured_image attachment
- Group races by month for subheadings

**Date Formatting:**
- Spanish locale formatting required (UTF-8 encoding)
- Format: "Sábado, 15 de Enero 2025" (with proper accents)
- Day names: Lunes, Martes, Miércoles, Jueves, Viernes, Sábado, Domingo

**Image Handling:**
- Featured image displayed on each card (16:9 aspect ratio)
- Fallback placeholder image for races without featured_image
- Hero image: user provides `app/assets/images/hero-runner.jpg` (1920x600px)

**Color Palette:**
- Primary green: #9CCC65
- Background gradient: darkish blue to burgundy (exact colors TBD)
- Card background: white
- Line separator: #E5E7EB (gray-200)
- Navbar: semi-transparent version of site gradient

**Typography:**
- Primary font: Inter (clean, modern, highly readable on mobile)
- Import via Google Fonts or self-host

**Icons:**
- Library: Heroicons (free, works great with Tailwind)
- Calendar icon (for date)
- Place/location icon (for location)
- Hamburger menu icon (custom: top/bottom lines longer than middle)
- No icon needed for distances (badges are self-explanatory)

**Responsive Breakpoints:**
- Mobile: single column cards
- Tablet/Desktop: 2-3 column grid

**UX Enhancements:**
- Smooth scrolling between sections
- Skeleton loading for race cards while images load
- Favicon: small mxcorre icon in browser tab
- Card hover effect: subtle lift/shadow

### Future Enhancements (Out of Scope for MVP)
- "Days until race" indicator on cards (e.g., "En 5 días", "Esta semana")
- City filtering (roadmap item 5)
- Search functionality
- Breadcrumb navigation when filtering by city
