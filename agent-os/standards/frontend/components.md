## Rails View Component Standards

- **Partials for Reuse**: Extract repeated markup into `app/views/shared/` or resource partials
- **Locals Over Instance Variables**: Pass data via `locals:` in partials
- **Stimulus for Interactivity**: Use Stimulus controllers for JavaScript behavior
- **Turbo Frames for Updates**: Wrap dynamic sections in `turbo_frame_tag`

```erb
<%# app/views/races/_race_card.html.erb %>
<article class="bg-white rounded-lg shadow p-4">
  <%= image_tag race.photo, class: "w-full h-48 object-cover rounded" if race.photo.attached? %>
  <h3 class="font-bold text-lg mt-2"><%= race.name %></h3>
  <p class="text-gray-600"><%= race.date.strftime("%b %d, %Y") %></p>
  <p class="text-sm text-gray-500"><%= race.city.titleize %></p>
  <%= link_to "View", race, class: "text-blue-600 hover:underline" %>
</article>

<%# Usage %>
<%= render partial: "races/race_card", collection: @races, as: :race %>
```

**Stimulus Controller**:
```javascript
// app/javascript/controllers/toggle_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content"]

  toggle() {
    this.contentTarget.classList.toggle("hidden")
  }
}
```

```erb
<div data-controller="toggle">
  <button data-action="toggle#toggle">Show/Hide</button>
  <div data-toggle-target="content" class="hidden">Content</div>
</div>
```
