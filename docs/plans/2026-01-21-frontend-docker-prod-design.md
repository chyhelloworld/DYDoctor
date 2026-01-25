# Frontend Docker Production Implementation Plan (Design)

**Goal:** Run the Vue3 admin frontend in Docker using a production build served by Nginx.

**Architecture:** Multi-stage Docker build. Stage 1 installs pnpm dependencies and runs
`pnpm build:prod` to generate static assets in `dist-prod`. Stage 2 uses Nginx to serve
the built assets with SPA fallback to `index.html` and gzip enabled. A new Docker Compose
service exposes the frontend on a host port and relies on the existing backend via
`http://localhost:48080`.

**Components:**
- `yudao-ui-admin-vue3-master/Dockerfile`: build + Nginx runtime image.
- `yudao-ui-admin-vue3-master/nginx.conf`: SPA fallback and gzip.
- `docker-compose.yml`: add frontend service mapping a host port.

**Data flow:** Browser requests static assets from Nginx. API calls use
`VITE_BASE_URL=http://localhost:48080` and `VITE_API_URL=/admin-api`, so requests go to
the backend mapped to the host.

**Error handling:** Build errors fail the image build. Runtime errors surface via
`docker logs` for the frontend container. If the backend is unavailable, the frontend
will show API errors as usual.

**Testing:** Build and run the frontend container, then open
`http://localhost:<port>` to confirm UI loads. Verify a basic API call (e.g., login) to
ensure proxy base URL is correct.
