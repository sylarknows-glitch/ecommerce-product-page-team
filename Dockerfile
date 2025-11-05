# ---- Build Stage ----
FROM node:18-alpine AS build
WORKDIR /app

# Better layer caching + reproducible installs
COPY package*.json ./
RUN npm ci

# Copy source and build
COPY . .
ENV NODE_ENV=production
RUN npm run build

# ---- Runtime Stage ----
FROM nginx:1.27-alpine
COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
