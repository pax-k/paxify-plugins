# Security

- **No secrets in code.** API keys, tokens, passwords, connection strings go in environment variables only.
- Never log secrets, tokens, or passwords — even in debug/development mode.
- Validate ALL external input at system boundaries: user input, API request bodies, query parameters, headers.
- Use parameterized queries for ALL database operations. Never concatenate user input into SQL.
- Sanitize output to prevent XSS — use framework-provided escaping (React handles this by default).
- Never use `dangerouslySetInnerHTML` (React) or equivalent without explicit sanitization.
- Never use `eval()`, `new Function()`, or `child_process.exec` with user-controlled input.
- Set appropriate CORS headers — never use `Access-Control-Allow-Origin: *` in production.
- Use HTTPS for all external API calls.
- Dependencies: prefer well-maintained packages with small dependency trees. Audit before adding.
