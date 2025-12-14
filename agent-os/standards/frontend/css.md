## Tailwind CSS Standards

- **Utility-First**: Use Tailwind utilities directly in markup; avoid custom CSS
- **Component Extraction**: Use `@apply` sparingly, only for highly-reused patterns
- **Design Tokens**: Use Tailwind's spacing, colors, and typography scales consistently
- **Responsive Prefixes**: Mobile-first with `sm:`, `md:`, `lg:` breakpoints
- **State Variants**: Use `hover:`, `focus:`, `active:`, `disabled:` prefixes

```erb
<%# Good: Tailwind utilities %>
<button class="bg-blue-600 text-white px-4 py-2 rounded-lg
               hover:bg-blue-700 focus:ring-2 focus:ring-blue-500
               disabled:opacity-50 disabled:cursor-not-allowed">
  Submit
</button>

<%# Good: Responsive design %>
<div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
  <%= render @races %>
</div>
```

**Custom CSS (use sparingly)**:
```css
/* app/assets/stylesheets/application.css */
@tailwind base;
@tailwind components;
@tailwind utilities;

@layer components {
  .btn-primary {
    @apply bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700;
  }
}
```

**Purge unused CSS**: Tailwind automatically purges in production via `content` config.
