---
paths:
  - "{{backend_glob}}"
---
# Backend / API Design

- **Database access ONLY through the data access layer** ({{db_layer}}). Never write raw SQL in route handlers.
- Every endpoint: validate input → process → respond. Validation happens at the boundary.
- Use proper HTTP status codes: 200 OK, 201 Created, 400 Bad Request, 401 Unauthorized, 403 Forbidden, 404 Not Found, 500 Internal Server Error.
- Error responses: consistent shape `{ error: { code: string, message: string } }`. Never leak stack traces to clients.
- Input validation: use zod or similar schema validation. Define schemas once, reuse across validation and types.
- Authentication/authorization checks at the route/middleware level, not in business logic.
- Keep route handlers thin — delegate to service functions for business logic.
- Logging: log request context (method, path, duration) on every request. Log errors with stack traces server-side only.
- Rate limiting on public-facing endpoints.
- API versioning: use path prefix (`/api/v1/`) or header-based versioning if the project has conventions.
