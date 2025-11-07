# Stage 1: build the app with Node
FROM node:18-alpine AS build

WORKDIR /app

# copy package metadata first for layer caching
COPY package*.json ./

# install deps
RUN npm install --silent

# copy source
COPY . .

# build the app
RUN npm run build

# Stage 2: serve with nginx
FROM nginx:stable-alpine

# Copy custom nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy built static files from build stage
COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
