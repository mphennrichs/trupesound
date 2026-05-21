# Stage 1: Build the Flutter web application
FROM debian:latest AS build

RUN apt-get update && apt-get install -y \
    curl git unzip xz-utils zip libglu1-mesa \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

WORKDIR /app

# Optimization: Pre-cache dependencies to speed up future builds
COPY pubspec.yaml pubspec.lock* ./
RUN flutter pub get

COPY . .
RUN flutter gen-l10n
# Generate code for Riverpod and GoRouter
RUN dart run build_runner build --delete-conflicting-outputs
RUN flutter build web --release

# Stage 2: Serve the application using Nginx
FROM nginx:stable-alpine

# Required for the healthcheck defined in compose.yml
RUN apk add --no-cache curl

# Configure Nginx to support Flutter Web routing (Single Page Application)
RUN echo 'server { \
    listen 80; \
    location / { \
        root /usr/share/nginx/html; \
        try_files $uri $uri/ /index.html; \
    } \
}' > /etc/nginx/conf.d/default.conf

COPY --from=build /app/build/web /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]