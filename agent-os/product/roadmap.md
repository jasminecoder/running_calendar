# Product Roadmap

1. [x] Push the app to Hetzner

2. [ ] Race Model and Database Schema — Create the Race model with all necessary fields (name, date, start time, location description, location address (optional), city, distance (although not the rule, some races could have a few different distances like 5k and 10k), image, registration URL (optional), registration info (text field), day of race registration(yes/no), cost, notes (optional), status) and database migrations `S`

3. [ ] Race Cards List Page — Build the main landing page displaying race cards ordered by upcoming date, with each card showing the race photo, name, date, distance and location `M`

4. [ ] Race Detail Page — Create a dedicated page for each race showing full details including photo, name, date, time, location, distance(s), description, registration link, and any additional race information `S`

5. [ ] City Filtering — Add the ability to filter races by city (Tijuana, Rosarito, Tecate, Mexicali) so runners can focus on races in their specific area `S`

6. [ ] Admin Race Management — Build an admin interface for managing races (create, edit, delete, publish/unpublish) so site administrators can maintain the race database `M`

7. [ ] Admin Authentication — Implement admin-only authentication (Devise) so only you can access race management. No user/organizer login needed for now `S`

8. [ ] Race Submission Form (Admin-Only) — Create a private form accessible only to logged-in Admin for entering race details and publishing directly `M`

9. [ ] Admin Dashboard — Build admin view to see all races (drafts, published, completed, cancelled), with ability to edit, delete, and change status `S`

10. [ ] Contact Form for Organizers — Create a public contact form where race organizers can send you race details via email. You review and manually enter races `S`

11. [ ] Image Upload and Optimization — Implement image upload for race photos with automatic optimization for mobile devices to ensure fast load times `S`

12. [ ] Distance Filtering — Add filtering by race distance (5K, 10K, 21K, 42K, ultra) to help runners find races matching their preferred distance `S`

13. [ ] SEO and Social Sharing — Implement meta tags, Open Graph data, and structured data for races to improve search engine visibility and social media sharing `S`

14. [ ] Email Notifications for Submissions — Send confirmation emails to organizers when they submit a race and when their submission is approved or rejected `S`

15. [ ] Past Races Archive — Create a section to view past races, allowing runners to research historical events and see what races happen annually `S`

16. [ ] GitHub Actions CI/CD Pipeline — Set up automated deployment pipeline with GitHub Actions to replace manual `kamal deploy` commands `S`

17. [ ] Error Monitoring with Sentry — Integrate Sentry for error tracking and alerting to catch production issues quickly `S`

18. [ ] Auto-scaling and Load Balancing — Add infrastructure for horizontal scaling and load balancing to handle traffic spikes `M`

19. [ ] Custom Domain Email — Configure custom domain email for transactional emails (submission confirmations, approvals) `S`

> Notes
> - **Mobile-first**: All public-facing pages should be optimized for mobile phone users (runners checking races on the go)
> - Order reflects technical dependencies and path to MVP (items 1-6 deliver core runner value)
> - Items 7-10 complete admin authentication and race entry workflow
> - Items 11-15 are enhancements that improve user experience and growth
> - Items 16-19 are infrastructure improvements for reliability and operations
> - Organizer authentication/portal can be added later if needed
> - Each item represents a complete, testable feature with both frontend and backend components
