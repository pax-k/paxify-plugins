---
paths:
  - "{{frontend_glob}}"
---
# Frontend / React Patterns

{{#if_nextjs}}
- Server Components by default. Only add `"use client"` when the component needs interactivity (event handlers, hooks, browser APIs).
- Use Next.js App Router conventions: `page.tsx`, `layout.tsx`, `loading.tsx`, `error.tsx`.
- Data fetching in Server Components. Client components receive data as props.
{{/if_nextjs}}

{{#if_not_nextjs}}
- Components are functional. No class components.
- Keep components focused — one responsibility per component.
{{/if_not_nextjs}}

- **Check existing components before building new ones.** Reuse what exists.
- Colocate component, styles, and tests in the same directory.
- Props: use TypeScript interfaces. Destructure in function signature.
- State management: use React state/context for UI state. Server state belongs in the data layer.
- Forms: use controlled components with validation (react-hook-form + zod if available in project).
- Avoid prop drilling beyond 2 levels — use context or composition.
- No inline styles. Use the project's CSS solution (CSS modules, Tailwind, styled-components — check existing patterns).
- Accessibility: semantic HTML, ARIA labels on interactive elements, keyboard navigation.
