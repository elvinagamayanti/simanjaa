# FROM docker/whalesay:latest
# LABEL Name=simanja Version=0.0.1
# RUN apt-get -y update && apt-get install -y fortunes
# CMD ["sh", "-c", "/usr/games/fortune -a | cowsay"]

FROM php:8.2-fpm-alpine AS simanja

# Install system dependencies
RUN apk update && apk add --no-cache \
    icu-dev \
    mariadb-dev \
    unzip \
    zip \
    zlib-dev \
    libpng-dev \
    libjpeg-turbo-dev \
    freetype-dev \
    oniguruma-dev \
    bash \
    libxml2-dev \
    autoconf \
    g++ \
    make \
    libzip-dev

# Install PHP extensions
RUN docker-php-ext-install \
    intl \
    pdo_mysql \
    zip \
    gd \
    opcache

# Configure gd with jpeg/png/freetype
RUN docker-php-ext-configure gd --with-jpeg --with-freetype

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy project files
COPY . .

# Give proper permissions
RUN chown -R www-data:www-data /var/www/html

# Expose port
EXPOSE 9000

CMD ["php-fpm"]

