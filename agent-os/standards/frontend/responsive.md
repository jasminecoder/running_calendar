## Mobile-First Responsive Design (Tailwind)

- **Mobile-First**: Write base styles for mobile, add larger screen overrides
- **Breakpoints**: `sm:` (640px), `md:` (768px), `lg:` (1024px), `xl:` (1280px)
- **Touch Targets**: Minimum 44x44px tap targets (`min-h-11 min-w-11` or `p-3`)
- **Readable Typography**: `text-base` (16px) minimum for body text
- **Fluid Containers**: Use `container mx-auto px-4` for centered, responsive layouts

```erb
<%# Good: Mobile-first race listing %>
<main class="container mx-auto px-4 py-6">
  <h1 class="text-2xl md:text-3xl font-bold mb-4">Upcoming Races</h1>

  <%# Single column mobile, multi-column desktop %>
  <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4 md:gap-6">
    <% @races.each do |race| %>
      <%= render "races/race_card", race: race %>
    <% end %>
  </div>
</main>

<%# Good: Touch-friendly navigation %>
<nav class="fixed bottom-0 inset-x-0 bg-white border-t sm:static sm:border-0">
  <div class="flex justify-around py-2">
    <%= link_to "Home", root_path, class: "p-3 min-h-11" %>
    <%= link_to "Races", races_path, class: "p-3 min-h-11" %>
    <%= link_to "Submit", new_race_submission_path, class: "p-3 min-h-11" %>
  </div>
</nav>
```

**Testing**: Test on real devices or Chrome DevTools device mode.
