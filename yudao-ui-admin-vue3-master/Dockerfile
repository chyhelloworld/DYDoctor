FROM node:20-alpine AS build
WORKDIR /app
COPY . .
RUN corepack enable && pnpm install && pnpm build:prod

FROM nginx:1.27-alpine
COPY --from=build /app/dist-prod /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
