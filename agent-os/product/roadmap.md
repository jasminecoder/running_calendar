# Product Roadmap

1. [ ] Race Model and Database Schema — Create the Race model with all necessary fields (name, date, start time, location, city, distance (although not the rule, some races could have a few different distances like 5k and 10k), description, photo, registration URL, day of race registration(yes/no), status) and database migrations `S`

2. [ ] Race Cards List Page — Build the main landing page displaying race cards ordered by upcoming date, with each card showing the race photo, name, date, distance and location `M`

3. [ ] Race Detail Page — Create a dedicated page for each race showing full details including photo, name, date, time, location, distance(s), description, registration link, and any additional race information `S`

4. [ ] City Filtering — Add the ability to filter races by city (Tijuana, Rosarito, Tecate, Mexicali) so runners can focus on races in their specific area `S`

5. [ ] Admin Race Management — Build an admin interface for managing races (create, edit, delete, publish/unpublish) so site administrators can maintain the race database `M`

6. [ ] Race Submission Request Form — Create a public form where race organizers can submit their race details for review, including all relevant race information and organizer contact details `M`

7. [ ] Admin Submission Review — Build admin functionality to review, approve, or reject race submissions, with the ability to convert approved submissions into published races `S`

8. [ ] Image Upload and Optimization — Implement image upload for race photos with automatic optimization for mobile devices to ensure fast load times `S`

9. [ ] Distance Filtering — Add filtering by race distance (5K, 10K, 21K, 42K, ultra) to help runners find races matching their preferred distance `S`

10. [ ] SEO and Social Sharing — Implement meta tags, Open Graph data, and structured data for races to improve search engine visibility and social media sharing `S`

11. [ ] Email Notifications for Submissions — Send confirmation emails to organizers when they submit a race and when their submission is approved or rejected `S`

12. [ ] Past Races Archive — Create a section to view past races, allowing runners to research historical events and see what races happen annually `S`

> Notes
> - Order reflects technical dependencies and path to MVP (items 1-5 deliver core runner value)
> - Items 6-7 complete the race organizer submission flow
> - Items 8-12 are enhancements that improve user experience and growth
> - Each item represents a complete, testable feature with both frontend and backend components
