# Repository Guidelines
中文回答问题
## Project Structure & Module Organization
This repo is a two-part app: backend under `ruoyi-vue-pro-master-jdk17/` and frontend under
`yudao-ui-admin-vue3-master/`. Documentation lives in `docs/`, helper scripts in `scripts/`, and
`docker-compose.yml` provisions local services. The backend is a multi-module Maven layout with
entrypoint `yudao-server/` and modules `yudao-module-*`, organized under
`cn.iocoder.yudao.module.{module}/...` with controller/service/dal/convert layers. The frontend
source is in `yudao-ui-admin-vue3-master/src/` with `api/`, `views/`, `components/`, `router/`,
and `store/`.

## Build, Test, and Development Commands
Backend (run from `ruoyi-vue-pro-master-jdk17/`):
- `mvn clean compile` build
- `mvn test` run unit tests
- `mvn clean package` create the runnable jar
- `java -jar yudao-server/target/yudao-server.jar --spring.profiles.active=local` run locally

Frontend (run from `yudao-ui-admin-vue3-master/`):
- `pnpm install` install dependencies (pnpm required)
- `pnpm dev` start the dev server
- `pnpm ts:check` type check
- `pnpm build:local` build
- `pnpm lint:eslint`, `pnpm lint:format`, `pnpm lint:style` lint and format

Local services:
- `docker-compose up -d` or `scripts/start-docker-services.bat` for OpenGauss and Redis
- Seed data via `ruoyi-vue-pro-master-jdk17/sql/` scripts when needed

## Coding Style & Naming Conventions
Frontend uses 2-space indentation (see `.editorconfig`) and enforces ESLint, Prettier, and
Stylelint. Prefer Composition API and Pinia; keep API clients under `src/api/`. Backend follows
module layering: interfaces in `service/`, implementations in `service/impl/`, and mappers in
`dal/`. Data objects extend `TenantBaseDO`, and MapStruct conversions live in `convert/`. Database
table prefixes are `system_` and `infra_`, and view objects belong in
`controller/admin/**/vo/`.

## Testing Guidelines
Backend tests live in `ruoyi-vue-pro-master-jdk17/**/src/test/java`, use JUnit 5 and Mockito via
`yudao-spring-boot-starter-test`, and follow `*Test.java` naming. Run `mvn test` from the backend
root. The frontend has no unit test script; rely on `pnpm ts:check` and linting.

## Commit & Pull Request Guidelines
Commit messages follow the existing `type: short description` pattern (example: `docs: add ...`).
Pull requests should include a brief summary, affected subprojects, verification commands run,
and screenshots for UI changes. Link related issues when applicable.

## Configuration & Security Notes
Backend configs live under `ruoyi-vue-pro-master-jdk17/yudao-server/src/main/resources/application*.yaml`;
frontend env files are `yudao-ui-admin-vue3-master/.env.*`. Do not commit secrets; use local
overrides (`application-local.yaml`, `.env.local`).
