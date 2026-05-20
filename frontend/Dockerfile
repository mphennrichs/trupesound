# Stage 1: Build the Flutter web application
FROM debian:latest AS build

RUN apt-get update && apt-get install -y \
    curl git unzip xz-utils zip libglu1-mesa \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

RUN flutter doctor

WORKDIR /app
COPY . .

RUN flutter pub get
RUN flutter gen-l10n
# Generate code for Riverpod and GoRouter
RUN flutter pub run build_runner build --delete-conflicting-outputs
RUN flutter build web --release

# Stage 2: Serve the application using Nginx
FROM nginx:stable-alpine

COPY --from=build /app/build/web /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]