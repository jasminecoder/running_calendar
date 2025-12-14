## Accessibility Standards (Rails + Tailwind)

- **Semantic HTML**: Use `<nav>`, `<main>`, `<article>`, `<button>`, `<a>` appropriately
- **Form Labels**: Always use `<label for="field_id">` or wrap inputs in labels
- **Focus States**: Use Tailwind's `focus:` and `focus-visible:` utilities
- **Color Contrast**: Minimum 4.5:1 for text; use Tailwind's accessible color palette
- **Alt Text**: Provide meaningful `alt` for images; use `alt=""` for decorative images

```erb
<%# Good: Accessible card component %>
<article class="bg-white rounded-lg shadow" aria-labelledby="race-<%= race.id %>">
  <%= image_tag race.photo, alt: "#{race.name} race course", class: "rounded-t-lg" %>
  <div class="p-4">
    <h2 id="race-<%= race.id %>" class="text-lg font-semibold"><%= race.name %></h2>
    <p class="text-gray-600"><%= race.date.strftime("%B %d, %Y") %></p>
    <%= link_to "View Details", race,
        class: "mt-2 inline-block text-blue-600 hover:text-blue-800 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2" %>
  </div>
</article>
```

**Tailwind Focus Classes**:
```html
focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2
```
